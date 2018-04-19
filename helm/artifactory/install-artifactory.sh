#! /usr/bin/env bash
#! /usr/bin/env bash

# Create a Docker registry secret called 'regsecret'
# TODO kubectl create secret docker-registry regsecret --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>

# Install Artifactory
# https://github.com/kubernetes/charts/tree/master/stable/artifactory
# https://jfrog.com/

helm install --name artifactory \
               --set artifactory.image.repository=docker.bintray.io/jfrog/artifactory-oss \
               --set artifactory.resources.requests.cpu="500m" \
               --set artifactory.resources.limits.cpu="2" \
               --set artifactory.resources.requests.memory="1Gi" \
               --set artifactory.resources.limits.memory="4Gi" \
               --set artifactory.javaOpts.xms="1g" \
               --set artifactory.javaOpts.xmx="4g" \
               --set nginx.resources.requests.cpu="100m" \
               --set nginx.resources.limits.cpu="250m" \
               --set nginx.resources.requests.memory="250Mi" \
               --set nginx.resources.limits.memory="500Mi" \
# TODO			   --set imagePullSecrets=regsecret \  
               stable/artifactory
			   
			   
# TODO --set postgresql.postgresPassword=12_hX3jvs7QJ4YerQ2


# TODO -set ingress.enabled=true \
# TODO   --set ingress.hosts[0]="artifactory.company.com" \
# TODO   --set artifactory.service.type=NodePort \
# TODO  --set nginx.enabled=false \
			   
			   
