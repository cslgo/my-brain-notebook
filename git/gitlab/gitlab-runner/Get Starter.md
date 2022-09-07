Gitlab Runner
===

## 安装 Gitlab Runner

[Installling Gitlab Runner](https://docs.gitlab.com/runner/install/index.html)

add gitlab-runner sudoers
```bash
$ su -
# chmod +w /etc/sudoers
# tee -a "gitlab-runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# chmod -w /etc/sudoers
```

## 注册 Gitlab Runner
[Register a runner](Register%20a%20Runner.md)

## 配置样例
[gitlab-ci.yml.md](../gitlab-ci.yaml.md)


[ssh](../../linux/ssh.md)

## 变量列表

```
$ export
declare -x CI="true"
declare -x CI_API_V4_URL="http://10.0.0.21:10080/api/v4"
declare -x CI_BUILDS_DIR="/home/gitlab-runner/builds"
declare -x CI_BUILD_BEFORE_SHA="89232c1f18728b669c1060f38be3ca592831bfe2"
declare -x CI_BUILD_ID="2283"
declare -x CI_BUILD_NAME="build_package"
declare -x CI_BUILD_REF="58c1a8defe003dd362ee465333a1a25aeb154a11"
declare -x CI_BUILD_REF_NAME="master"
declare -x CI_BUILD_REF_SLUG="master"
declare -x CI_BUILD_STAGE="build"
declare -x CI_BUILD_TOKEN="[MASKED]"
declare -x CI_COMMIT_AUTHOR="caojiaqing <caojiaqing@cmdi.chinamobile.com>"
declare -x CI_COMMIT_BEFORE_SHA="89232c1f18728b669c1060f38be3ca592831bfe2"
declare -x CI_COMMIT_BRANCH="master"
declare -x CI_COMMIT_DESCRIPTION=""
declare -x CI_COMMIT_MESSAGE="ci test"
declare -x CI_COMMIT_REF_NAME="master"
declare -x CI_COMMIT_REF_PROTECTED="true"
declare -x CI_COMMIT_REF_SLUG="master"
declare -x CI_COMMIT_SHA="58c1a8defe003dd362ee465333a1a25aeb154a11"
declare -x CI_COMMIT_SHORT_SHA="58c1a8de"
declare -x CI_COMMIT_TIMESTAMP="2022-05-16T12:03:34+08:00"
declare -x CI_COMMIT_TITLE="ci test"
declare -x CI_CONCURRENT_ID="0"
declare -x CI_CONCURRENT_PROJECT_ID="0"
declare -x CI_CONFIG_PATH=".gitlab-ci.yml"
declare -x CI_DEFAULT_BRANCH="master"
declare -x CI_DEPENDENCY_PROXY_GROUP_IMAGE_PREFIX="10.0.0.21:10080/vrms-guide/dependency_proxy/containers"
declare -x CI_DEPENDENCY_PROXY_PASSWORD="[MASKED]"
declare -x CI_DEPENDENCY_PROXY_SERVER="10.0.0.21:10080"
declare -x CI_DEPENDENCY_PROXY_USER="gitlab-ci-token"
declare -x CI_JOB_ID="2283"
declare -x CI_JOB_JWT="[MASKED]"
declare -x CI_JOB_NAME="build_package"
declare -x CI_JOB_STAGE="build"
declare -x CI_JOB_STARTED_AT="2022-05-16T04:03:41Z"
declare -x CI_JOB_STATUS="running"
declare -x CI_JOB_TOKEN="[MASKED]"
declare -x CI_JOB_URL="http://10.0.0.21:10080/vrms-guide/vrms-examples-seata/-/jobs/2283"
declare -x CI_NODE_TOTAL="1"
declare -x CI_PAGES_DOMAIN="example.com"
declare -x CI_PAGES_URL="http://vrms-guide.example.com/vrms-examples-seata"
declare -x CI_PIPELINE_CREATED_AT="2022-05-16T04:03:37Z"
declare -x CI_PIPELINE_ID="693"
declare -x CI_PIPELINE_IID="70"
declare -x CI_PIPELINE_SOURCE="push"
declare -x CI_PIPELINE_URL="http://10.0.0.21:10080/vrms-guide/vrms-examples-seata/-/pipelines/693"
declare -x CI_PROJECT_CONFIG_PATH=".gitlab-ci.yml"
declare -x CI_PROJECT_DIR="/home/gitlab-runner/builds/xjpjjkx6/0/vrms-guide/vrms-examples-seata"
declare -x CI_PROJECT_ID="174"
declare -x CI_PROJECT_NAME="vrms-examples-seata"
declare -x CI_PROJECT_NAMESPACE="vrms-guide"
declare -x CI_PROJECT_PATH="vrms-guide/vrms-examples-seata"
declare -x CI_PROJECT_PATH_SLUG="vrms-guide-vrms-examples-seata"
declare -x CI_PROJECT_REPOSITORY_LANGUAGES="java"
declare -x CI_PROJECT_ROOT_NAMESPACE="vrms-guide"
declare -x CI_PROJECT_TITLE="vrms-examples-seata"
declare -x CI_PROJECT_URL="http://10.0.0.21:10080/vrms-guide/vrms-examples-seata"
declare -x CI_PROJECT_VISIBILITY="internal"
declare -x CI_REGISTRY_PASSWORD="[MASKED]"
declare -x CI_REGISTRY_USER="gitlab-ci-token"
declare -x CI_REPOSITORY_URL="http://gitlab-ci-token:[MASKED]@10.0.0.21:10080/vrms-guide/vrms-examples-seata.git"
declare -x CI_RUNNER_DESCRIPTION="ZBZG22"
declare -x CI_RUNNER_EXECUTABLE_ARCH="linux/amd64"
declare -x CI_RUNNER_ID="6"
declare -x CI_RUNNER_REVISION="7f7a4bb0"
declare -x CI_RUNNER_SHORT_TOKEN="xjpjjkx6"
declare -x CI_RUNNER_TAGS=""
declare -x CI_RUNNER_VERSION="13.11.0"
declare -x CI_SERVER="yes"
declare -x CI_SERVER_HOST="10.0.0.21"
declare -x CI_SERVER_NAME="GitLab"
declare -x CI_SERVER_PORT="10080"
declare -x CI_SERVER_PROTOCOL="http"
declare -x CI_SERVER_REVISION="2fad4108767"
declare -x CI_SERVER_URL="http://10.0.0.21:10080"
declare -x CI_SERVER_VERSION="13.11.1"
declare -x CI_SERVER_VERSION_MAJOR="13"
declare -x CI_SERVER_VERSION_MINOR="11"
declare -x CI_SERVER_VERSION_PATCH="1"
declare -x CI_SHARED_ENVIRONMENT="true"
declare -x CLASSPATH=".:/app/jdk/jdk1.8.0_162/lib/dt.jar:/app/jdk/jdk1.8.0_162/lib/tools.jar"
declare -x CONFIG_FILE="/etc/gitlab-runner/config.toml"
declare -x FF_CMD_DISABLE_DELAYED_ERROR_LEVEL_EXPANSION="false"
declare -x FF_DISABLE_UMASK_FOR_DOCKER_EXECUTOR="false"
declare -x FF_ENABLE_BASH_EXIT_CODE_CHECK="false"
declare -x FF_GITLAB_REGISTRY_HELPER_IMAGE="false"
declare -x FF_NETWORK_PER_BUILD="false"
declare -x FF_RESET_HELPER_IMAGE_ENTRYPOINT="true"
declare -x FF_SHELL_EXECUTOR_USE_LEGACY_PROCESS_KILL="false"
declare -x FF_SKIP_DOCKER_MACHINE_PROVISION_ON_CREATION_FAILURE="false"
declare -x FF_SKIP_NOOP_BUILD_STAGES="true"
declare -x FF_USE_DIRECT_DOWNLOAD="true"
declare -x FF_USE_FASTZIP="false"
declare -x FF_USE_GO_CLOUD_WITH_CACHE_ARCHIVER="true"
declare -x FF_USE_LEGACY_KUBERNETES_EXECUTION_STRATEGY="true"
declare -x FF_USE_WINDOWS_LEGACY_PROCESS_STRATEGY="true"
declare -x GITLAB_CI="true"
declare -x GITLAB_FEATURES=""
declare -x GITLAB_USER_EMAIL="caojiaqing@cmdi.chinamobile.com"
declare -x GITLAB_USER_ID="160"
declare -x GITLAB_USER_LOGIN="caojiaqing"
declare -x GITLAB_USER_NAME="caojiaqing"
declare -x HISTCONTROL="ignoredups"
declare -x HISTSIZE="1000"
declare -x HOME="/home/gitlab-runner"
declare -x HOSTNAME="ZBZG22"
declare -x JAVA_HOME="/app/jdk/jdk1.8.0_162"
declare -x JRE_HOME="/app/jdk/jdk1.8.0_162/jre"
declare -x LANG="en_US.UTF-8"
declare -x LESSOPEN="||/usr/bin/lesspipe.sh %s"
declare -x LOGNAME="gitlab-runner"
declare -x M2_OPTS="--s /home/gitlab-runner/.m2/settings.ci.xml --batch-mode -Dmaven.repo.local=/home/gitlab-runner/.m2/repository"
declare -x MAIL="/var/spool/mail/gitlab-runner"
declare -x MODULE_NAME="account"
declare -x OLDPWD="/home/gitlab-runner"
declare -x PATH="/usr/local/git/bin:/usr/local/maven/apache-maven-3.5.4/bin:/app/jdk/jdk1.8.0_162/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
declare -x PROJECT_NAME="seata-at"
declare -x PWD="/home/gitlab-runner/builds/xjpjjkx6/0/vrms-guide/vrms-examples-seata"
declare -x SHELL="/bin/bash"
declare -x SHLVL="2"
declare -x TMOUT="180"
declare -x USER="gitlab-runner"
declare -x XDG_RUNTIME_DIR="/run/user/996"
declare -x XDG_SESSION_ID="c425"
```

## 解决问题

### 问题 1：git 版本过低及配置问题

```
fatal: git fetch-pack: expected shallow list
fatal: The remote end hung up unexpectedly
ERROR: Job failed: exit status 1
```
Option 1. git 版本较低问题，[升级版本](../../Installing%20Git.md)

Option 2. git 配置问题, `--system` 全局生效
           
```bash
# 将 Http 缓存设置调大 1G
git config --system http.postBuffer 1048576000
# 设置最低速率限制
git config --system http.lowSpeedLimit 0
git config --system http.lowSpeedTime 999999
```

### 问题 2：git 配置文件无权访问

```
Fetching changes with git depth set to 50...
fatal: unable to access '/etc/gitconfig': Permission denied
ERROR: Job failed: exit status 1
```
解决：
```bash
ls -hald /etc /etc/gitconfig
sudo chmod 0644 /etc/gitconfig
ls -hald /etc/gitconfig
```

### 问题 3：
```
Fetching changes with git depth set to 50...
Reinitialized existing Git repository in /home/gitlab-runner/builds/_C6jXocf/0/vrms-guide/vrms-examples-seata/.git/
git: 'remote-http' is not a git command. See 'git --help'.
ERROR: Job failed: exit status 1
```
yum 安装 使用了自引入的 git 版本，且 git 版本较低

解决办法：

安装
```shell
yum -y install libcurl-devel curl-devel
```

[重装Git](../../Installing%20Git.md)

### 问题 4

```
$ sudo mvn clean $MVN_OPTS package -U -DskipTests -Drevision=1.0-${CI_PIPELINE_ID}
sudo: mvn: command not found
ERROR: Job failed: exit status 1
```
方案 1：
```bash
# su - gitlab-runner
$ vi .bashrc
alias sudo="sudo env PATH=$PATH"
$ source .bashrc
$ vi .bash_profile
```
添加如下内容
```
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
```

方案 2：
```yaml
mvn_build:
  script:
    - sudo env PATH=$PATH mvn ...
```

错误尝试：
(1) gitlab-runner uninstall //卸载
(2) gitlab-runner install --working-directory /home/gitlab-runner --user root //重新安装，指定安装用户为root
(3) service gitlab-runner restart //重启 gitlab-runner
(4) ps aux|grep gitlab-runner 在次查看用户应该已经更改为 root 了

### 问题 5

```
fatal: unsafe repository ('/home/gitlab-runner/builds/ezPuhwpw/0/vrms-guide/vrms-examples-seata' is owned by someone else)
To add an exception for this directory, call:
	git config --global --add safe.directory /home/gitlab-runner/builds/ezPuhwpw/0/vrms-guide/vrms-examples-seata
ERROR: Job failed: exit status 1
```
解决：

刷新 token，重新注册

### 问题 6

```
$ sudo env PATH=$PATH mvn clean $MVN_OPTS package -U -DskipTests -Drevision=1.0-$CI_PIPELINE_ID
[ERROR] Error executing Maven.
[ERROR] The specified user settings file does not exist: /home/gitlab-runner/builds/xjpjjkx6/0/vrms-guide/vrms-examples-seata/seata-at/~/.m2/settings.xml
ERROR: Job failed: exit status 1
```

`MVN_OPTS --s` 参数由 `--s ~/.m2/settings.xml` 改成绝对路径  `--s /home/gitlab-runner/.m2/settings.xml` 
```yaml
variables:
  SUB_MODULE_DIR: ./seata-at
  MVN_OPTS: "--s /home/gitlab-runner/.m2/settings.xml --batch-mode -Dmaven.repo.local=$CI_PROJECT_DIR/.m2/repository"
```

### 问题 7

```
[INFO] ------------------------------------------------------------------------
Saving cache for successful job
00:00
Missing /usr/local/bin/gitlab-runner. Creating cache is disabled.
Uploading artifacts for successful job
00:00
Missing /usr/local/bin/gitlab-runner. Uploading artifacts is disabled.
Job succeeded
```

解决：
```bash
sudo chown -R gitlab-runner:gitlab-runner /usr/local/bin/gitlab-runner
```

when sudo command not found
```bash
# chmod u+w /etc/sudoers
# vi /etc/sudoers
```
添加 Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin`:/usr/local/bin`:/usr/local/maven/apache-maven-3.5.4/bin

### 问题 8

```bash
$ sudo chown -R gitlab-runner:gitlab-runner $CI_PROJECT_DIR
Saving cache for successful job
00:00
Creating cache default-2...
Runtime platform                                    arch=amd64 os=linux pid=32461 revision=7f7a4bb0 version=13.11.0
WARNING: .m2/repository: no matching files         
No URL provided, cache will be not uploaded to shared cache server. Cache will be stored only locally. 
Created cache
Uploading artifacts for successful job
00:00
Uploading artifacts...
Runtime platform                                    arch=amd64 os=linux pid=32501 revision=7f7a4bb0 version=13.11.0
WARNING: ~/builds: no matching files               
ERROR: No files to upload                          
Job succeeded
```
路径问题，调整为绝对路径，对应像这种非 script 下的路径配置最好使用全路径！ 


## Reference Link

https://docs.gitlab.com/runner/

https://docs.gitlab.com/runner/install/index.html

/help/ci/quick_start/index.md

https://blog.csdn.net/weixin_43878297/article/details/119865646

https://cloud.tencent.com/developer/article/1376224

https://zhuanlan.zhihu.com/p/377720773