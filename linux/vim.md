# VIM

## 格式
```shell
set ff?         ##显示当前文件格式
set ff=unix     ##设置成unix格式
set ff=dos      ##设置成dos格式
```

## 编辑

## 设置

```shell
set nu
set ts=4
syntax
syntax on
set history = 200
filetype on
filetype plugin on
filetype indent on
set nocompatible
set autoread
set shortmess=atI
set magic
set title
set nobackup
set warp
set nowrap
set novisualbell
set noerrorbells
set visualbell t_vb=
set t_vb=
set tm=500
set cursorcolumn
set cursorline
set scrolloff=7
set ruler
set number
set showcmd
set showmode
set showmatch
set matchtime=2
set hlsearch
set incsearch
set ignorecase
set smartcase
set expandtab
set smarttab
set shiftround
set autoindent smartindent shiftround
set shiftwidth=4
set tabstop=4
set softtabstop=4
set foldenable
set foldenable=indent
set foldlevel=99
set g:FoldMethod = 0
map<leader>zz:calltoggleFold()<cr>
```

vim配置

我的配置首先要安装plug和ctags
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo apt-get install ctags
```
以上命令执行成功后先安装vim插件，vim ~/.vimrc，然后配置
```
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ludovicchabant/vim-gutentags'
call plug#end()
```
保存退出，然后vim，执行
:source ~/.vimrc #让配置生效
:PlugInstall # 安装插件
安装完毕就在~/.vimrc直接贴上以下配置：

```
"使用此配置文件请先用以下命令安装插件管理工具plug和ctags
"curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"sudo apt-get install ctags
"plug插件安装
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ludovicchabant/vim-gutentags'
call plug#end()
"设置编码
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
"显示行号
set nu
"突出显示当前行
set cul
"突出显示当前列
"set cuc
"显示括号匹配
set showmatch
"设置缩进
"设置Tab长度为4空格 
set tabstop=4 
"设置自动缩进长度为4空格
set shiftwidth=4
"继承前一行的缩进方式，适用于多行注释
set autoindent
"设置粘贴模式
set paste
"总是显示状态栏
set laststatus=2
"显示光标当前位置
set ruler
"让vimrc配置变更立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC

"----------------------gutentags相关配置-----------------------
"gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']
"所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'
"将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
"检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags) 
    silent! call mkdir(s:vim_tags, 'p') 
endif
" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

"---------------------NERDTree相关配置----------------------------
""将F1设置为开关NERDTree的快捷键
nnoremap <silent> <F1> :NERDTree<CR>
""修改树的显示图标
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
""窗口位置
let g:NERDTreeWinPos='left'
""窗口尺寸
let g:NERDTreeSize=30
""窗口是否显示行号
let g:NERDTreeShowLineNumbers=1
""不显示隐藏文件
let g:NERDTreeHidden=0
""打开vim时如果没有文件自动打开NERDTree
"autocmd vimenter * if !argc() | NERDTree | endif
""当NERDTree为剩下的唯一窗口时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
""打开vim时自动打开NERDTree
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
"PHP自动补全
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
```