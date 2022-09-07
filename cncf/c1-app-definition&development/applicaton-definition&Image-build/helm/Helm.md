Helm
===

Helm is the best way to find, share, and use software built for Kubernetes.


## Three Big Concepts


**A Chart is a Helm package.** It contains all of the resource definitions necessary to run an application, tool, or service inside of a Kubernetes cluster. Think of it like the Kubernetes equivalent of a Homebrew formula, an Apt dpkg, or a Yum RPM file.

**A Repository is the place where charts can be collected and shared.** It's like Perl's CPAN archive or the Fedora Package Database, but for Kubernetes packages.

**A Release is an instance of a chart running in a Kubernetes cluster.** One chart can often be installed many times into the same cluster. And each time it is installed, a new release is created. Consider a MySQL chart. If you want two databases running in your cluster, you can install that chart twice. Each one will have its own release, which will in turn have its own release name.

With these concepts in mind, we can now explain Helm like this:

___Helm installs charts into Kubernetes, creating a new release for each installation. And to find new charts, you can search Helm chart repositories.___

## Finding Charts

Helm comes with a powerful search command. It can be used to search two different types of source:

`helm search hub` searches the Artifact Hub, which lists helm charts from dozens of different repositories.

`helm search repo` searches the repositories that you have added to your local helm client (with helm repo add). This search is done over local data, and no public network connection is needed.

You can find publicly available charts by running helm search hub:

```shell
helm search hub wordpress
```

Using helm search repo, you can find the names of the charts in repositories you have already added:

```shell
helm repo add brigade https://brigadecore.github.io/charts
helm search repo brigade
```

## Installing a Package

To install a new package, use the helm install command. At its simplest, it takes two arguments: A release name that you pick, and the name of the chart you want to install.

```shell
helm install happy-panda bitnami/wordpress
```

Helm installs resources in the following order:

```Namespace
NetworkPolicy
ResourceQuota
LimitRange
PodSecurityPolicy
PodDisruptionBudget
ServiceAccount
Secret
SecretList
ConfigMap
StorageClass
PersistentVolume
PersistentVolumeClaim
CustomResourceDefinition
ClusterRole
ClusterRoleList
ClusterRoleBinding
ClusterRoleBindingList
Role
RoleList
RoleBinding
RoleBindingList
Service
DaemonSet
Pod
ReplicationController
ReplicaSet
Deployment
HorizontalPodAutoscaler
StatefulSet
Job
CronJob
Ingress
APIService
```

Helm does not wait until all of the resources are running before it exits. Many charts require Docker images that are over 600M in size, and may take a long time to install into the cluster.

```shell
helm status happy-panda
```


### Customizing the Chart Before Installing

nstalling the way we have here will only use the default configuration options for this chart. Many times, you will want to customize the chart to use your preferred configuration.

To see what options are configurable on a chart, use helm show values:

```shell
helm show values bitnami/wordpress
```

You can then override any of these settings in a YAML formatted file, and then pass that file during installation.

```shell
echo '{mariadb.auth.database: user0db, mariadb.auth.username: user0}' > values.yaml
helm install -f values.yaml bitnami/wordpress --generate-name
```
The above will create a default MariaDB user with the name user0, and grant this user access to a newly created user0db database, but will accept all the rest of the defaults for that chart.

There are two ways to pass configuration data during install:

* `--values (or -f)`: Specify a YAML file with overrides. This can be specified multiple times and the rightmost file will take precedence
* `--set`: Specify overrides on the command line.

If both are used, `--set` values are merged into `--values` with higher precedence. Overrides specified with `--set` are persisted in a ConfigMap. Values that have been `--set` can be viewed for a given release with helm get values `<release-name>`. Values that have been `--set` can be cleared by running helm upgrade with `--reset-values` specified.

The Format and Limitations of --set

The --set option takes zero or more name/value pairs. At its simplest, it is used like this: `--set name=value`. ~~~~

Multiple values are separated by '`,`' characters. So `--set a=b,c=d`.

More complex expressions are supported. For example, `--set outer.inner=value`.

Lists can be expressed by enclosing values in { and }. For example, `--set name={a, b, c}`.

As of Helm 2.5.0, it is possible to access list items using an array index syntax. For example, `--set servers[0].port=80`.

Multiple values can be set this way. The line `--set servers[0].port=80,servers[0].host=example` becomes:

```yaml
servers:
  - port: 80
    host: example
```

Sometimes you need to use special characters in your --set lines. You can use a backslash to escape the characters; `--set name=value1\,value2` will become:

```yaml
name: "value1,value2"
```

