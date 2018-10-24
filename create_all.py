import digitalocean
import os, sys, subprocess, random

TOKEN = os.getenv("DO_TOKEN")
manager = digitalocean.Manager(token=TOKEN)

keys = manager.get_all_sshkeys()

droplets = ["local", "slave1", "slave2"]

for droplet in droplets :
    d = digitalocean.Droplet(token=TOKEN,
                               name="gen-docker-magneto-{}".format(droplet),
                               region='sfo2', # Amster
                            #    image='centos-7-x64' if droplet != 'glusterfs' else 'ubuntu-16-04-x64', # Ubuntu 14.04 x64
                               image='centos-7-x64', # Ubuntu 14.04 x64
                               size_slug='s-1vcpu-1gb',  # 512MB
                            #    size_slug='s-2vcpu-4gb',  # 512MB
                               ssh_keys=keys, #Automatic conversion
                               backups=False)

    d.create()

f =  open("hosts", "w")
my_droplets = manager.get_all_droplets()
print("=> {} machine(s) has been created : ".format(len(my_droplets)))
local_ip = ""
seen = []
slaves_ip = []
while len(seen) != len(my_droplets) :
    for droplet in my_droplets:
        if droplet.name in seen:
            continue
        else :
            print("#", end=" ")
            if droplet.status == "active":
                seen.append(droplet.name)
                print(" - {}".format(droplet.name))
                if "slave" in droplet.name:
                    slaves_ip.append(droplet.ip_address)
                elif "local" in droplet.name:
                    local_ip = droplet.ip_address
                    f.write("\n[local]\n{}\n".format(droplet.ip_address))
    my_droplets = manager.get_all_droplets()


f.write("\n[slaves]\n")
for ip in slaves_ip:
    f.write("{}\n".format(ip))


f.write("\n[swarm]\n")
f.write("{}\n".format(local_ip))
for ip in slaves_ip:
    f.write("{}\n".format(ip))

f.close()


domain = digitalocean.Domain(token=TOKEN)
domain.name = "ayoubensalem.com"
domain.ip_address = local_ip
try:
    d = domain.create()
except Exception as e:
    print(e)

print("=> ayoubensalem.com domain has been created.")
domain.create_new_domain_record(type="A", name="docker",data=local_ip)
print("=> docker.ayoubensalem.com domain has been created. ")

