Delve Using
===
## Install

```bash
# Install the latest release:
$ go install github.com/go-delve/delve/cmd/dlv@latest

# Install at tree head:
$ go install github.com/go-delve/delve/cmd/dlv@master

# Install at a specific version or pseudo-version:
$ go install github.com/go-delve/delve/cmd/dlv@v1.7.3
$ go install github.com/go-delve/delve/cmd/dlv@v1.7.4-0.20211208103735-2f13672765fe
```

## Quick Start

```bash
mkdir delve-demo
cd delve-demo
go mod init github.com/cslgo/delve-demo
```
[create a demo](./delve-demo/)

then using dlv
```bash
# dlv debug
dlv debug cmd/foo/main.go
# dlv test
dlv test pkg/baz/bar

# (dlv) funcs test.Test*
# github.com/cslgo/delve-demo/pkg/baz_test.TestGa

(dlv) break TestGa


```
## Link

- https://github.com/go-delve/delve/tree/master/Documentation
- https://github.com/go-delve/delve/blob/master/Documentation/cli/getting_started.md
- https://github.com/go-delve/delve/tree/master/Documentation/usage