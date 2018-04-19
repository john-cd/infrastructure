## CFSSL: Cloudflare's PKI and TLS toolkit https://cfssl.org/

# Install on Linux

```shell
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

chmod +x cfssl_linux-amd64 cfssljson_linux-amd64

sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl

sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
```

## Verification

Verify cfssl version 1.2.0 or higher is installed:

```shell
cfssl version
```

output

Version: 1.2.0
Revision: dev
Runtime: go1.6
The cfssljson command line utility does not provide a way to print its version.