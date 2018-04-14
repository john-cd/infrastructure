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

### Static hosts file

Edit (or create) a ``hosts`` file and put one or more remote systems in it. 

```
192.0.2.50
aserver.example.org
bserver.example.org
```

The default location is ``/etc/ansible/hosts``


### AWS EC2 Dynamic Inventory 

[AWS EC2 dynamic inventory]( https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html#example-aws-ec2-external-inventory-script )

[ec2.py script]( https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py )

- Copy ``ec2.py`` into an ``inventory`` subdirectory

- Test the script 

```shell
./inventory/ec2.py --list
```

or 

```shell
ansible -i inventory --list-hosts
```

If the location given to ``-i`` in Ansible is a directory (or as so configured in ansible.cfg), Ansible can use multiple inventory sources at the same time. When doing so, it is possible to mix both dynamic and statically managed inventory sources in the same ansible run. 
In an inventory directory, executable files will be treated as dynamic inventory sources and most other files as static sources.

### SSH Keys

Your public SSH key should be located in ``authorized_keys`` on each remote host:

[authorized_keys file]( https://www.ssh.com/ssh/authorized_keys/ )
[authorized_keys in OpenSSH]( https://www.ssh.com/ssh/authorized_keys/openssh )

#### Generating a new key

New key pairs can be generated using the ``ssh-keygen`` program

[keygen](  https://www.ssh.com/ssh/keygen/ )

```shell
ssh-keygen 
#or more secure:
ssh-keygen -t ecdsa -b 521
```

Options:
	-t algorithm e.g. rsa 
	-b bit length e.g. 4096
	-f /path/to/file 
	-N new passphrase
	-q   quiet mode
	-C "label"
	
The ``ssh-copy-id`` tool can then be used for copying keys in an ``authorized_keys`` file on a remote server. 

[ssh-copy-id]( https://www.ssh.com/ssh/copy-id )

```shell
ssh-copy-id -i ~/.ssh/id_rsa user@host
```

The default location of the ``authorized_keys`` file is ``~/.ssh/authorized_keys``


#### Test the new key

```shell
ssh -i ~/.ssh/mykey user@host
```

#### Adding the key to ``ssh-agent``

[ssh-agent]( https://www.ssh.com/ssh/agent )

```shell
# start the ssh-agent in the background
eval `ssh-agent` 

#or: eval $(ssh-agent -s)

Add your SSH private key to the ssh-agent.
ssh-add ~/.ssh/id_rsa 
ssh-add -l
```

### Test Ansible

```shell
ansible -i inventory -m ping
ansible all -i inventory -a "/bin/echo hello"
```

[Ansible options]( https://docs.ansible.com/ansible/latest/cli/ansible.html ):
	-u user
	-m module name (default=command)
	-a module arguments
	-i inventory

To override the remote user name, just use the ‘-u’ parameter.


## Install Ansible roles


Example with Helm:

```shell
ansible-galaxy install andrewrothstein.kubernetes-helm --roles-path ./roles
```




