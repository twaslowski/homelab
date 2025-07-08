# Runbook

### One-time backup

```shell
kubectl annotate --overwrite -n vaultwarden postgrescluster postgres \
  postgres-operator.crunchydata.com/pgbackrest-backup="$(date)"
```

### Restart

```shell
kubectl patch postgrescluster/postgres-vaultwarden-postgres -n vaultwarden --type merge --patch '{"spec":{"metadata":{"annotations":{"restarted":"'"$(date)"'"}}}}'
```