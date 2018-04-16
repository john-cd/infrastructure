## SSH Keys

### Generating a new key

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


### Test the new key

```shell
chmod 400 credentials/credentials
 
ssh -i credentials/credentials ec2-user@<host>
```

### Adding the key to ``ssh-agent``

Using an SSH agent is the best way to authenticate with your end nodes, as this alleviates the need to copy your .pem files around. To add an agent, do

- [ssh-agent]( https://www.ssh.com/ssh/agent )
- [Using SSH agent forwarding]( https://developer.github.com/v3/guides/using-ssh-agent-forwarding/ )


Start the ssh-agent in the background

```shell
eval `ssh-agent` 

#or: eval $(ssh-agent -s)
```

Add your SSH private key to the ``ssh-agent``

```shell
ssh-add credentials/<keyfile.pem> 
# list the fingerprints of all keys
ssh-add -l
ssh-agent bash
```
