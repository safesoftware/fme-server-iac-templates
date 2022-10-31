import requests
import json

class FMEServer:
    """
    A simple wrapper for the FME Server REST API setting a default
    headers including the FME Token, handling pagination for GET
    requests and returning results for GET and status codes for POST,
    PUT and DELETE requests.

    Attributes
    ----------
    server : str
        FME Server hostname
    token : str
        FME Server token
    protocol : str
        HTTP or HTTPS protocol to be used for the API requests
        (Default http://)
    requestHeaders : dict
        Accept and Authorization headers for API requests

    Methods
    -------
    get(path, limit)
        Sends a GET requests to the FME Server REST API and returns
        the results. The limit parameter set the number of results
        returned by request.
    
    post(path, body)
        Sends a POST requests to the FME Server REST API and returns
        the status code.

    put(path, body)
        Sends a POST requests to the FME Server REST API and returns
        the status code.

    delete(path)
        Sends a POST requests to the FME Server REST API and returns
        the status code.
    """
    def __init__(self, server:str, token:str, protocol:str = "http://"):
        self.server = protocol + server
        self.token = token
        self.requestHeaders = {'Accept': 'application/json',
        'Authorization': 'fmetoken token={}'.format(self.token)}
        
    def get(self, path: str, limit: int = 100) -> list:
        result = []
        offset = 0
        totalCount = 0
        while offset <= totalCount:
            url = self.server + path + "&limit=" + str(limit) + "&offset=" + str(offset)
            req = json.loads(requests.get(
                url, headers=self.requestHeaders).content)
            for i in req["items"]:
                result.append(i)
            offset = offset + limit
            totalCount = req["totalCount"]
        return result

    def post(self, path: str, body: dict) -> int:
        url = self.server + path
        req = requests.post(
            url, headers=self.requestHeaders, json=body).status_code
        return req

    def put(self, path: str, body: dict) -> int:
        url = self.server + path
        req = requests.put(
            url, headers=self.requestHeaders,json=body).status_code
        return req
    
    def delete(self, path: str) -> int:
        url = self.server + path
        req = requests.delete(url, headers=self.requestHeaders).status_code
        return req