# homelab

This repository includes scripts and configuration to set up a k3s multi-node cluster on one or several nodes.

It also includes a set of core services that are useful for a homelab setup and will give you a solid foundation
to build upon.

## Table of Contents

- [homelab](#homelab)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
    - [Installed software](#installed-software)
    - [Preparing your nodes](#preparing-your-nodes)
    - [Raspberry Pi](#raspberry-pi)
  - [Set up your cluster](#set-up-your-cluster)
    - [Bootstrapping the leader node](#bootstrapping-the-leader-node)
    - [Bootstrapping agent nodes](#bootstrapping-agent-nodes)
  - [Setting up core](#setting-up-core)

## Prerequisites

### Installed software

You need the following software installed on your local machine:

- [k3sup](https://github.com/alexellis/k3sup) - a utility to install and manage k3s clusters
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - the Kubernetes command-line tool
- [flux](https://fluxcd.io/docs/installation/) - a tool to manage Kubernetes clusters declaratively

Optional, but recommended:
- [task](https://taskfile.dev/) - a task runner to manage the setup of your cluster
- [age](https://age-encryption.org/) - a simple, modern and secure file encryption tool
- An AWS Account to set up reliable storage for backups, external secrets management and more.
- Remote machines that you can SSH into. However, you can also run all of this locally.

You should create a fork of this repository to your GitHub account and clone it to your local machine.

```shell
git clone git@github.com:<your-account>/homelab.git
```

## Preparing your nodes

If you're setting up a k3s cluster on a remote node, you need to ensure that the node is prepared for the installation.

There's a few things you need to do before installing k3s.
Depending on your Linux distribution, you may need to install some additional packages and configure your system.

You should have the following packages installed on your nodes: `curl`, `git`, `ssh`.

Further, ensure that you have the same user on all nodes, and that you can SSH into each node without a password
(i.e. `authorized_keys` are set up correctly). For instructions on how to set up SSH keys, see
[this article](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

### Raspberry Pi

Raspberry Pi devices require some additional configuration to work properly with k3s.
If you're using a Raspberry Pi, you need to ensure that the cgroup memory controller is enabled.
You'll need to modify `/boot/firmare/cmdline.txt` to include the following:

```shell
cgroup_memory=1 cgroup_enable=memory

# then reboot
sudo reboot
```

Additionally, for fluent-bit to work properly on Raspberry Pi, you may need to add the following line to your
`/boot/firmware/config.txt` file:

```shell
kernel=kernel8.img
```

## Set up your cluster

You're now ready to set up your k3s cluster! If you do not have `task` installed, you can run the commands
from the following sections manually.

### Bootstrapping the leader node

Running `task bootstrap-leader` will set up your leader node. This will install k3s and update your local kubeconfig
to point to the new cluster. You will need to provide several parameters in order for this command to work:

```shell
export IP_ADDRESS=<IP_ADDRESS>  # IP address of the leader node
export USER=<USER>  # SSH user to connect to the node
export SSH=<SSH_KEY>  # Path to the SSH private key to use for authentication

task bootstrap-leader -- --ip "$IP_ADDRESS" \
  --user "$USER" --ssh-key "$SSH_KEY"
```

By default, the `bootstrap-leader` task will install k3s with the following parameters:

```shell
--no-extras  # disable servicelb and traefik
--context homelab  # set the context name in kubeconfig
--local-path ~/.kube/config  # write new cluster config to ~/.kube/config
--merge  # do not overwrite existing kubeconfig, but merge the new cluster into it
```

You can pass extra arguments to your k3 install by supplying the `--k3s-extra-args`
flag. Any networking configuration you want to do should be passed through this flag as well.
This pertains in particular to flannel, which is the default CNI (Container Network Interface) used by k3s.

If you would like to customize networking, you can pass args to flannel this way, such as `--flannel-backend=host-gw`
if you would like to avoid VXLAN encapsulation. You can find more information about the available flags
[here](https://github.com/alexellis/k3sup?tab=readme-ov-file#-setup-a-kubernetes-server-with-k3sup).

Documentation for the `k3s server` command (to which your --k3s-extra-args will be passed) can be found
[here](https://docs.k3s.io/cli/server).

After running the command, you should see a message indicating that the cluster has been set up successfully.
You can verify that the cluster is up and running by checking the status of the nodes:

```shell
kubectl config use-context homelab
kubectl get nodes
```

The output of this command should show the leader node as `Ready`:

```text
NAME             STATUS   ROLES                  AGE   VERSION        INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION       CONTAINER-RUNTIME
homelab-leader    Ready    <none>                 1m   v1.32.5+k3s1   192.168.178.100   <none>        Debian GNU/Linux 12 (bookworm)   6.12.25+rpt-rpi-v8   containerd://2.0.5-k3s1.32
```

### Bootstrapping agent nodes

Bootstrapping agent nodes is super straightforward now.
All you need is the IP address of the leader node, everything else is the same as for the leader node.

```shell
# These are identical to the values above
export IP_ADDRESS=<IP_ADDRESS>  # IP address of the agent node
export USER=<USER>  # SSH user to connect to the node
export SSH_KEY=<SSH_KEY>  # Path to the SSH private key to use for authentication

export LEADER_IP=<LEADER_IP>  # IP address of the leader

task bootstrap-agent -- --ip "$IP_ADDRESS" --user "$USER" --server-ip "$LEADER_IP" --ssh-key "$SSH_KEY"
```

## Populating the cluster

After confirming that the cluster is up and running, you can start populating it with services.
This repository comes with a setup for Flux to manage your cluster declaratively.

The `infrastructure/` directory contains the Flux configuration that will set up:

- [Prometheus](https://prometheus.io/) - a powerful monitoring and alerting toolkit
- [Loki](https://grafana.com/oss/loki/) - a log aggregation system
- [fluent-bit](https://fluentbit.io/) - a lightweight log processor and forwarder
- [metallb](https://metallb.universe.tf/) - a load balancer to provide you with a stable IP address for your services

### Extended configuration

There are some additional tools that you can set up to enhance your homelab experience.
These require accounts on external services, but they can be very useful:

- [cloudflare-ingress-controller](https://github.com/STRRL/cloudflare-tunnel-ingress-controller) - an ingress controller
  for [Cloudflare tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) to expose our services to the internet without having to open ports on your router
- [cert-manager](https://cert-manager.io/) - a tool to manage TLS certificates for your services