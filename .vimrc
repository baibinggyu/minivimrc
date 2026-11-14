" =============================================================================
"  ~/.vimrc  —  Vim 9.1  (C / C++ / Go)
"  插件管理 : vim-plug
"  代码提示 : coc.nvim  +  clangd (C/C++)  +  gopls (Go)
"  备份     : ~/.vimrc.bak.*
" =============================================================================

" ---------------------------------------------------------------- 基础设置
set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8
scriptencoding utf-8

set number relativenumber
set cursorline
set ruler
set showcmd
set wildmenu
set wildmode=longest:full,full
set hidden
set noswapfile
set nobackup
set nowritebackup
set undofile
set undodir=~/.vim/undo//
set updatetime=300
set timeoutlen=400
set scrolloff=8
set sidescrolloff=8
set signcolumn=yes          " 常驻图标列，避免诊断出现时整屏抖动
set mouse=a
set backspace=indent,eol,start
set splitright splitbelow
set ignorecase smartcase
set incsearch hlsearch
set completeopt=menu,menuone,noselect
set shortmess+=c
set pumheight=10
set laststatus=2
set matchpairs+=<:>
set cursorlineopt=number    " 只亮行号，不铺整行底色（透明背景更干净）
set fillchars=vert:│,fold:·,eob:\ 
set showbreak=↳\ 
set clipboard=unnamed,unnamedplus
if has('termguicolors') && $COLORTERM =~? 'truecolor\|24bit'
  set termguicolors
endif

" 缩进：与 Neovim (LazyVim) 对齐 —— ts=2 / sw=2 / softtabstop 关闭 / 空格缩进
" md 跟随全局 2 空格（nvim 行为）；python 保留 4 空格（PEP8）
let g:markdown_recommended_style = 0
set tabstop=2 shiftwidth=2 softtabstop=0
set expandtab autoindent smartindent
set shiftround
set wrap linebreak
set formatoptions+=j

" 让 vim 里也能直接找到 gopls / goimports 等工具
let $PATH = $HOME . '/go/bin:' . $PATH

" ---------------------------------------------------------------- 快捷键
let mapleader = " "
let maplocalleader = ","

nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>q :q<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" ------------------------------------------- 操作后闪一下被作用的文本（本地插件）
" 插件本体：~/.vim/plugin/flashop.vim
"   yiw / yy / 可视化 y / "ayiw  → 原地闪一下被复制的那段
"   diw / dd / ciw / x …       → 文本已删，右下角 toast 提示删掉的是什么
"   > < = gU g~ 等             → 原地闪一下
let g:flashop_duration    = 180     " 闪烁时长(ms)
let g:flashop_echo_delete = 1       " 删除/修改时弹 toast
let g:flashop_toast_ms    = 900     " toast 停留时长(ms)
let g:flashop_max_lines   = 80      " 超过这么多行就不闪（防卡顿）
let g:flashop_min_chars   = 2       " 小于这么短的内容不提示（x 删单字符不吭声）
" 想改颜色：hi FlashOp guibg=... / hi FlashOpMsg guifg=... guibg=...
nnoremap <silent> <leader>tf :FlashOpToggle<CR>

" -------------------------------------- 插入模式自动补全括号/引号（本地插件）
"  逻辑：~/.vim/autoload/autopair.vim    映射：~/.vim/plugin/autopair.vim
"   {  →  {}      ( [ " ' 同理，光标停在中间
"   在空 {} 里回车 → 展开成三行，缩进交给 indentexpr/cindent
"   <BS> 一次删掉一对；再敲一次闭符 → 光标跳过，不会出现 }} 或 ""
"   后面紧跟单词时不配对；引号在注释/字符串/词尾不配对（don't 不会变 don''t）
"   <CR> 的接管在下面 coc 那段（补全菜单开着时行为完全不变）
let g:autopair_enabled      = 1
let g:autopair_expand_cr    = 1     " 空 {} 里回车展开
let g:autopair_cr_pairs     = '{}'  " 哪些对要展开（写 '{}([]' 也可以）
let g:autopair_smart_quotes = 1     " 注释/字符串/词尾不配对引号
nnoremap <silent> <leader>tp :AutoPairToggle<CR>

