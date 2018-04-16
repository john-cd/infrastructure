# Ansible

## Useful Links

- [Ansible Cheatsheet]( https://gist.github.com/andreicristianpetcu/b892338de279af9dac067891579cad7d )
- [Ansible Guide]( https://devhints.io/ansible-guide )
- [Ansible Cheat Sheet](https://lzone.de/cheat-sheet/Ansible)
- [Ansible Cheat Sheet]( https://devhints.io/ansible )

Ansible roles shared repository: [Ansible Galaxy]( https://galaxy.ansible.com/ )

## Concepts

- Role is a set of tasks and additional files to configure host to serve for a certain role.
- Playbook is a mapping between hosts and roles.


## Install Ansible on Ubuntu on Windows

```shell
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
sudo apt-get update
```

Currently Ansible can be run from any machine with Python 2 (versions 2.6 or 2.7) or Python 3 (versions 3.5 and higher) installed. 
Windows isn’t supported for the control machine.

On the managed nodes, you need a way to communicate, which is normally ssh. By default this uses sftp. If that’s not available, you can switch to scp in ansible.cfg. 
You also need Python 2.6 or later.

## Configure Ansible

### Static hosts file (for testing)

Edit (or create) a ``hosts`` file and put one or more remote systems in it. 

```
192.0.2.50
aserver.example.org
bserver.example.org
```

The default location is ``/etc/ansible/hosts``. To override it, use ``export ANSIBLE_INVENTORY=ansible/inventory/hosts`` 
or use the ``-i`` command line option.


### AWS EC2 Dynamic Inventory 

[AWS EC2 dynamic inventory]( https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html#example-aws-ec2-external-inventory-script )

[ec2.py script]( https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py )

[ec2.ini]( https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini )

[AWS blog]( https://aws.amazon.com/blogs/apn/getting-started-with-ansible-and-dynamic-amazon-ec2-inventory-management/ )


- Install Python / Boto

```shell
sudo apt update
sudo apt upgrade
sudo apt-get remove python-pip  # avoid apt/pip confusion 
sudo easy_install pip
# optionally: pip install --upgrade pip
sudo pip install boto
sudo pip install boto3
```

- Copy ``ec2.py`` and ``ec2.ini`` into the ``ansible/inventory`` subdirectory

- Configure Boto (python library to control AWS)
 
From the root of the repo, 
 
```shell 
# note: does not seem to work
export AWS_SHARED_CREDENTIALS_FILE=$(pwd)/credentials/credentials
```

To choose a profile: ``export AWS_PROFILE="default"``

OR use directly

```shell
export AWS_ACCESS_KEY_ID='AK123'
export AWS_SECRET_ACCESS_KEY='abc123'
```

- Test the ec2.py script 

From the root of the repo,

```shell
./ansible/inventory/ec2.py --list
```

- Configure Ansible

```shell
export ANSIBLE_CONFIG=ansible/config/ansible.cfg
export ANSIBLE_INVENTORY=ansible/inventory
#export ANSIBLE_HOST_KEY_CHECKING=False
```

Check the configuration with

```shell
ansible-config view --config ./ansible/ansible.cfg
```

### Test Ansible

[Ansible options]( https://docs.ansible.com/ansible/latest/cli/ansible.html ):
	-u user
	-m module name (default=command)
	-a module arguments
	-i inventory

Test that Ansible can list AWS hosts: 

```shell
ansible all -i ansible/inventory --list-hosts
```

If the location given to ``-i`` in Ansible is a directory (or as so configured in ansible.cfg), Ansible can use multiple inventory sources at the same time. When doing so, it is possible to mix both dynamic and statically managed inventory sources in the same ansible run. 
In an inventory directory, executable files will be treated as dynamic inventory sources and most other files as static sources.

Ping all hosts:

```shell
ansible all -i ansible/inventory -m ping
```

Ping instances with the tag “Ansible Slave” applied to them:

```shell
ansible -m ping tag_Ansible_Slave
```

### Execute commands remotely with Ansible

The public SSH key should be located in ``authorized_keys`` on each remote host:

[authorized_keys file]( https://www.ssh.com/ssh/authorized_keys/ )
[authorized_keys in OpenSSH]( https://www.ssh.com/ssh/authorized_keys/openssh )

See [SSH Doc]( ./SSH.md )



- Test using

```shell
ansible all -i inventory -a "/bin/echo hello"
```

## Install Ansible roles

Example with Helm:

```shell
ansible-galaxy install andrewrothstein.kubernetes-helm --roles-path ./ansible/roles
```




