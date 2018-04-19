#! /usr/bin/env bash

# https://github.com/kubernetes/charts/tree/master/stable/traefik 

helm install --name traefik-release \ 
			 --namespace kube-system \
			 --values values.yaml
			 # --set dashboard.enabled=true, dashboard.domain=traefik.example.com  #TODO
			 stable/traefik 

kubectl get svc traefik-release --namespace kube-system -w

kubectl describe service my-release-traefik -n kube-system | grep Ingress | awk '{print $3}'