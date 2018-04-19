- fix kube; may need to use kubespray or kops

https://kubernetes.io/docs/setup/pick-right-solution/
https://github.com/kubernetes-incubator/kubespray/blob/master/docs/comparisons.md

https://github.com/kubernetes-incubator/kubespray/tree/master/contrib/terraform/aws

https://github.com/opencredo/k8s-terraform-ansible-sample   # current seed - not prod ready
https://github.com/kelseyhightower/kubernetes-the-hard-way

https://coreos.com/tectonic/docs/latest/install/aws/index.html

https://stackpoint.io/clusters/new?solution=istio&utm_source=meetup&utm_medium=event_page&utm_campaign=sea_k8s

- finish spark module


- create route53 module

- https certs
https://letsencrypt.org/


- review all TODOs in Terraform


https://serialseb.com/blog/2016/05/11/terraform-working-around-no-count-on-module/

- do we need a NAT instance ?
- fix names in network module
- review users module
- review account module
- finish asg_elb module
- consider splitting asg part from bastion module into a separate module or use registry
- create data_storage
- remove fixes folder

- copy authorized_keys onto EC2 instances
- install python 2.x on EC2 instances for Ansible?
- finish setup-ansible script 

## TODO Helm

- review
https://github.com/eldada/jenkins-pipeline-kubernetes
https://github.com/eldada/jenkins-in-kubernetes
https://dzone.com/articles/easily-automate-your-cicd-pipeline-with-jenkins-he

- Consider using ``artifactory`` instead of Docker registry
