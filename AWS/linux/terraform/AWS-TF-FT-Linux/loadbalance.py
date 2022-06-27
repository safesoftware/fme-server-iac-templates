import requests

if __name__ == "__main__":
    name_file = open("loadbalance.cfg", "r")
    dns_names = name_file.readlines()
    flag = False
    if len(dns_names) > 10:
        flag = True
    requestHeaders = {'Accept': 'application/json'}
    for dns in dns_names:
        finalURL = "http://" + dns.rstrip() + ":8080/fmerest/v3/healthcheck?ready=false&textResponse=false"
        try:
            response = requests.get(finalURL, headers=requestHeaders)
            if response.ok is not True:
                dns_names.remove(dns)
        except:
            dns_names.remove(dns)
    if flag:
        name_file.seek(0)
        name_file.truncate(0)
        name_file.writelines(dns_names)
    index_file = open("index.cfg", "r+")
    index = int(index_file.read(1))
    print(dns_names[index].rstrip())
    index_file.seek(0)
    index_file.truncate()
    index_file.write(str((index+1)%len(dns_names)))
    index_file.close()
    name_file.close()
    