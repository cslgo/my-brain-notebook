Hello Vue 3 + TypeScript + Vite
===

## Installing Tools

- macOS

```bash
brew update
brew install node npm yarn

❯ node -v
v18.5.0
❯ npm -v
8.12.1
❯ yarn -v
1.22.19
```

## Create a hello project using vite and ts


```bash
cd ~/space/me/frontend/vue3-vite-ts

npm init vite@latest
## or
yarn create vite

## 选择  vue vue-ts
```

Installing dependencies

```bash
❯ npm install

added 39 packages, and audited 40 packages in 17s

4 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```

packages.json
```json
  "scripts": {
    "dev": "vite",  // 启动开发服务器，别名 `vite-dev` `vite-serve`
    "build": "vue-tsc --noEmit && vite build", // 生产环境构建
    "preview": "vite preview"       // 本地预览生产构建
  }
```

run

```
npm run dev
```

next to see [vite](../vite/README.md)

## 安装 Vue cli 脚手架

安装 vue/cli 进行对比
```bash
npm install @vue/cli -g
## 检查是否成功
vue -V
```

Creat  a vue/cli project 

```bash
vue create project
```

```
❯ du -sh ./*
166M    ./cli-project
101M    ./vite-npm
 64K    ./vite-yarn
```