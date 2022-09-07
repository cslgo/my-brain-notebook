auto-completion
===

## zsh auto-completion

The kubectl completion script for Zsh can be generated with the command kubectl completion zsh. Sourcing the completion script in your shell enables kubectl autocompletion.

To do so in all your shell sessions, add the following to your `~/.zshrc` file:

```
source <(kubectl completion zsh)
```

If you have an alias for kubectl, kubectl autocompletion will automatically work with it.

After reloading your shell, kubectl autocompletion should be working.

If you get an error like 2: command not found: compdef, then add the following to the beginning of your ~/.zshrc file:

```
autoload -Uz compinit
compinit
```
## bash auto-completion on Linux

### Introduction 

The kubectl completion script for Bash can be generated with the command `kubectl completion bash`. Sourcing the completion script in your shell enables kubectl autocompletion.

However, the completion script depends on `bash-completion`, which means that you have to install this software first (you can test if you have bash-completion already installed by running `type _init_completion`

### Install bash-completion

bash-completion is provided by many package managers (see here). You can install it with `apt-get install bash-completion` or `yum install bash-completion`, etc.

The above commands create `/usr/share/bash-completion/bash_completion`, which is the main script of bash-completion. Depending on your package manager, you have to manually source this file in your ~/.bashrc file.

To find out, reload your shell and run `type _init_completion`. If the command succeeds, you're already set, otherwise add the following to your ~/.bashrc file:

```shell
source /usr/share/bash-completion/bash_completion
```
Reload your shell and verify that bash-completion is correctly installed by typing `type _init_completion`.
