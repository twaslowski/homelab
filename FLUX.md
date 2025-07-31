# Flux Migration from Terraform

This directory contains the Flux configuration that replaces the Terraform setup in `terraform/core`. 

## Migration Overview

The following Terraform resources have been migrated to Flux:

### Infrastructure Components

- **Namespaces**: All required namespaces (logging, grafana, prometheus, postgres-operator, cloudflare-tunnel-ingress-controller)
- **Helm Repositories**: Chart sources for Grafana, Prometheus, Fluent, and Cloudflare
- **Cloudflared**: Cloudflare Tunnel Ingress Controller

### Applications

- **Grafana**: Observability dashboard with persistence and ingress
- **Prometheus**: Metrics collection and monitoring
- **Logging Stack**: Fluent Bit for log collection and Loki for log aggregation
- **PostgreSQL Operator**: Database operator using your custom chart

## Directory Structure

```
flux/
├── infrastructure/           # Core infrastructure components
│   ├── namespaces/          # Kubernetes namespaces
│   ├── sources/             # Helm repository sources
│   └── cloudflared/         # Cloudflare tunnel controller
└── apps/                    # Application deployments
    ├── grafana/             # Grafana deployment
    ├── prometheus/          # Prometheus deployment
    ├── logging/             # Fluent Bit and Loki
    └── postgres-operator/   # PostgreSQL operator
```

## Secret Management

**Important**: The Cloudflare credentials are currently configured as a placeholder secret in `flux/infrastructure/cloudflared/helmrelease.yaml`. You need to:

1. **Option 1 - Sealed Secrets**: Use sealed-secrets to encrypt the values
2. **Option 2 - External Secrets**: Use external-secrets-operator with your secret store
3. **Option 3 - SOPS**: Use SOPS to encrypt the secret values in Git

Example with kubectl (temporary solution):

```bash
kubectl create secret generic cloudflare-credentials \
  --namespace=cloudflare-tunnel-ingress-controller \
  --from-literal=apiToken="your-cloudflare-api-token" \
  --from-literal=accountId="your-cloudflare-account-id"
```

## Configuration Differences from Terraform

### Terraform Variables → Flux Values
- Terraform variables are now embedded in ConfigMaps or Secrets
- Sensitive values (Cloudflare credentials) moved to Kubernetes Secrets
- Values files are embedded as ConfigMaps for easier GitOps management

### Dependencies
- Flux automatically handles dependency ordering through namespace creation
- No need for explicit `depends_on` like in Terraform
- Helm repositories are created before applications that use them

### Local Chart Reference
The PostgreSQL operator uses your local chart at `charts/pgo`. This is handled by:
1. Creating a GitRepository source pointing to your homelab repository
2. Referencing the chart path `charts/pgo` in the HelmRelease

## Deployment Process

1. **Bootstrap Flux** (if not already done):
   ```bash
   task flux:bootstrap
   ```

2. **Apply the configuration**:
   ```bash
   # Flux will automatically sync from Git
   # Or force sync:
   flux reconcile source git flux-system
   ```

3. **Set up secrets** (choose one method above)

4. **Monitor deployment**:
   ```bash
   flux get helmreleases --all-namespaces
   watch kubectl get pods --all-namespaces
   ```

## Maintenance

### Updating Applications
- Update chart versions in the respective HelmRelease files
- Flux will automatically apply changes when committed to Git

### Adding New Applications
1. Create a new directory under `flux/apps/`
2. Add HelmRelease and ConfigMap for values
3. Update `flux/apps/kustomization.yaml` to include the new app

### Troubleshooting
```bash
# Check Flux status
flux get all

# Check specific HelmRelease
flux get helmrelease grafana -n grafana

# Check events
kubectl events -n <namespace>

# Force reconciliation
flux reconcile helmrelease <name> -n <namespace>
```

## Benefits of Flux over Terraform

1. **GitOps Native**: True GitOps workflow with automatic reconciliation
2. **Kubernetes Native**: Better integration with Kubernetes RBAC and features
3. **Real-time Sync**: Continuous monitoring and drift correction
4. **Better Secret Management**: Integration with Kubernetes secret management
5. **Dependency Handling**: Automatic dependency resolution
6. **Rollback Capabilities**: Easy rollback through Git history

## Migration Checklist

- [ ] Bootstrap Flux
- [ ] Apply initial configuration
- [ ] Set up Cloudflare credentials secret
- [ ] Verify all applications are deployed successfully
- [ ] Test ingress connectivity (Grafana)
- [ ] Verify logging pipeline (Fluent Bit → Loki)
- [ ] Test PostgreSQL operator functionality
- [ ] Remove old Terraform state (after verification)

## Rollback Plan

If needed, you can temporarily rollback to Terraform:
1. Scale down Flux controllers: `flux suspend kustomization flux-system`
2. Re-apply Terraform configuration
3. Clean up Flux resources if needed

The Terraform configuration remains unchanged in `terraform/core` for reference.