" ---------------------------------------------------------------- 插件
" 配色：onedark + 透明背景（保留 Ghostty 的 background-opacity = 0.8）
let g:onedark_termcolors = 256
let g:onedark_termtrans  = 1
let g:onedark_hide_endofbuffer = 1
let g:onedark_terminal_italics = 1

call plug#begin('~/.vim/plugged')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}   " LSP 客户端 / 代码提示
  Plug 'joshdick/onedark.vim'                       " 配色（One Dark）
  Plug 'tpope/vim-commentary'                       " gc / gcc 注释
  Plug 'tpope/vim-surround'                         " cs/ds/ys 括号引号
call plug#end()

" coc.nvim 首次启动时自动安装这些扩展（放在 plug#end 之后即可）
let g:coc_global_extensions = [
      \ 'coc-clangd',
      \ 'coc-go',
      \ 'coc-snippets',
      \ 'coc-json',
      \ ]
let g:coc_disable_startup_warning = 1

" ---------------------------------------------------------------- 界面美化
" 原则：主窗口一律不铺底色（guibg=NONE），透明交给 Ghostty；
"       只有补全/浮窗用实心卡片，否则会和背后的代码糊在一起。
function! UiTweaks() abort
  hi! Normal        guifg=#d0d6df guibg=NONE ctermbg=NONE
  hi! Comment       guifg=#7f8a99 gui=italic
  hi! NonText       guifg=#5c6370 guibg=NONE
  hi! EndOfBuffer   guifg=#3b4048 guibg=NONE
  hi! SignColumn    guibg=NONE
  hi! FoldColumn    guibg=NONE
  hi! VertSplit     guifg=#3b4048 guibg=NONE
  hi! WinSeparator  guifg=#3b4048 guibg=NONE

  " 行号：暗号 + 亮当前行（原来 #4b5263 在透明洗白底上几乎看不见）
  hi! LineNr        guifg=#7f8a99 guibg=NONE
  hi! CursorLineNr  guifg=#e5c07b guibg=NONE gui=bold
  hi! CursorLine    guibg=NONE gui=NONE

  " 选区 / 搜索
  hi! Visual     guibg=#3e4451 guifg=NONE
  hi! Search     guifg=#1e222a guibg=#e5c07b
  hi! IncSearch  guifg=#1e222a guibg=#98c379 gui=bold
  hi! MatchParen guifg=#e5c07b guibg=NONE gui=bold

  " 补全弹窗：深色卡片 + 深蓝选中条（亮蓝底会把 CocPumDetail/Search 衬成 1.3:1）
  hi! Pmenu       guifg=#dbe1ea guibg=#23272e
  hi! PmenuSel    guifg=#ffffff guibg=#33547e gui=bold
  hi! PmenuKind   guifg=#7fd4e0 guibg=#23272e
  hi! PmenuExtra  guifg=#9aa5b1 guibg=#23272e
  hi! PmenuMatch  guifg=#b6e39a guibg=#23272e gui=bold
  hi! PmenuMatchSel guifg=#ffffff guibg=#33547e gui=bold
  hi! PmenuSbar   guibg=#23272e
  hi! PmenuThumb  guibg=#4b5263

  " coc 浮窗（补全说明 / hover）
  hi! CocFloating     guibg=#23272e guifg=#dbe1ea
  hi! CocFloatBorder  guifg=#5c6370 guibg=NONE
  hi! CocFloatActive  guibg=#23272e
  hi! CocPumDetail    guifg=#cbd5e2
  hi! CocPumMenu      guifg=#9aa5b1
  hi! CocPumSearch    guifg=#b6e39a gui=bold
  hi! CocPumShortcut  guifg=#9aa5b1
  hi! CocPumDeprecated guifg=#8a94a4 gui=strikethrough
  hi! CocInlayHint    guifg=#7f8a99
  hi! CocCodeLens     guifg=#7f8a99

  " 诊断
  hi! CocErrorSign   guifg=#e06c75 guibg=NONE
  hi! CocWarningSign guifg=#e5c07b guibg=NONE
  hi! CocInfoSign    guifg=#61afef guibg=NONE
  hi! CocHintSign    guifg=#56b6c2 guibg=NONE
  hi! CocErrorHighlight   gui=undercurl guisp=#e06c75
  hi! CocWarningHighlight gui=undercurl guisp=#e5c07b
  hi! CocInfoHighlight    gui=undercurl guisp=#61afef
  hi! CocHintHighlight    gui=undercurl guisp=#56b6c2
  hi! CocUnusedHighlight  guifg=#5c6370 gui=underline guisp=#5c6370
  hi! CocDeprecatedHighlight guifg=#5c6370 gui=strikethrough

  " 状态栏（同样透明，只有模式块上色）
  hi! StatusLine   guifg=#abb2bf guibg=NONE gui=NONE
  hi! StatusLineNC guifg=#5c6370 guibg=NONE gui=NONE
  hi! StatusModeNormal  guifg=#1e222a guibg=#61afef gui=bold
  hi! StatusModeInsert  guifg=#1e222a guibg=#98c379 gui=bold
  hi! StatusModeVisual  guifg=#1e222a guibg=#c678dd gui=bold
  hi! StatusModeReplace guifg=#1e222a guibg=#e06c75 gui=bold
  hi! StatusModeCmd     guifg=#1e222a guibg=#e5c07b gui=bold
  hi! StatusModeTerm    guifg=#1e222a guibg=#56b6c2 gui=bold
  hi! StatusPath guifg=#abb2bf guibg=NONE
  hi! StatusGit  guifg=#98c379 guibg=NONE
  hi! StatusDim  guifg=#5c6370 guibg=NONE
  hi! StatusInfo guifg=#56b6c2 guibg=NONE
  hi! StatusError guifg=#e06c75 guibg=NONE gui=bold
  hi! StatusWarn  guifg=#e5c07b guibg=NONE gui=bold
