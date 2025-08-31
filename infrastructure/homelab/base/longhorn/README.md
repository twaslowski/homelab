Notes:

Unfortunately, Ingress is not feasible for Longhorn, because the only authentication mechanism is via an
annotation for the nginx ingress controller, which this cluster does not use.

Therefore, the way to access the Longhorn UI is via a port-forward command.

```shell
kubectl port-forward -n longhorn-system service/longhorn-frontend 8000:80
```