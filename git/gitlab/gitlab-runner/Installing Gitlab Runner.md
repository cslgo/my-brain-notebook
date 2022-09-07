Installling Gitlab Runner
===

## 调整 yum 源 

```
mv /etc/yum.repos.d/CentOS-Base.repo  /etc/yum.repos.d/CentOS-Base.repo.bak
curl -0 http://mirrors.aliyun.com/repo/Centos-7.repo -o ./CentOS-Base.repo
yum clean all
yum makecache
yum update
```

## Installing Gitlab Runner

1. Add the official GitLab repository:

For Debian/Ubuntu/Mint:
```shell
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
```

For RHEL/CentOS/Fedora
```shell
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash
```

2. Install the latest version of GitLab Runner, or skip to the next step to install a specific version:

For Debian/Ubuntu/Mint:
```shell
sudo apt-get install gitlab-runner
# For GitLab Community Edition 13.11.1
export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E apt-get install gitlab-runner
```

For RHEL/CentOS/Fedora:
```shell
sudo yum install gitlab-runner
# For GitLab Community Edition 13.11.1
export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E yum install gitlab-runner
```

3. To install a specific version of GitLab Runner:

```
# for DEB based systems
apt-cache madison gitlab-runner
export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E apt-get -y install gitlab-runner=13.11.0-1

# for RPM based systems
yum list gitlab-runner --showduplicates | sort -r
export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E yum -y install gitlab-runner-13.11.0-1
```

## Installing Gitlab Runner with Binaries
[Install GitLab Runner manually on GNU/Linux](https://docs.gitlab.com/runner/install/linux-manually.html)
```
curl -L --output /usr/local/bin/gitlab-runner http://s3.amazonaws.com/gitlab-runner-downloads/v13.11.0/binaries/gitlab-runner-linux-amd64
```

