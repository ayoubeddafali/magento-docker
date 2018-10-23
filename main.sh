echo "Provisionning DO droplets "

python create_all.py

echo "Starting Installation Of Dockerized Magento Components"

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_SSH_RETRIES=5

ansible-playbook -i hosts main.yml
ansible-playbook -i hosts swarm/swarm-playbook/stack.yml
