import digitalocean
import os, sys, subprocess, random

TOKEN = os.getenv("DO_TOKEN")
manager = digitalocean.Manager(token=TOKEN)

keys = manager.get_all_sshkeys()

droplets = ["target"]

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
target_ip = ""
seen = []

while len(seen) != len(my_droplets) :
    for droplet in my_droplets:
        if droplet.name in seen:
            continue
        else :
            print("#", end=" ")
            if droplet.status == "active":
                seen.append(droplet.name)
                print(" - {}".format(droplet.name))
                if "target" in droplet.name:
                    target_ip = droplet.ip_address
                    f.write("\n[target]\n{}\n".format(target_ip))
    my_droplets = manager.get_all_droplets()

f.close()


domain = digitalocean.Domain(token=TOKEN)
domain.name = "ayoubensalem.com"
domain.ip_address = target_ip
try:
    d = domain.create()
except Exception as e:
    print(e)

print("=> ayoubensalem.com domain has been created.")
domain.create_new_domain_record(type="A", name="docker",data=target_ip)
print("=> docker.ayoubensalem.com domain has been created. ")

