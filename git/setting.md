[Configuration](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)

```shell
## Get help
man git-config

```

## Basic Client Configuration

```shell
git config --global --edit
# /
$ git config --global user.name caojiaqing
$ git config --global user.email caojiaqing@aliyun.com
# /
$ git config user.name cslgo
$ git config user.email caojiaqing.app@gmail.com
```

### core.editor

```shell
## Support nano vim ...
$ git config --global core.editor vim
```
### autocrlf safecrlf

```
## 提交时转换LF，检出时转换成CRLF
git config --global core.autocrlf true

## 提交时转换LF，检出时不转换
git config --global core.autocrlf input

## 提交时转换LF，检出时不转换
git config --global core.autocrlf false

## 拒接提交包含混合换行符的文件
git config --global core.safecrlf true

## 允许提交包含混合换行符的文件
git config --global core.safecrlf false

## 提交包含混合换行符的文件给出报警
git config --global core.safecrlf warn

```

### commit.template

commit template
```txt
Subject line (try to keep under 50 characters)

Multi-line description of commit,
feel free to be detailed.

[Ticket: X]
```

To tell Git to use it as the default message that appears in your editor when you run git commit, set the commit.template configuration value:
```shell
$ git config --global commit.template ~/space/my-brian/notes/git/gitmessage.txt
$ git commit
```