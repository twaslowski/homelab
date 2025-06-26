# core

This document gives you an overview over **some** of the core components of this homelab project.

## Contents

- [Cloudflare Tunnel Ingress Controller](#cloudflare-tunnel-ingress-controller)
- [Prometheus](#prometheus)
- [Grafana](#grafana)

## Cloudflare Tunnel Ingress Controller

Cloudflare Tunnels allow you to proxy traffic into your network from Cloudflare's edge network.
This enables you to route traffic to your services without exposing them to the public internet.

This document helps you set up the `cloudflare-tunnel-ingress-controller`, which will create a Cloudflare Tunnel
and corresponding DNS entries based on your Kubernetes configuration. You will be able to simply specify an
`ingress.yaml` and traffic will be routed to your services as per your specifications.

### Prerequisites

You have to retrieve an API token and your account id from your Cloudflare Account. For that, you have to go
to your account overview:

![Cloudflare Account Overview](../assets/cloudflare-account-id.png)

Then you have to click on the "API Tokens" tab and create a new token with the following permissions:

- Zone:Zone:Read
- Zone:DNS:Edit
- Account:Cloudflare Tunnel:Edit

Provide these as values when applying Terraform:

```shell
export TF_VAR_cloudflare_api_token="<cloudflare-api-token>"
export TF_VAR_cloudflare_account_id="<cloudflare-account-id>"
```

Note that the Tunnel will be created if it does not already exist.

## Prometheus

Prometheus is a monitoring and alerting toolkit. It collects metrics from configured targets at given intervals, 
evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

This guide helps you set up a Prometheus instance on your Cluster using Helm.

### Scraping Services

To scrape services, you need to add annotations to your Kubernetes resources. For example, to scrape a service, add the following annotations:

```yaml
metadata:
  annotations:
    annotations:
    prometheus.io/path: /actuator/prometheus
    prometheus.io/port: "8080"
    prometheus.io/scrape: "true"
```

This will scrape the service at the `/actuator/prometheus` path on port `8080`.

Check out the guide on [Grafana](#../grafana/README.md) to learn how to visualize the metrics collected by Prometheus.

## Grafana

Grafana is an open-source analytics and monitoring platform. It allows you to query, visualize, alert on,
and understand your metrics no matter where they are stored.
In this guide, you will learn how to set up Grafana on your Cluster using Helm.

### Login

```bash
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

In order to access Grafana to view your dashboards, you can either port-forward into the service,
use a LoadBalancer or the Cloudflared tunnel to expose the service to the internet.
