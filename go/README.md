Go Settings
===

```shell
❯ go version
go version go1.18.1 darwin/amd64

❯ go env
GO111MODULE="on"
GOARCH="amd64"
GOBIN=""
GOCACHE="/Users/chosl/Library/Caches/go-build"
GOENV="/Users/chosl/Library/Application Support/go/env"
GOEXE=""
GOEXPERIMENT=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="darwin"
GOINSECURE=""
GOMODCACHE="/Users/chosl/go/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="darwin"
GOPATH="/Users/chosl/go"
GOPRIVATE=""
GOPROXY="https://goproxy.io,direct"
GOROOT="/usr/local/Cellar/go/1.18.1/libexec"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/Cellar/go/1.18.1/libexec/pkg/tool/darwin_amd64"
GOVCS=""
GOVERSION="go1.18.1"
GCCGO="gccgo"
GOAMD64="v1"
AR="ar"
CC="clang"
CXX="clang++"
CGO_ENABLED="1"
GOMOD="/dev/null"
GOWORK=""
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -arch x86_64 -m64 -pthread -fno-caret-diagnostics -Qunused-arguments -fmessage-length=0 -fdebug-prefix-map=/var/folders/5y/ts_swnx14nz4sq_hjdl5jfv00000gn/T/go-build729969481=/tmp/go-build -gno-record-gcc-switches -fno-common"
```

[Set Proxy](https://github.com/goproxy/goproxy.cn)

```shell
$ go env -w GO111MODULE=on
$ go env -w GOPROXY=https://goproxy.cn,direct
```

## 参考

[https://github.com/avelino/awesome-go](https://github.com/avelino/awesome-go)