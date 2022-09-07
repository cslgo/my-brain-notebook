Python
===

## Install and Manage Python PIP for Windows

Python start
```bash
py --version
py -m pip --version

py
python
python3
```
pip
```
py --version
py -m pip --version
py -m pip install --upgrade pip
```

## Install and Manage Python PIP for Mac

## Use Pyenv to Manage Python Installation

```bash
brew install openssl readline sqlite3 xz zlib
brew install pyenv
echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
pyenv install --list
pyenv install 3.9.7
pyenv install 3.8.12
pyenv versions
pyenv global 3.9.7
python3 --version
python3 -m pip --version
python3 -m pip install --upgrade pip
pyenv local 3.812
```

## Install and Manage Python PIP for Linux

```bash
python3 --version
# Advanced Package Tool for Ubuntu or Debian-based Distributions
sudo apt install python3-pip
# Pacman Package Manager for Arch Linux
sudo pacman -S python-pip
## sudo dnf install python3-pip python3-wheel
sudo dnf install python3-pip python3-wheel
## Zypper Package Manager for openSUSE
sudo zypper install python3-pip python3-setuptools python3-wheel
## Yum Package Manager for CentOS and Red Hat Enterprise Linux
sudo yum install python3 python3-wheel
```


## Install and Configure Virtual Environment

```
# Mac
python3 -m pip install "SomeProject"
 
# Windows
py -m pip install "SomeProject"
```

Install a Specific Version
```bash
# Mac
python3 -m pip install "SomeProject=1.0"
 
# Windows:
py -m pip install "SomeProject=1.0"
```

Upgrade
```bash
# Mac
python3 -m pip install --upgrade "SomeProject"
 
# Windows
py -m pip install --upgrade "SomeProject"
```

Uninstall
```bash
# Mac
python3 -m pip uninstall "SomeProject"
 
# Windows
py -m pip uninstall "SomeProject"
```

List Installed Packages
```bash
# Mac
python3 -m pip list
 
# Windows
py -m pip list
```

List Outdated Packages
```bash
# Mac
python3 -m pip list --outdated
 
# Windows
py -m pip list --outdated
```