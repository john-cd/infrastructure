#! /usr/bin/env bash 

# This chart will do the following:
# 1 x Jenkins Master with port 8080 exposed on an external LoadBalancer
# All using Kubernetes Deployments
# https://hub.kubeapps.com/charts/stable/jenkins

helm install --name jenkins-release stable/jenkins