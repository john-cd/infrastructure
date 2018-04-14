
## Install Kubernetes on AWS

## After deployment

Cluster credentials are written beneath the generated/ directory, including any generated CA certificate and a kubeconfig file. You can use this to access the cluster with kubectl. This is the only method of access for a Kubernetes cluster installed without Tectonic features:

```shell
export KUBECONFIG=generated/auth/kubeconfig
kubectl cluster-info
```