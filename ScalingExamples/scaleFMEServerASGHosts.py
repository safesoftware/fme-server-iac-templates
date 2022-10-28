"""Scaling CPU-Usage (Dynamic) FME Server Engines (AWS)

This script allows the user scale CPU-Usage (Dynamic) FME Server Engines with
AWS ec2 Auto Scaling Groups (asg) based on the number of queued jobs for
a defined FME Server Queue.

The constants are retrieved form environment variables:

ASG_NAME        Name of the ec2 Auto Scaling Group
JOB_THRESHOLD   Threshold to scale the FME Server Engine either in or out 
QUEUE           Name of the FME Server Queue
FME_SERVER      FME Server URL
FME_TOKEN       FME Server token

This uses the FMEServerAPI.py as wrapper for the FME Server REST API
Required modules:
os
boto3
"""

import os
import boto3
from FMEServerAPI import FMEServer

ASG_NAME      = os.environ["ASG_NAME"]
JOB_THRESHOLD = os.environ["JOB_THRESHOLD"]
QUEUE         = os.environ["QUEUE"]
FME_SERVER    = os.environ["FME_SERVER"]
FME_TOKEN     = os.environ["FME_TOKEN"]

aws_autoscaling_client = boto3.client('autoscaling')
aws_ec2_client = boto3.resource('ec2')
fme_client = FMEServer(FME_SERVER, FME_TOKEN)

def activateScaleInProtection(instance_id: str) -> bool:
    """
    Protects an instance from scale in operations
    """
    if instance_id:
        aws_autoscaling_client.set_instance_protection(
            AutoScalingGroupName=ASG_NAME, InstanceIds=[instance_id],
            ProtectedFromScaleIn=True)
    else:
        return False
    return True

def deactivateScaleInProtection(instance_id: str) -> bool:
    """
    Remove protection from scale in
    """
    if instance_id:
        aws_autoscaling_client.set_instance_protection(
            AutoScalingGroupName=ASG_NAME, InstanceIds=[instance_id],
             ProtectedFromScaleIn=False)
    else:
        return False
    return True

def getInstanceId(hostname: str) -> str:
    """
    Retrieves an instance ID of the VMSS that matches the hostname of
    FME Server Engines 
    """
    asg = aws_autoscaling_client.describe_auto_scaling_groups(
        AutoScalingGroupNames=[ASG_NAME])
    instance_id = ""
    for i in asg["AutoScalingGroups"][0]["Instances"]:
        if aws_ec2_client.Instance(i["InstanceId"]).private_ip_address == hostname:
            instance_id = i["InstanceId"]     
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

def updateScaleSetCapacity(action: str, min_cap: int = 1) -> bool:
    """
    Update the scale in protection and scales the VMSS in or out based
    on the specified action
    """
    updateScaleInProtection()
    asg = aws_autoscaling_client.describe_auto_scaling_groups(
        AutoScalingGroupNames=[ASG_NAME])
    capacity = asg["AutoScalingGroups"][0]["DesiredCapacity"]
    if action == "scaleOut":
        aws_autoscaling_client.set_desired_capacity(
            AutoScalingGroupName=ASG_NAME, DesiredCapacity=capacity+1)
    elif action == "scaleIn":
        if capacity > min_cap:
            aws_autoscaling_client.set_desired_capacity(
                AutoScalingGroupName=ASG_NAME, DesiredCapacity=capacity-1)
        else:
           return False
    else:
        raise Exception ("Please specify scaleOut or scaleIn for action.")
    return True

def getQueuedJobs() -> int:
    """
    Returns the number of queued FME Server jobs in the specified queue
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

