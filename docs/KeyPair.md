

## Create a EC2 key pair and register it in AWS 


### Generating a new key

New key pairs can be generated using the ``ssh-keygen`` program

[keygen](  https://www.ssh.com/ssh/keygen/ )


From the root of the repo:

```shell
ssh-keygen -f ./credentials/main-ec2-key -C main-ec2-key
```

Or more secure:

```shell
ssh-keygen -t ecdsa -b 521
```

Options:
	-t algorithm e.g. rsa 
	-b bit length e.g. 4096
	-f /path/to/output_file 
	-N new passphrase
	-q   quiet mode
	-C label e.g. "email@example.com"

		
### Test the new key 

- Reference this module in a root module:

```
module "key_pair" {
  source = "../terraform/modules/key_pair"
}
```

- Once the key has been deployed using ``terraform apply``, create a temporary EC2 instance that uses that key

- Ssh into the EC2 instance

```shell
ssh -i ./credentials/main-ec2-key -l <user> <ec2-host>
```

[man shh]( https://man.openbsd.org/ssh )

