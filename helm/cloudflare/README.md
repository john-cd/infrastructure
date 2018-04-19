# Cloudflare Ingress Controller


## Useful Links

[GitHub]( https://github.com/cloudflare/cloudflare-ingress-controller )

[Documentation]( https://developers.cloudflare.com/argo-tunnel/reference/kubernetes/ )

[Cloudflare Blog]( https://blog.cloudflare.com/cloudflare-ingress-controller/ )

[Stackpoint Blog]( https://blog.stackpoint.io/stackpoint-io-makes-it-easy-to-use-cloudflare-warp-as-a-secure-kubernetes-load-balancer-7e37faa544b0 )


## Config

Within Kubernetes, creating an ingress with ``annotation kubernetes.io/ingress.class: cloudflare-warp`` will automatically create secure Warp tunnels to Cloudflare for any service using that ingress