Similarly, you can escape dot sequences as well, which may come in handy when charts use the toYaml function to parse annotations, labels and node selectors. The syntax for `--set nodeSelector."kubernetes\.io/role"=master` becomes:

```yaml
nodeSelector:
  kubernetes.io/role: master
```

### More Installation Methods

The helm install command can install from several sources:

* A chart repository (as we've seen above)
* A local chart archive (helm install foo foo-0.1.1.tgz)
* An unpacked chart directory (helm install foo path/to/foo)
* A full URL (helm install foo https://example.com/charts/foo-1.2.3.tgz)

## Upgrading a Release, and Recovering on Failure

When a new version of a chart is released, or when you want to change the configuration of your release, you can use the `helm upgrade` command.

An upgrade takes an existing release and upgrades it according to the information you provide. Because Kubernetes charts can be large and complex, Helm tries to perform the least invasive upgrade. It will only update things that have changed since the last release.

```shell
helm upgrade -f panda.yaml happy-panda bitnami/wordpress
```
We can use `helm get values` to see whether that new setting took effect.

```shell
helm get values happy-panda
```

The `helm get` command is a useful tool for looking at a release in the cluster. And as we can see above, it shows that our new values from panda.yaml were deployed to the cluster.

Now, if something does not go as planned during a release, it is easy to roll back to a previous release using `helm rollback [RELEASE] [REVISION]`.

```shell
helm rollback happy-panda 1
```

The above rolls back our happy-panda to its very first release version. A release version is an incremental revision. Every time an install, upgrade, or rollback happens, the revision number is incremented by 1. The first revision number is always 1. And we can use `helm history [RELEASE]` to see revision numbers for a certain release.

### Helpful Options for Install/Upgrade/Rollback

There are several other helpful options you can specify for customizing the behavior of Helm during an install/upgrade/rollback. Please note that this is not a full list of cli flags. To see a description of all flags, just run `helm <command> --help`.

* `--timeout`: A Go duration value to wait for Kubernetes commands to complete. This defaults to 5m0s.
* `--wait`: Waits until all Pods are in a ready state, PVCs are bound, Deployments have minimum (Desired minus maxUnavailable) Pods in ready state and Services have an IP address (and Ingress if a LoadBalancer) before marking the release as successful. It will wait for as long as the --timeout value. If timeout is reached, the release will be marked as FAILED. Note: In scenarios where Deployment has replicas set to 1 and maxUnavailable is not set to 0 as part of rolling update strategy, --wait will return as ready as it has satisfied the minimum Pod in ready condition.
* `--no-hooks`: This skips running hooks for the command
* `--recreate-pods` (only available for upgrade and rollback): This flag will cause all pods to be recreated (with the exception of pods belonging to deployments). (DEPRECATED in Helm 3)

## Uninstalling a Release

When it is time to uninstall a release from the cluster, use the helm uninstall command:

```shell
helm uninstall happy-panda
```

This will remove the release from the cluster. You can see all of your currently deployed releases with the helm list command:

```shell
helm list
```

In previous versions of Helm, when a release was deleted, a record of its deletion would remain. In Helm 3, deletion removes the release record as well. If you wish to keep a deletion release record, use `helm uninstall --keep-history`. Using `helm list --uninstalled` will only show releases that were uninstalled with the `--keep-history` flag.

The `helm list --all` flag will show you all release records that Helm has retained, including records for failed or deleted items (if --keep-history was specified):

```shell
helm list --all
```

## Working with Repositories

Helm 3 no longer ships with a default chart repository. The helm repo command group provides commands to add, list, and remove repositories.

You can see which repositories are configured using `helm repo list`:

```shell
helm repo list
```

And new repositories can be added with helm repo add:

```shell
helm repo add dev https://example.com/dev-charts
```

Because chart repositories change frequently, at any point you can make sure your Helm client is up to date by running `helm repo update`.

Repositories can be removed with `helm repo remove`.

### Creating Your Own Charts

The Chart Development Guide explains how to develop your own charts. But you can get started quickly by using the helm create command:

```shell
helm create deis-workflow
```

Now there is a chart in `./deis-workflow`. You can edit it and create your own templates.

As you edit your chart, you can validate that it is well-formed by running `helm lint`.

When it's time to package the chart up for distribution, you can run the `helm package` command:

```shell
helm package deis-workflow
```

And that chart can now easily be installed by `helm install`:

```shell
helm install deis-workflow ./deis-workflow-0.1.0.tgz
```

Charts that are packaged can be loaded into chart repositories. See the documentation for Helm chart repositories for more details.


