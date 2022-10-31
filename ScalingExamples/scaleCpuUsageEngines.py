"""Scaling CPU-Usage (Dynamic) FME Server Engines

This script allows the user scale CPU-Usage (Dynamic) FME Server Engines on
a single existing host based on the number of queued jobs for a defined
FME Server Queue. The host to scale needs to be a manged node (Standard and)
CPU-Usage engines can be managed via the Web UI.

The constants are retrieved form environment variables:

JOB_THRESHOLD   Threshold to scale the FME Server Engine either in or out 
QUEUE           Name of the FME Server Queue
FME_SERVER      FME Server URL
FME_TOKEN       FME Server token

This uses the FMEServerAPI.py as wrapper for the FME Server REST API
Required modules:
os
"""

import os
from FMEServerAPI import FMEServer

JOB_THRESHOLD = os.environ["JOB_THRESHOLD"]
QUEUE         = os.environ["QUEUE"]
FME_SERVER    = os.environ["FME_SERVER"]
FME_TOKEN     = os.environ["FME_TOKEN"]

fme_client = FMEServer(FME_SERVER, FME_TOKEN)

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

def getEngineHosts() -> str:
    """
    Returns a list of FME Server engine hosts for a specific queue
    """
    engines = fme_client.get(
        "/fmerest/v3/transformations/engines?queue=" + QUEUE)
    engineHosts = []
    for i in engines:
        engineHosts.append(i["hostName"])
    return engineHosts

def scaleDynamicEngines(hostName: str, count: int) -> int:
    """
    Scales the CPU-Usage engines on the specified host to the specified count
    """
    payload = {'numEngines': count, 'type': 'dynamic'}
    req = fme_client.post(
        "/fmeapiv4/enginehosts/" + hostName + "/engines/scale", payload)
    print(req)
    return req

def updateDynamicEngines(action: str, min: int = 1, max: int = 10) -> bool:
    """
    Updates the first host with CPU-Usage engines by scaling in or out 
    based on the specified action. The min_cap is the minimum engine count
    for scale in.
    """
    if action == "scaleOut":
        scaleDynamicEngines(getEngineHosts()[0], max)
    elif action == "scaleIn":
        scaleDynamicEngines(getEngineHosts()[0], min)
    else:
        raise Exception ("Please specify scaleOut or scaleIn for action.")
    return True

def scale() -> bool:
    """
    Gets the number of queued jobs and updates the CPU-Usage engine count
    depending whether the number of queued jobs is below or over the specified
    threshold
    """
    queuedJobs = getQueuedJobs() 
    if queuedJobs > int(JOB_THRESHOLD):
        updateDynamicEngines("scaleOut")
    elif queuedJobs < int(JOB_THRESHOLD):
        updateDynamicEngines("scaleIn")
    else:
        return False
    return True

if __name__ == "__main__":
    scale()
