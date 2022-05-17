"
" base settings
"
autocmd!
lang en_US.UTF-8
colorscheme jellybeans

let mapleader = "\<Space>" " set leader to space key

set nocompatible           " do not use vi compatible mode
set number                 " display line number
set title                  " display filename
set nowrap                 " do not wrap at a line
set tabstop=4
set shiftwidth=4

filetype plugin indent on  " enable filetype detection, filetype plugin and indent plugin

set hlsearch               " highlight the search word
set ignorecase             "     with ignore case
set smartcase              "     with smart case

set clipboard=unnamed      " yank text share to clipboard
set ambiwidth=double       " display double-byte characters correctly

" highlight space at the end of line
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

" indents and tabs
set shiftwidth=4
set autoindent
set expandtab   " convert tab to spaces
set tabstop=4   " spaces number of tab
set textwidth=0 " text width
if version >=800 || has("nvim")
    set breakindent
endif
set formatoptions=q
autocmd FileType * setlocal formatoptions-=ro

" complement blackets
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>

"
" plugins
"
call plug#begin()

" lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" completion
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" snipet
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" filer
Plug 'lambdalisue/fern.vim'
Plug 'yuki-yano/fern-preview.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'

" file search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" git diff in file
Plug 'airblade/vim-gitgutter'

" golang
Plug 'mattn/vim-goimports'
Plug 'mattn/vim-goaddtags'
Plug 'mattn/vim-goimpl'

" terraform
Plug 'hashivim/vim-terraform'

call plug#end()

"
" lsp setting
"
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <leader>ca <plug>(lsp-code-action)
    nmap <buffer> <leader>cl <plug>(lsp-code-lens)
    nmap <buffer> <leader>gd <plug>(lsp-definition)
    nmap <buffer> <leader>gi <plug>(lsp-implementation)
    nmap <buffer> <leader>gr <plug>(lsp-references)
    nmap <buffer> <leader>gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>sm <plug>(lsp-document-symbol-search)
    nmap <buffer> <leader>Sm <plug>(lsp-workspace-symbol-search)
    nmap <buffer> <leader>ee <plug>(lsp-document-diagnostics)
    nmap <buffer> <leader>en <plug>(lsp-next-error)
    nmap <buffer> <leader>ep <plug>(lsp-previous-error)
    nmap <buffer> <leader>pd <plug>(lsp-peek-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)

    let g:lsp_format_sync_timeout = 1000
	let g:lsp_diagnostics_echo_cursor = 1
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"
" fern setting
"
let g:fern#renderer = 'nerdfont'
nmap <silent> <leader>fe :<C-u>Fern .<CR>
nmap <silent> <leader>fd :<C-u>Fern . -reveal=% -drawer -toggle -width=40<CR>

function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

"
"" vim-airline setting
"
let g:airline#extensions#tabline#enabled = 1                                  " change display on status line
let g:airline#extensions#default#layout = [
  \ [ 'a', 'b', 'c' ],
  \ ['z']
  \ ]
let g:airline_section_c = '%t %M'
let g:airline_section_z = get(g:, 'airline_linecolumn_prefix', '').'%3l:%-2v' " no show diff line counts if there are no changes
let g:airline#extensions#hunks#non_zero_only = 1                              " change display on tab line
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_close_button = 0
nmap <silent> <leader>tp <Plug>AirlineSelectPrevTab
nmap <silent> <leader>tn <Plug>AirlineSelectNextTab

"
"" git-gutter
"
let g:gitgutter_highlight_lines = 1
nnoremap g[ :GitGutterPrevHunk<CR>
nnoremap g] :GitGutterNextHunk<CR>
nnoremap gh :GitGutterLineHighlightsToggle<CR>
nnoremap gp :GitGutterPreviewHunk<CR>
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=blue
highlight GitGutterDelete ctermfg=red

"
"" fzf.vim
"
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\ 'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\ <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}, 'up:60%')
\ : fzf#vim#with_preview({'options': '--exact --delimiter : --nth 3..'}, 'right:50%:hidden', '?'),
\ <bang>0)
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fs :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fl :BLines<CR>
nnoremap <leader>fm :Marks<CR>
nnoremap <leader>fh :History<CR>

"
" go import
"
let g:goimports_simplify = 1

"
" terraform-ls
"
if executable('terraform-ls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'terraform-ls',
        \ 'cmd': {server_info->['terraform-ls', 'serve']},
        \ 'whitelist': ['terraform'],
        \ })
endif