endfunction

augroup ui_tweaks
  autocmd!
  autocmd ColorScheme * call UiTweaks()
augroup END

silent! colorscheme onedark
call UiTweaks()

" ---- 状态栏：  NORMAL  src/main.go ●  main  ✘1 ▲2  go  42:7
function! SLMode() abort
  let m = mode(1)[0]
  let map = {
        \ 'n': [' NORMAL ', 'StatusModeNormal'],
        \ 'i': [' INSERT ', 'StatusModeInsert'],
        \ 'R': [' REPLACE ', 'StatusModeReplace'],
        \ 'v': [' VISUAL ', 'StatusModeVisual'],
        \ 'V': [' V-LINE ', 'StatusModeVisual'],
        \ "\<C-v>": [' V-BLOCK ', 'StatusModeVisual'],
        \ 'c': [' COMMAND ', 'StatusModeCmd'],
        \ 't': [' TERMINAL ', 'StatusModeTerm'],
        \ }
  let [name, hl] = get(map, m, [' ' . toupper(m) . ' ', 'StatusModeNormal'])
  return '%#' . hl . '#' . name . '%*'
endfunction

" ---- 状态栏图标：用 nr2char 写码位，避免任何编码/转义歧义
let s:icon_err  = nr2char(0xF0159)   " md-close_circle
let s:icon_warn = nr2char(0xF0026)   " md-alert
let s:icon_git  = nr2char(0xF418)    " oct-git_branch

function! SLDiag() abort
  let d = get(b:, 'coc_diagnostic_info', {})
  let s = ''
  if get(d, 'error', 0) > 0
    let s .= '%#StatusError# ' . s:icon_err . ' ' . d.error . ' '
  endif
  if get(d, 'warning', 0) > 0
    let s .= '%#StatusWarn# ' . s:icon_warn . ' ' . d.warning . ' '
  endif
  return s
endfunction

function! SLGit() abort
  if !exists('b:git_branch')
    let b:git_branch = trim(system('git rev-parse --abbrev-ref HEAD 2>/dev/null'))
  endif
  return empty(b:git_branch) ? '' : '%#StatusGit# ' . s:icon_git . ' ' . b:git_branch . ' '
