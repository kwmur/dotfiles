set nocompatible
scriptencoding utf-8

" font settings {{{
if has('win32')
  " Windows
  set guifont=Ricty\ Discord:h12,
             \MigMix_1M:h9:cDEFAULT,
             \MigMix_2M:h9:cDEFAULT,
             \MS_Gothic:h10:cSHIFTJIS,
             \MS_Mincho:h10:cSHIFTJIS
  "set guifontwide=Ricty\ Discord:h12
  set linespace=1
  " calc UCS character width
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  set guifont=Ricty\ Discord:h13,
             \Osaka－等幅:h14
  "set guifontwide=Ricty\ Discord\ 12
  if has('kaoriya')
    set imdisable
  endif
elseif has('xfontset')
  " UNIX (use xfontset)
  set guifontset=a14,r14,k14
endif
" }}}

" config window {{{
" window width (when GUI running)
set columns=150

" window height (when GUI running)
set lines=60

" command line height (when GUI running)
set cmdheight=2

" }}}

" mause settings {{{
" visual selected auto to clipboard
" (:help guioptions_a)
set guioptions+=a

" }}}

" config colorscheme (when GUI running) {{{
"colorscheme blue
"colorscheme darkblue " CUI nice
"colorscheme default
"colorscheme delek
"colorscheme desert "nice
"colorscheme elflord "nice
"colorscheme evening
"colorscheme koehler "nice
"colorscheme morning
"colorscheme murphy "nice
"colorscheme pablo "nice
"colorscheme peachpuff
"colorscheme ron "GUI nice
"colorscheme shine
"colorscheme slate
colorscheme torte "nice
"colorscheme zellner
" }}}

" 全角モードの時に赤色にする {{{
if has('multi_byte_ime') || has('xim')
  highlight Cursor guifg=NONE guibg=White
  highlight CursorIM guifg=NONE guibg=DarkRed
endif
" }}}

" {{{
set transparency=20
" }}}

