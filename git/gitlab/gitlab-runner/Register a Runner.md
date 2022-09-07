Register a Gitlab Runner
===

## Gitlab Group Runner


> Set up a group runner manually
> Install GitLab Runner and ensure it's running.
> Register the runner with this URL:
> http://10.136.107.186:10080/
> 
> And this registration token:
> TzQEMvxe2U3szG-xArNW


### To register a runner using ssh executor under Linux:

This is a simple executor that allows you to execute builds on a remote machine by executing commands over SSH.

> GitLab Runner will use the git lfs command if Git LFS is installed on the remote machine. Ensure Git LFS is up-to-date on any remote systems where > GitLab Runner will run using SSH executor.

[git lfs more](https://help.aliyun.com/document_detail/206889.html)

```bash
# gitlab-runner register
Runtime platform                                    arch=amd64 os=linux pid=22413 revision=7f7a4bb0 version=13.11.0
Running in system-mode.                            
                                                   
Enter the GitLab instance URL (for example, https://gitlab.com/):
http://10.0.0.21:10080/
Enter the registration token:
TzQEMvxe2U3szG-xArNW
Enter a description for the runner:
[ZBZG22]: groupQh
Enter tags for the runner (comma-separated):
(Optional)
Registering runner... succeeded                     runner=_BnNp5_H
Enter an executor: docker-ssh, ssh, virtualbox, docker+machine, docker-ssh+machine, kubernetes, docker, parallels, shell, custom:
ssh
Enter the SSH server address (for example, my.server.com):
10.0.0.14
Enter the SSH server port (for example, 22):
22
Enter the SSH user (for example, root):
root
Enter the SSH password (for example, docker.io):
FmMa*z0F1d#27gle
Enter the path to the SSH identity file (for example, /home/user/.ssh/id_rsa):
~/.ssh/id_rsa
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

The SSH executor supports only scripts generated in Bash and the caching feature is currently not supported.


### One-line registration command with docker executor

```bash
sudo gitlab-runner register \
  --non-interactive \
  --url "10.0.0.21:10080" \
  --registration-token "TzQEMvxe2U3szG-xArNW" \
  --executor "docker" \
  --docker-image alpine:latest \
  --description "docker-runner" \
  --tag-list "docker,aws" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"
```