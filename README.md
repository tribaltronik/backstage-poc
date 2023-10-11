# Backstage POC

Links
https://github.com/guymenahem/how-to-devops-tools/tree/main/backstage

https://roadie.io/blog/backstage-service-catalog-kubernetes/

## Requirements
- Docker
- Make
- Helm

## Initial config

Create cluster and run all commands
```bash
make kubernetes-plugin
```


Replace the token "serviceAccountToken" and "url" on app-config.local.yaml
```yaml
kubernetes:
 serviceLocatorMethod:
   type: 'multiTenant'
 clusterLocatorMethods:
   - type: 'config'
     clusters:
       - url: https://127.0.0.1:61421
         name: local
         authProvider: serviceAccount
         skipTLSVerify: true
         skipMetricsLookup: true
         serviceAccountToken: <token>
```

## Config Sign-in with Github
Replace the token "clientId" and "clientSecret" on app-config.local.yaml
```yaml
auth:
  # see https://backstage.io/docs/auth/ to learn about auth providers
  environment: development
  providers: 
    github:
      development:
        clientId: <client id>
        clientSecret: <client secret>
```

## Development

yarn dev


## Test Backstage kubernetes plugin

```bash
make kubernetes-plugin
```
## Option 1 - Install helm chart

https://github.com/backstage/charts/tree/main/charts/backstage

```bash
make all-helm
```


## Option 2 - Build local 

```bash
make all-local
```

Component 
https://github.com/tribaltronik/backstage-poc/blob/main/kubernetes/user-api-component.yaml


## Install kubernetes

https://backstage.io/docs/features/kubernetes/installation/#adding-the-kubernetes-frontend-plugin

