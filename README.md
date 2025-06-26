# homelab

This repository includes scripts and configuration to set up a k3s multi-node cluster on one or several nodes.

## Prerequisites

### Preparing your nodes

There's a few things you need to do before installing k3s.
Depending on your Linux distribution, you may need to install some additional packages and configure your system.

You should have the following packages installed on your nodes: `curl`, `git`, `ssh`.

Further, ensure that you have the same user on all nodes, and that you can SSH into each node without a password
(i.e. `authorized_keys` are set up correctly).

### Raspberry Pi

Raspberry Pi devices require some additional configuration to work properly with k3s. 
If you're using a Raspberry Pi, you need to ensure that the cgroup memory controller is enabled.
You'll need to modify `/boot/firmare/cmdline.txt` to include the following:

```shell
cgroup_memory=1 cgroup_enable=memory

# then reboot
sudo reboot
```

## Set up your cluster

Clone this repository to your:

```shell
git clone git@github.com:twaslowski/homelab.git && cd homelab
```

Additionally, ensure you have `task` installed on your system. You can find installation instructions
[here](https://taskfile.dev/installation/).

This repository uses the `Taskfile` to manage the setup of your k3s cluster. The `Taskfile.yml` defines several
tasks that you can run. Start out by installing `k3sup` to install and manage k3s on your nodes:

```shell
task install-k3sup
```

You're now ready to bootstrap your k3s cluster. You're going to want to create a leader node. If you're simply
creating a single-node cluster, that is going to be sufficient; for multi-node clusters, you'll want to attach
agents afterward.

### Bootstrapping the leader node

Running `task bootstrap-leader` will set up your leader node. This will install k3s and update your local kubeconfig
to point to the new cluster. You will need to provide several parameters in order for this command to work:

```shell
task bootstrap-leader -- --ip <IP_ADDRESS> --user <USER> --ssh-key <SSH_KEY>
```

Additional noteworthy arguments you could supply are `--no-extras` for skipping the installation of "_servicelb_"
and "_traefic_", as well as `--k3s-extra-args` to pass additional arguments to the k3s installation command.

If you would like to customize networking, you can pass args to flannel this way, such as `--flannel-backend=host-gw`
if you would like to avoid VXLAN encapsulation. You can find more information about the available flags
[here](https://github.com/alexellis/k3sup?tab=readme-ov-file#-setup-a-kubernetes-server-with-k3sup).

Documentation for the `k3s server` command (to which your --k3s-extra-args will be passed) can be found
[here](https://docs.k3s.io/cli/server).

After running the command, you should see a message indicating that the cluster has been set up successfully.
You can verify that the cluster is up and running by checking the status of the nodes:

```shell
kubectl get nodes
```

### Bootstrapping agent nodes

```shell
task bootstrap-agent -- --ip <IP_ADDRESS> --user <USER> --server-ip <LEADER_IP>
```

## Running services