endfunction

function! SL() abort
  let path = empty(expand('%')) ? '[No Name]' : fnamemodify(expand('%'), ':~:.')
  let s = SLMode()
  let s .= '%#StatusPath# ' . escape(path, '%') . ' '
  let s .= '%#StatusDim#' . (&modified ? '● ' : '')
  let s .= SLGit()
  let s .= '%=' . SLDiag()
  let s .= '%#StatusInfo# ' . (empty(&filetype) ? '' : &filetype) . ' '
  let s .= '%#StatusDim# ' . line('.') . ':' . col('.') . ' '
  return s
endfunction

set statusline=%!SL()

augroup git_branch
  autocmd!
  autocmd BufEnter,DirChanged * unlet! b:git_branch
augroup END

" ---------------------------------------------------------------- coc 补全
" Tab / S-Tab 在候选列表里上下选择，否则触发/缩进
function! s:check_backspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_backspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <C-Space> coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" 上面这条被自动配对接管：空 {} 里回车展开成三行，其余情况仍走 coc 的逻辑
" （必须在上一行之后；只插入模式生效）
inoremap <silent><expr> <CR> autopair#cr()

" 跳转 / 查看
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> K  :call CocActionAsync('doHover')<CR>

" 重命名 / 代码动作 / 格式化 / 修错
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>ca <Plug>(coc-codeaction-cursor)
nmap <silent> <leader>cl <Plug>(coc-codeaction-line)
xmap <silent> <leader>ca <Plug>(coc-codeaction-selected)
nmap <silent> <leader>f  <Plug>(coc-format)
xmap <silent> <leader>f  <Plug>(coc-format-selected)
nmap <silent> <leader>qf <Plug>(coc-fix-current)
nmap <silent> <leader>oi :call <SID>organize_imports()<CR>

function! s:organize_imports() abort
  if &filetype ==# 'go'
    call CocAction('runCommand', 'editor.action.organizeImport')
  else
    echo 'organize imports: only configured for go (use <leader>ca in C/C++)'
  endif
endfunction

" 诊断
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <leader>d :CocDiagnostics<CR>
" 诊断开关：cb 只静音当前 buffer（一次性 .hpp / 试验文件），cB 全局开关
" 末尾那句扫掉“孤儿标志”：clangd 崩过之后，coc 的 clear() 只清自己 map 里的
" collection，没有 collection 归属的标志会一直在，只能直接 unplace
nmap <silent> <leader>cb :call CocAction('diagnosticToggleBuffer', bufnr('%'))<CR>:sign unplace * group=*<CR>
nmap <silent> <leader>cB :call CocAction('diagnosticToggle')<CR>
nmap <silent> <leader>cR :CocRestart<CR>

" 大纲 / 符号
nmap <silent> <leader>o :CocOutline<CR>

" 悬浮/签名帮助窗口样式
set previewheight=12

" ---------------------------------------------------------------- 语言细节
augroup filetype_c_cpp
  autocmd!
  autocmd FileType c,cpp,objc,objcpp,cu
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=0 expandtab
        \ commentstring=//\ %s
        \ path+=/usr/local/include,/opt/homebrew/include
augroup END

augroup filetype_go
  autocmd!
  " Go 用 Tab 缩进（gofmt 要求）
  autocmd FileType go
        \ setlocal noexpandtab tabstop=2 shiftwidth=0 softtabstop=0
        \ commentstring=//\ %s
        \ nolist
augroup END

" 大文件关掉相对行号/高亮，保持流畅
augroup bigfile
  autocmd!
  autocmd BufReadPre * if getfsize(expand('<afile>')) > 5*1024*1024
        \ | setlocal norelativenumber noundofile | endif
augroup END

" 临时/一次性文件不挂诊断：放 /tmp 下的试验 .hpp 不该满屏红线
augroup coc_scratch
  autocmd!
  autocmd BufReadPost,BufNewFile /tmp/*,/private/tmp/* let b:coc_diagnostic_disable = 1
augroup END
