
# Brew 源配置

## 官方源替代
```bash
# 替换brew.git:
$ cd "$(brew --repo)"
# 中国科大:
$ git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
# 清华大学:
$ git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

# 替换homebrew-core.git:
$ cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
# 中国科大:
$ git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
# 清华大学:
$ git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

# 替换homebrew-bottles:
# 中国科大:
$ echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zshrc
$ source ~/.zshrc
# 清华大学:
$ echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.zshrc
$ source ~/.zshrc

# 应用生效:
$ brew update
```

##

```bash
# 诊断Homebrew的问题:
$ brew doctor

# 重置brew.git设置:
$ cd "$(brew --repo)"
$ git fetch
$ git reset --hard origin/master

# homebrew-core.git同理:
$ cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
$ git fetch
$ git reset --hard origin/master

# 应用生效:
$ brew update  
```

## 官方源重置
```bash
# 重置brew.git:
$ cd "$(brew --repo)"
$ git remote set-url origin https://github.com/Homebrew/brew.git

# 重置homebrew-core.git:
$ cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
$ git remote set-url origin https://github.com/Homebrew/homebrew-core.git
```

## 清除缓存并升级已安装应该

```bash
brew cleanup
brew update
brew upgrade
```

## 解决警告

fatal: not in a git directory
Warning: No remote 'origin' in /usr/local/Homebrew/Library/Taps/homebrew/homebrew-services, skipping update!

```bash
rm -rf /usr/local/Homebrew/Library/Taps/homebrew/homebrew-services
brew tap homebrew/services
```

curl: (56) LibreSSL SSL_read: error:02FFF036:system library:func(4095):Connection reset by peer, errno 54

```bash
# git config --global --list
# git config --global --edit
git config --global http.sslVerify "false"
# 5000M
git config --global http.postBuffer 5242880000
```