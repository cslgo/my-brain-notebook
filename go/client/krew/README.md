krew
===

Krew 是 类似于系统的 apt、dnf 或者 brew 的 kubectl 插件包管理工具，利用其可以轻松的完成 kubectl 插件的全上面周期管理，包括搜索、下载、卸载等。

kubectl 其工具已经比较完善，但是对于一些个性化的命令，其宗旨是希望开发者能以独立而紧张形式发布自定义的 kubectl 子命令，插件的开发语言不限，需要将最终的脚步或二进制可执行程序以 kubectl- 的前缀命名，然后放到 PATH 中即可，可以使用 kubectl plugin list 查看目前已经安装的插件。

