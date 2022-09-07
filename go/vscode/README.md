Go in Visual Studio Code
===

## Installation Plugins

[The VS Code Go extension](https://marketplace.visualstudio.com/items?itemName=golang.go)


## Intall/Update Tools
```shell
# COMMAND SHIFT P -> Go: Intall/Update Tools -> Select All
Tools environment: GOPATH=/Users/chosl/go
Installing 8 tools at /Users/chosl/go/bin in module mode.
  go-outline
  gotests
  gomodifytags
  impl
  goplay
  dlv
  staticcheck
  gopls

Installing github.com/ramya-rao-a/go-outline@latest (/Users/chosl/go/bin/go-outline) SUCCEEDED
Installing github.com/cweill/gotests/gotests@latest (/Users/chosl/go/bin/gotests) SUCCEEDED
Installing github.com/fatih/gomodifytags@latest (/Users/chosl/go/bin/gomodifytags) SUCCEEDED
Installing github.com/josharian/impl@latest (/Users/chosl/go/bin/impl) SUCCEEDED
Installing github.com/haya14busa/goplay/cmd/goplay@latest (/Users/chosl/go/bin/goplay) SUCCEEDED
Installing github.com/go-delve/delve/cmd/dlv@latest FAILED
{
 "killed": false,
 "code": 1,
 "signal": null,
 "cmd": "/usr/local/bin/go install -v github.com/go-delve/delve/cmd/dlv@latest",
 "stdout": "",
 "stderr": "go: downloading github.com/go-delve/delve v1.8.3\ngo: github.com/go-delve/delve/cmd/dlv@latest: github.com/go-delve/delve@v1.8.3: verifying module: github.com/go-delve/delve@v1.8.3: Get \"https://sum.golang.org/lookup/github.com/go-delve/delve@v1.8.3\": dial tcp 142.251.43.17:443: i/o timeout\n"
}
Installing github.com/go-delve/delve/cmd/dlv@latest FAILED
{
 "killed": false,
 "code": 1,
 "signal": null,
 "cmd": "/usr/local/bin/go install -v github.com/go-delve/delve/cmd/dlv@latest",
 "stdout": "",
 "stderr": "go: downloading github.com/go-delve/delve v1.8.3\ngo: github.com/go-delve/delve/cmd/dlv@latest: github.com/go-delve/delve@v1.8.3: verifying module: github.com/go-delve/delve@v1.8.3: Get \"https://sum.golang.org/lookup/github.com/go-delve/delve@v1.8.3\": dial tcp 142.251.43.17:443: i/o timeout\n"
}
Installing honnef.co/go/tools/cmd/staticcheck@latest FAILED
{
 "killed": false,
 "code": 1,
 "signal": null,
 "cmd": "/usr/local/bin/go install -v honnef.co/go/tools/cmd/staticcheck@latest",
 "stdout": "",
 "stderr": "go: downloading honnef.co/go/tools v0.3.1\ngo: honnef.co/go/tools/cmd/staticcheck@latest: honnef.co/go/tools@v0.3.1: verifying module: honnef.co/go/tools@v0.3.1: Get \"https://sum.golang.org/lookup/honnef.co/go/tools@v0.3.1\": dial tcp 142.251.43.17:443: i/o timeout\n"
}
Installing honnef.co/go/tools/cmd/staticcheck@latest FAILED
{
 "killed": false,
 "code": 1,
 "signal": null,
 "cmd": "/usr/local/bin/go install -v honnef.co/go/tools/cmd/staticcheck@latest",
 "stdout": "",
 "stderr": "go: downloading honnef.co/go/tools v0.3.1\ngo: honnef.co/go/tools/cmd/staticcheck@latest: honnef.co/go/tools@v0.3.1: verifying module: honnef.co/go/tools@v0.3.1: Get \"https://sum.golang.org/lookup/honnef.co/go/tools@v0.3.1\": dial tcp 142.251.43.17:443: i/o timeout\n"
}
 
gopls: failed to install gopls(golang.org/x/tools/gopls@latest): Error: Command failed: /usr/local/bin/go install -v golang.org/x/tools/gopls@latest
go: downloading golang.org/x/tools/gopls v0.8.3
go: downloading golang.org/x/tools v0.1.10
go: golang.org/x/tools/gopls@latest: golang.org/x/tools/gopls@v0.8.3: verifying module: golang.org/x/tools/gopls@v0.8.3: Get "https://sum.golang.org/lookup/golang.org/x/tools/gopls@v0.8.3": dial tcp 142.251.43.17:443: i/o timeout
 
Installing golang.org/x/tools/gopls@latest FAILED
{
 "killed": false,
 "code": 1,
 "signal": null,
 "cmd": "/usr/local/bin/go install -v golang.org/x/tools/gopls@latest",
 "stdout": "",
 "stderr": "go: downloading golang.org/x/tools v0.1.10\ngo: downloading golang.org/x/tools/gopls v0.8.3\ngo: golang.org/x/tools/gopls@latest: golang.org/x/tools/gopls@v0.8.3: verifying module: golang.org/x/tools/gopls@v0.8.3: Get \"https://sum.golang.org/lookup/golang.org/x/tools/gopls@v0.8.3\": dial tcp 142.251.43.17:443: i/o timeout\n"
}

3 tools failed to install.

dlv: failed to install dlv(github.com/go-delve/delve/cmd/dlv@latest): Error: Command failed: /usr/local/bin/go install -v github.com/go-delve/delve/cmd/dlv@latest
go: downloading github.com/go-delve/delve v1.8.3
go: github.com/go-delve/delve/cmd/dlv@latest: github.com/go-delve/delve@v1.8.3: verifying module: github.com/go-delve/delve@v1.8.3: Get "https://sum.golang.org/lookup/github.com/go-delve/delve@v1.8.3": dial tcp 142.251.43.17:443: i/o timeout
 
staticcheck: failed to install staticcheck(honnef.co/go/tools/cmd/staticcheck@latest): Error: Command failed: /usr/local/bin/go install -v honnef.co/go/tools/cmd/staticcheck@latest
go: downloading honnef.co/go/tools v0.3.1
go: honnef.co/go/tools/cmd/staticcheck@latest: honnef.co/go/tools@v0.3.1: verifying module: honnef.co/go/tools@v0.3.1: Get "https://sum.golang.org/lookup/honnef.co/go/tools@v0.3.1": dial tcp 142.251.43.17:443: i/o timeout
 
gopls: failed to install gopls(golang.org/x/tools/gopls@latest): Error: Command failed: /usr/local/bin/go install -v golang.org/x/tools/gopls@latest
go: downloading golang.org/x/tools v0.1.10
go: downloading golang.org/x/tools/gopls v0.8.3
go: golang.org/x/tools/gopls@latest: golang.org/x/tools/gopls@v0.8.3: verifying module: golang.org/x/tools/gopls@v0.8.3: Get "https://sum.golang.org/lookup/golang.org/x/tools/gopls@v0.8.3": dial tcp 142.251.43.17:443: i/o timeout

```

Using `go install`
```shell
❯ go install github.com/go-delve/delve/cmd/dlv@latest
go: downloading github.com/go-delve/delve v1.8.3
go: downloading github.com/go-delve/liner v1.2.2-1
go: downloading golang.org/x/sys v0.0.0-20211117180635-dee7805ff2e1
go: downloading github.com/mattn/go-runewidth v0.0.13
go: downloading github.com/rivo/uniseg v0.2.0

❯ go install honnef.co/go/tools/cmd/staticcheck@latest
go: downloading honnef.co/go/tools v0.3.1
go: downloading golang.org/x/exp/typeparams v0.0.0-20220218215828-6cf2b201936e
go: downloading golang.org/x/tools v0.1.11-0.20220316014157-77aa08bb151a
go: downloading golang.org/x/mod v0.6.0-dev.0.20220106191415-9b9b3d81d5e3

❯ go install golang.org/x/tools/gopls@latest
go: downloading golang.org/x/tools/gopls v0.8.3
go: downloading golang.org/x/tools v0.1.10
go: downloading golang.org/x/tools v0.1.11-0.20220407163324-91bcfb1bdf9c
go: downloading honnef.co/go/tools v0.3.0
go: downloading mvdan.cc/gofumpt v0.3.0
go: downloading mvdan.cc/xurls/v2 v2.4.0
go: downloading golang.org/x/vuln v0.0.0-20220324005316-18fd808f5c7f
go: downloading github.com/google/go-cmp v0.5.7
go: downloading golang.org/x/sys v0.0.0-20220209214540-3681064d5158
go: downloading github.com/BurntSushi/toml v1.0.0

```
