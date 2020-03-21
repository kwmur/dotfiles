set nocompatible
scriptencoding utf-8

" initialize runtimepath.  {{{
" set runtimepath&

" Even Windows uses "$HOME/.vim".
let &runtimepath = substitute(
  \ &runtimepath,
  \ escape($HOME, '\') . '/vimfiles',
  \ escape($HOME, '\') . '/.vim',
  \ 'g')
"}}}

if 600 <= v:version "{{{
  filetype plugin indent on
endif
"}}}

" backup file {{{
set backup
"set backupdir=$HOME/.tmp
"set writebackup
" }}}

" swap file"{{{
set swapfile
"set directory=$HOME/.tmp
"}}}

" vim character encoding {{{
"set enc=utf-8
"set enc=cp932
"}}}

" file character encoding {{{
"set fenc=utf-8
"set fenc=cp932
"set fencs=utf-8,cp932,euc-jp,iso-2022-jp
"}}}

" newline character {{{
"set ff=unix
"set ff=dos
"}}}

" setting editor action {{{

" use clipboard
set clipboard+=unnamed,autoselect

set wrap

set sidescroll=1

" command line incomplete expand mode
set wildmenu

set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

" can delete indent, newline etc
set backspace=2

" [text]{white}{vi:|vim:|ex:}[white]{options}
set modeline

" shoe message last line (insert mode, <R> mode, visual mode)
set showmode

set foldmethod=marker

"set viminfo='1000,f1,<500

set sessionoptions+=unix,slash

set belloff=all

" }}}

" search settings {{{
set hlsearch
set incsearch

" character case when search pattern
set ignorecase

" rewrite ignorecase when search pattern include upper case
set smartcase

" if search file end, start from file head
set wrapscan

"}}}

" config TAB, space, newline {{{

" display TAB, newline etc
set list

" TAB, newline, space visual character
" NonText
set listchars=eol:<,extends:&,precedes:>
" SpecialKey
set listchars+=nbsp:%,tab:^-,trail:-

"TAB character width on display
set tabstop=8

" move corsol width when push TAB
set softtabstop=2

" push TAB space insert
" if expandtab on, input TAB character ^v-TAB
set expandtab

" }}}

" indent {{{
"set autoindent
set cindent
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
"set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
"set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く

" auto indent width
set shiftwidth=2

" auto newline text width
set textwidth=0

" multi byte setting
" if line format broken, command "gq" reformat
" http://hirotak.exblog.jp/14210291
set formatoptions+=mM

" highlight column textwidth value
" http://vim-users.jp/2011/05/hack217/
if exists('&colorcolumn')
  set colorcolumn=+1
endif

" }}}

" config editor view {{{
set number

" show row number, column number
set ruler

" show tab page label
set showtabline=2

set laststatus=2

set showcmd

" command line height (when CUI running)
set cmdheight=2

"}}}

" Highlight settings {{{
" color settings newline(NonText), TAB(SpecialKey)
function! Highlight_special_key()
  highlight SpecialKey
    \ cterm=NONE ctermfg=lightgrey
    \ gui=NONE guifg=Gray40
"    \ cterm=NONE ctermfg=lightgrey ctermbg=NONE
"    \ gui=NONE guifg=Gray40 guibg=NONE
"  highlight NonText
"    \ cterm=NONE ctermfg=lightgrey
"    \ gui=NONE guifg=Gray40
endfunction

" highlight Zenkaku Space
" define default ZenkakuSpace
function! Highlight_zenkaku_space()
  highlight ZenkakuSpace
    \ cterm=underline ctermfg=lightred ctermbg=lightgrey
    \ gui=underline guifg=lightred guibg=darkgray
endfunction

" insert mode, change status line color
" highlight status line when insert leave
function! Highlight_status_line_insert_leave()
  highlight StatusLine
    \ ctermfg=lightyellow ctermbg=darkgray
    \ guifg=#2E4340 guibg=#ccdc90
endfunction

function! Augroup_insert_hook()
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * highlight StatusLine
      \ ctermfg=darkgray ctermbg=lightyellow
      \ guifg=#ccdc90 guibg=#2E4340
    autocmd InsertLeave * call Highlight_status_line_insert_leave()
  augroup END

  " if chenge status line late after <ESC>
  if has('unix') && !has('gui_running')
    inoremap <silent> <ESC> <ESC>
    inoremap <silent> <C-[> <ESC>
  endif
endfunction

function! Highlight_status_line()
  call Augroup_insert_hook()
  call Highlight_status_line_insert_leave()
endfunction

function! Augroup_zenkaku_space()
  augroup Highlight_zenkaku_group
    autocmd!
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
endfunction

function! Augroup_highlight()
  augroup Highlight_group
    autocmd!
    " if Highlight config in color file, this line delete
    autocmd ColorScheme * call Highlight_change_color_scheme()
  augroup END
endfunction

" call when change ColorScheme
function! Highlight_change_color_scheme()
  call Highlight_special_key()
  call Highlight_zenkaku_space()
  call Highlight_status_line()
endfunction

" boot
if has('syntax')
  call Augroup_zenkaku_space()
  call Augroup_highlight()
  call Highlight_change_color_scheme()
endif
"}}}

" config Japanese {{{
if has('kaoriya')
  augroup Japanese_config
    autocmd!
    " reset Japanese input
    "autocmd VimEnter,BufNewFile,BufReadPost * IminsertOff
    autocmd VimEnter * IminsertOff
  augroup END
else
  augroup Japanese_config
    autocmd!
    " reset Japanese input
    autocmd BufNewFile,BufRead,InsertEnter,InsertLeave *
      \ set iminsert=0 imsearch=0
    " auto Japanese input when .txt file
    " autocmd BufNewFile,BufRead *.txt set iminsert=2
  augroup END
endif
"}}}

" Menu {{{
if has('kaoriya')
  augroup Menu_config
    autocmd!
    autocmd VimEnter * MenuLang en
  augroup END
endif
"}}}

" key map {{{
noremap <silent> <C-n> :tabnext<CR>
noremap <silent> <C-p> :tabprevious<CR>

noremap <silent> <Space>s :tab split<CR>
"}}}

" plugin package manage tool {{{

" vimball {{{
let g:vimball_home = expand('~/.vim')
"}}}


" vim-quickrun {{{
"let g:quickrun_config = {}
let g:quickrun_config = get(g:, 'quickrun_config', {})
" vimproc を使って非同期に実行し，結果を quickfix に出力する
let g:quickrun_config._ = {
  \ 'outputter' : 'quickfix',
  \ 'runner' : 'vimproc'
\ }
 
" C++
let g:quickrun_config.cpp = {
  \ 'command' : 'clang++',
  \ 'cmdopt' : '-std=c++1y -Wall -Wextra',
  \ 'hook/quickrunex/enable' : 1,
\ }

let g:quickrun_config['cpp/gcc'] = {
  \ 'command' : 'g++',
  \ 'cmdopt' : '-std=c++11 -Wall -Wextra',
\ }
"}}}

" vim-indent-guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

"let g:indent_guides_auto_colors = 1 " if colorscheme ron does not use.
"let g:indent_guides_color_change_percent = 10
augroup plugin_indent_guides_group
  autocmd!
  autocmd VimEnter,Colorscheme *
    \ highlight IndentGuidesOdd guibg=#262626 ctermbg=darkblue
  autocmd VimEnter,Colorscheme *
    \ highlight IndentGuidesEven guibg=#121212 ctermbg=darkgray
augroup END
"}}}

"" neocomplete {{{
"" Disable AutoComplPop.
"let g:acp_enableAtStartup = 0
"" Use neocomplete.
"let g:neocomplete#enable_at_startup = 1
"" Use smartcase.
"let g:neocomplete#enable_smart_case = 1
"" Set minimum syntax keyword length.
"let g:neocomplete#sources#syntax#min_keyword_length = 3
"let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
"
"" Define dictionary.
"let g:neocomplete#sources#dictionary#dictionaries = {
"      \ 'default' : '',
"      \ 'vimshell' : $HOME.'/.vimshell_hist',
"      \ 'scheme' : $HOME.'/.gosh_completions'
"      \ }
"
"" Define keyword.
"if !exists('g:neocomplete#keyword_patterns')
"  let g:neocomplete#keyword_patterns = {}
"endif
"let g:neocomplete#keyword_patterns['default'] = '\h\w*'
"
"" Plugin key-mappings.
"inoremap <expr><C-g>     neocomplete#undo_completion()
"inoremap <expr><C-l>     neocomplete#complete_common_string()
"
"" Recommended key-mappings.
"" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
"  return neocomplete#close_popup() . "\<CR>"
"  " For no inserting <CR> key.
"  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
"endfunction
"" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><C-y>  neocomplete#close_popup()
"inoremap <expr><C-e>  neocomplete#cancel_popup()
"" Close popup by <Space>.
""inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
"
"" For cursor moving in insert mode(Not recommended)
""inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
""inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
""inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
""inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
"" Or set this.
""let g:neocomplete#enable_cursor_hold_i = 1
"" Or set this.
""let g:neocomplete#enable_insert_char_pre = 1
"
"" AutoComplPop like behavior.
""let g:neocomplete#enable_auto_select = 1
"
"" Shell like behavior(not recommended).
""set completeopt+=longest
""let g:neocomplete#enable_auto_select = 1
""let g:neocomplete#disable_auto_complete = 1
""inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
"
"" Enable omni completion.
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"
"" Enable heavy omni completion.
"if !exists('g:neocomplete#sources#omni#input_patterns')
"  let g:neocomplete#sources#omni#input_patterns = {}
"endif
""let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
""let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
""let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"
"" For perlomni.vim setting.
"" https://github.com/c9s/perlomni.vim
"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"
"if !exists('g:neocomplete#force_omni_input_patterns')
"      let g:neocomplete#force_omni_input_patterns = {}
"endif
"let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
""}}}

" vim-marching"{{{
let g:marching_enable_neocomplete = 1
"}}}

" Neosnippet {{{
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
"}}}

" .vimrcの編集を簡単にする {{{
" http://vim-users.jp/2009/09/hack74/

" .vimrcや.gvimrcを編集するためのKey-mappingを定義する
nnoremap <silent> <Space>ev  :<C-u>edit $HOME/.vim/.vimrc<CR>
nnoremap <silent> <Space>eg  :<C-u>edit $HOME/.vim/.gvimrc<CR>

" .vimrcや.gvimrcの変更を反映するためのKey-mappingを定義する
nnoremap <silent> <Space>rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR>
nnoremap <silent> <Space>rg :<C-u>source $MYGVIMRC<CR>

" .vimrcや.gvimrcを変更すると、自動的に変更が反映されるようにする
augroup MyAutoCmd
autocmd!
augroup END

if !has('gui_running') && !(has('win32') || has('win64'))
  " .vimrcの再読込時にも色が変化するようにする
  autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
" .vimrcの再読込時にも色が変化するようにする
  autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC |
    \if has('gui_running') | source $MYGVIMRC
  autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif
"}}}

" JSON Format {{{
command! JsonFormat :execute '%!python -m json.tool'
command! JsonFormatWithUnicodeDecode :execute '%!python -m json.tool'
  \ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)), sys.stdin.read()))"'
  \ | :%s/ \+$//ge
  \ | :set ft=javascript
  \ | :1
"}}}

" Vimfiler {{{
nnoremap <silent><Space>f :VimFiler<CR>
" }}}

" Tagbar {{{
nnoremap <silent><Space>t :TagbarToggle<CR>
"}}}

" Unite {{{
" insert modeで開始しない
let g:unite_enable_start_insert = 0

" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

let g:unite_source_file_mru_limit = 300

nnoremap [unite] <Nop>
nmap     <Space>u [unite]

" source list
nnoremap <silent> [unite]s :<C-u>Unite source<CR>

" バッファリストを表示する
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
" 最近使ったファイルの一覧を表示する
nnoremap <silent> [unite]fm :<C-u>Unite file_mru<CR>
" 現在のバッファがあるディレクトリのファイル一覧を表示する
nnoremap <silent> [unite]cf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧=ヤンク履歴を表示する
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
" 一覧表示したいもの全部
nnoremap <silent> [unite]a :<C-u>UniteWithCurrentDir -buffer-name=files buffer file file_mru bookmark<CR>

" カレントディレクトリ以下のファイル
function! DispatchUniteFileRecAsyncOrGit()
  if isdirectory(getcwd()."/.git")
    Unite file_rec/git -default-action=tabopen
  else
    Unite file_rec/async -default-action=tabopen
  endif
endfunction

nnoremap <silent> [unite]fr :<C-u>call DispatchUniteFileRecAsyncOrGit()<CR>

" find
nnoremap <silent> [unite]fi :<C-u>Unite find -default-action=tabopen<CR>
" C#
nnoremap <silent> [unite]fIcs :<C-u>Unite find -default-action=tabopen<CR><CR>'*.cs'<CR>
"}}}

" unite-grep {{{
" unite-grepのバックエンドをagに切り替える
" http://qiita.com/items/c8962f9325a5433dc50d
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nocolor --nogroup'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_grep_max_candidates = 200

  " grep検索
  nnoremap <silent> [unite]g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

  " カーソル位置の単語をgrep検索
  " FIXME: 意図通りに動かない
  nnoremap <silent> [unite]cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

  " grep検索結果の再呼出
  nnoremap <silent> [unite]sbr :<C-u>UniteResume search-buffer<CR>

  " unite-grepのキーマップ
  " 選択した文字列をunite-grep
  " https://github.com/shingokatsushima/dotfiles/blob/master/.vimrc
  vnoremap /g y:Unite grep::-iHRn:<C-R>=escape(@", '\\.*$^[]')<CR><CR>
endif
"}}}

" unite-n3337 {{{
let g:unite_n3337_pdf = expand('~/Documents/cpp/n3337.pdf')
"}}}

" config colorscheme (CUI) {{{
syntax on
"colorscheme blue
"colorscheme darkblue
"colorscheme default
"colorscheme delek
"colorscheme desert "nice
"colorscheme elflord "nice
"colorscheme evening "nice
"colorscheme koehler "nice
"colorscheme morning
"colorscheme murphy "nice
"colorscheme pablo "nice
"colorscheme peachpuff
"colorscheme ron "nice
"colorscheme shine
"colorscheme slate
"colorscheme torte "nice
"colorscheme zellner

let os = substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
  "set background=dark
  "colorscheme solarized
  colorscheme ron
elseif os == 'Linux'
  colorscheme evening
else
  colorscheme evening
endif
"}}}

" C++ settings {{{
augroup cpp-path
  autocmd!
  autocmd FileType cpp setlocal path+=/usr/local/include
augroup END

augroup cpp-unite
  autocmd!
  autocmd FileType cpp nnoremap [unite]db :<C-u>UniteWithCursorWord boost-online-doc
augroup END

augroup cpp-namespace
  autocmd!
  autocmd FileType cpp inoremap <buffer><expr>; <SID>expand_namespace()
augroup END

function! s:expand_namespace()
  let s = getline('.')[0:col('.')-1]
  if s =~# '\<b;$'
    return "\<BS>oost::"
  elseif s =~# '\<s;$'
    return "\<BS>td::"
  elseif s =~# '\<d;$'
    return "\<BS>etail::"
  else
    return ';'
  endif
endfunction
"}}}

" vim-clang-format {{{
let g:clang_format#style_options = {
      \ 'AccessModifierOffset' : -4,
      \ 'AllowShortIfStatementsOnASingleLine' : 'true',
      \ 'AlwaysBreakTemplateDeclarations' : 'true',
      \ 'Standard' : 'C++11',
      \ 'BreakBeforeBraces' : 'Stroustrup',
      \ }
"}}}


" Dein.vim {{{
if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  " Let dein manage dein
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  "call dein#add('Shougo/deoplete.nvim')
  "if !has('nvim')
  "  call dein#add('roxma/nvim-yarp')
  "  call dein#add('roxma/vim-hug-neovim-rpc')
  "endif

  " toml path
  let s:toml_dir  = expand('~/.vim/rc')
  let s:toml      = s:toml_dir . '/dein.toml'
  let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'
  " cache toml
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"}}}


