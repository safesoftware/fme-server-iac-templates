"""Scaling CPU-Usage (Dynamic) FME Flow Engines (Azure)

This script allows the user scale CPU-Usage (Dynamic) FME Flow Engines with
Azure Virtual Machine Scale Sets (VMSS) based on the number of queued jobs for
a defined FME Flow Queue.

The constants are retrieved form environment variables:

RG_NAME         Name of the Azure Resource Group
VMSS_NAME       Name of the Virtual Machnine Scale Set
JOB_THRESHOLD   Threshold to scale the FME Flow Engine either in or out 
QUEUE           Name of the FME Flow Queue
SUBSCRIPTION_ID Azure Subscription ID
FME_SERVER      FME Flow URL
FME_TOKEN       FME Flow token

This uses the FMEServerAPI.py as wrapper for the FME Flow REST API
Required modules:
os
azure-identity
azure-mgmt-compute
"""

import os
from azure.mgmt.compute import ComputeManagementClient
from azure.identity import DefaultAzureCredential
from FMEServerAPI import FMEServer

RG_NAME         = os.environ["RG_NAME"]
VMSS_NAME       = os.environ["VMSS_NAME"]
JOB_THRESHOLD   = os.environ["JOB_THRESHOLD"]
QUEUE           = os.environ["QUEUE"]
SUBSCRIPTION_ID = os.environ["SUBSCRIPTION_ID"]
FME_SERVER      = os.environ["FME_SERVER"]
FME_TOKEN       = os.environ["FME_TOKEN"]

credential = DefaultAzureCredential()
compute_client = ComputeManagementClient(credential, SUBSCRIPTION_ID)
fme_client = FMEServer(FME_SERVER, FME_TOKEN)

def activateScaleInProtection(instance_id: str) -> bool:
    """
    Protects an instance from scale in operations
    """
    if instance_id:
        vm = compute_client.virtual_machine_scale_set_vms.get(
            RG_NAME,VMSS_NAME, instance_id)
        vm.protection_policy = {'protect_from_scale_in':True}
        compute_client.virtual_machine_scale_set_vms.begin_update(
            RG_NAME, VMSS_NAME, instance_id, vm)
    else:
        False
    return True

def deactivateScaleInProtection(instance_id: str) -> bool:
    """
    Remove protection from scale in
    """
    if instance_id:
        vm = compute_client.virtual_machine_scale_set_vms.get(
            RG_NAME,VMSS_NAME, instance_id)
        vm.protection_policy = {'protect_from_scale_in':False}
        compute_client.virtual_machine_scale_set_vms.begin_update(
            RG_NAME, VMSS_NAME, instance_id, vm)
    else:
        False
    return True

def getInstanceId(hostname: str) -> str:
    """
    Retrieves an instance ID of the VMSS that matches the hostname of
    FME Flow Engines 
    """
    vms = compute_client.virtual_machine_scale_set_vms.list(
        RG_NAME, VMSS_NAME)
    instance_id = ""
    for i in vms:
        if i.os_profile.computer_name == hostname:
            instance_id = i.id.split("/")[-1]      
    return instance_id

def updateScaleInProtection() -> bool:
    """
    Retrieves available engines and their hostnames and activates or
    deactivates the scale in protection setting of matching instances
    based on their state (running a job or idle)
    """
    fmeServerHosts = fme_client.get("/fmeapiv4/engines?")
    for i in fmeServerHosts:
        if i["state"] == "running_job":
            activateScaleInProtection(getInstanceId(i["hostname"]))
        elif i["state"] == "idle":
            deactivateScaleInProtection(getInstanceId(i["hostname"]))
    return True

def updateScaleSetCapacity(action: str, min_cap: int = 0) -> bool:
    """
    Update the scale in protection and scales the VMSS in or out based
    on the specified action
    """
    vmss = compute_client.virtual_machine_scale_sets.get(RG_NAME, VMSS_NAME)
    if action == "scaleOut":
        vmss.sku.capacity += 1
    elif action == "scaleIn":
        updateScaleInProtection()
        if vmss.sku.capacity > min_cap:
            vmss.sku.capacity -= 1
        else:
           return False
    else:
        raise Exception ("Please specify scaleOut or scaleIn for action.")
    compute_client.virtual_machine_scale_sets.begin_create_or_update(
        RG_NAME, VMSS_NAME, vmss)
    return True

def getQueuedJobs() -> int:
    """
    Returns the number of queued FME Flow jobs in the specified queue
    """
    queuedJobs = fme_client.get("/fmeapiv4/jobs?&status=queued")
    queuedJobsCount = 0
    for i in queuedJobs:
        if i["queue"] == QUEUE:
            queuedJobsCount += 1
    return queuedJobsCount

def scale() -> bool:
    """
    Gets the number of queued jobs and updates the VMSS depending whether the
    number of queued jobs is below or over the specified threshold
    """
    queuedJobs = getQueuedJobs() 
    if queuedJobs > int(JOB_THRESHOLD):
        updateScaleSetCapacity("scaleOut")
    elif queuedJobs < int(JOB_THRESHOLD):
        updateScaleSetCapacity("scaleIn")
    else:
        return False
    return True

if __name__ == "__main__":
    scale()