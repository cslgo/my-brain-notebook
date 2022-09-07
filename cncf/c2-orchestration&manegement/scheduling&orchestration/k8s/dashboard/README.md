[Kubernetes Deshboard](https://github.com/kubernetes/dashboard)
===

Kubernetes Dashboard is a general purpose, web-based UI for Kubernetes clusters. It allows users to manage applications running in the cluster and troubleshoot them, as well as manage the cluster itself.

## Getting Started

IMPORTANT: Read the [Access Control](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/README.md) guide before performing any further steps. The default Dashboard deployment contains a minimal set of RBAC privileges needed to run.

### Installation

To deploy Dashboard, execute following command:

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.1/aio/deploy/recommended.yaml
```

Alternatively, you can install Dashboard using Helm as described at https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard.

### Access

To access Dashboard from your local workstation you must create a secure channel to your Kubernetes cluster. Run the following command:

```shell
kubectl proxy
```

Now access Dashboard at:

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

### Create An Authentication Token (RBAC)

To find out how to create sample user and log in follow [Creating sample user](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md) guide.

NOTE:

* Kubeconfig Authentication method does not support external identity providers or certificate-based authentication.
* Metrics-Server has to be running in the cluster for the metrics and graphs to be available. Read more about it in Integrations guide.

