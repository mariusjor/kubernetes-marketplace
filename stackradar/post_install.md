## StackRadar

StackRadar shows the vulnerabilities on the images running in this cluster,
ranked by what to fix first (CVSS, EPSS and CISA KEV folded into one Radar
Score), with the chart version or image tag that fixes them. The scanner is
already watching this cluster.

### Open the dashboard

Verify everything is up:

```
$ kubectl -n stackradar get pods
NAME                                          READY   STATUS    RESTARTS   AGE
stackradar-client-...                         1/1     Running   0          3m
stackradar-postgresql-0                       1/1     Running   0          3m
stackradar-scanner-watcher-...                1/1     Running   0          3m
stackradar-server-...                         1/1     Running   0          3m
```

Forward the UI to your machine:

```
$ kubectl -n stackradar port-forward svc/stackradar-client 3000:3000
```

Open http://localhost:3000 and sign in as `admin@stackradar.local` with the
password `admin`. You are asked to change it before anything else loads.

A yellow strip says **Vulnerability database is being built** while the
server downloads OSV, EPSS and KEV in the background (5 to 25 minutes).
Meanwhile the Containers and Images pages already list what is running;
findings appear as the mirror goes live.

Every secret (session key, scanner key, database password) was generated
for this install; nothing is shared with other clusters.

### Further reading

- [Self-hosting guide](https://github.com/lockdep/stackradar/blob/main/docs/self-hosting/helm.md): Ingress, TLS, sign-in with GitHub, Google or OpenID Connect
- [Chart values reference](https://github.com/lockdep/helm-charts/blob/main/charts/stackradar/README.md)
- [Issues and support](https://github.com/lockdep/stackradar/issues)
