#! /usr/bin/env bash

# https://github.com/kubernetes/charts/tree/master/stable/pachyderm

helm install --namespace pachyderm stable/pachyderm

# --set credentials=s3,s3.accessKey=myaccesskey,s3.secretKey=mysecretkey,s3.bucketName=default_bucket,s3.endpoint=domain.subdomain:8080,etcd.persistence.enabled=true,etcd.persistence.accessMode=ReadWriteMany \stable/pachyderm