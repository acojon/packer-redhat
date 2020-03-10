# Used to get add-apt-repository command
echo "---apt-get update"
sudo apt-get update
echo "---Install software-properties-common"
sudo apt-get -y install software-properties-common

# Used for add-apt-repository
echo "--- apt-get install dirmngr"
sudo apt-get -y install dirmngr

# Install pip for python2 and python3
echo "--- apt-get install python-pip python3-pip"
sudo apt-get -y install python-pip python3-pip

# Install pywinrm, used by ansible to communicate with Windows
echo "---pip install pywinrm"
sudo pip install pywinrm

# Install python_hosts, used to modify the hosts file on ansibleTest
echo "---pip3 install python_hosts"
sudo pip3 install python_hosts

# Add the repository for ansible, and the key for the repository
echo "---add repository"
sudo add-apt-repository 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main'
echo "---add key"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

# Install ansible
echo "---update apt"
sudo apt-get update
echo "---Install ansible"
sudo apt-get -y install ansible
