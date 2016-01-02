" CHECK THIS FIRST
"
" requires vim 7.4
"
" works on fedora 20 but on ubuntu 12.04 you have to compile vim7.4
"
" follow instructions on https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
"
" add these steps to enable lua (required for jedi-vim):
"
" apt-get install lua5.1 liblua5.1-0 liblua5.1-0-dev
" cp -rpv /usr/include/lua5.1/* /usr/include/lua5.1/include
" ln -s /usr/lib/x86_64-linux-gnu/liblua5.1.so /usr/local/lib/liblua.so
" add  --enable-luainterp to above link configure phase
" use checkinstall to create reusable package
" check by doing: vim --version | grep lua | less
"
" git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" vim +BundleInstall
set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
let mapleader=","

" global config
filetype on
syntax on
filetype indent on
filetype plugin on

au BufRead,BufNewFile *.json set filetype=json 

" escape the tyranny of escape
imap jk 

" save on the fly
noremap <Leader>s :update<CR>

" shift+zz to save and quit

" let Vundle manage Vundle
" " required!
Bundle 'gmarik/Vundle.vim'

" my bundles

Bundle 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

Bundle 'scrooloose/nerdtree'
map <leader>nt :NERDTreeToggle<CR>
" mappings
" o - open file in current window and shift focus
" go - open file in current window but leave cursor in nerdtree
" i - open file in new split window and shift focus
" gi - open file in new split window but leave cursor in nerdtree

Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-i>"
let g:UltiSnipsJumpBackwardTrigger="<c-o>"
let g:UltiSnipsEditSplit="vertical"
set runtimepath+=~/.vim/bundle/ultisnips

" work required post install to make auto file detection work
" mkdir -p ~/.vim/after/plugin
" ln -s ~/.vim/bundle/UltiSnips/after/plugin/* ~/.vim/after/plugin
" mkdir ~/.vim/ftdetect
" ln -s ~/.vim/bundle/UltiSnips/ftdetect/* ~/.vim/ftdetect

" plugin youcompleteme
" not installed as it requires vim 7.4 + is too heavy to install and keep in git
"Bundle 'Valloric/YouCompleteMe'


py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

"Bundle 'klen/rope-vim'
" not using as of now - as search/replacement very slow
"map <leader>j :RopeGotoDefinition<CR>
"map <leader>r :RopeRename<CR>

Bundle 'vim-scripts/TaskList.vim'
map <leader>td <Plug>TaskList
" add TODO at top of your file and ,td will search it

" apt-get install pyflakes pylint
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-unimpaired'

let g:syntastic_mode_map = { 'mode': 'active' }
"let g:syntastic_mode_map = { 'mode': 'active',
"    \ 'active_filetypes': [],
"    \ 'passive_filetypes': ['html'] }
"
map <leader>c :SyntasticCheck<CR>
map <leader>cc :SyntasticReset<CR>

let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1

" requires yum install pylint
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_pylint_args = '--ignore="W0613" --indent-string="  "'

" requires npm install jsonlint - see to it that ruby gem jsonlint path does
" not come first in the path
let g:syntastic_json_checkers=['jsonlint']
let g:syntastic_json_jsonlint_exec = '/usr/bin/jsonlint'
let g:syntastic_error_symbol = 'x'
let g:syntastic_warning_symbol = '!'

Bundle 'voithos/vim-python-matchit'
" ]%  - go to end of block
" [%  - go to beginning of blck
" v]% - start selecting block in visual
" V]% - select whole block in visual
" d]% - select whole block in visual

Bundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
"let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
" ctrl-t to open in new tab
" ctrl-x to open in new split window
" enter to open it inline

Bundle 'vim-scripts/sessionman.vim'
map <Leader>so :SessionOpen 
map <Leader>ss :SessionSave<CR>
map <Leader>ssa :SessionSaveAs 

"Bundle 'mileszs/ack.vim'
"let g:ackprg="/usr/local/bin/ack -H --nocolor --nogroup --column"
"map <Leader>s :Ack 
" apt-get install ack-grep
" ln -s /usr/bin/ack-grep /usr/local/bin/ack

Bundle 'itchyny/lightline.vim'
Bundle 'bling/vim-bufferline'

"let g:lightline = {
"  \ 'active': {
"  \   'left': [ [ 'mode', 'paste' ], [ 'filename' ], [ 'bufferline' ] ],
"  \ },
"  \ 'component': {
"  \   'bufferline': '%{bufferline#refresh_status()}%{g:bufferline_status_info.before . g:bufferline_status_info.current . g:bufferline_status_info.after}'
"  \ }
"  \ }
map <C-J> :bprev<CR>
map <C-K> :bnext<CR>
"map <Leader>, :bnext<CR>
map <Leader>, :e#<CR>
nnoremap <Leader>1 :2b<CR>
nnoremap <Leader>2 :3b<CR>
nnoremap <Leader>3 :4b<CR>
nnoremap <Leader>4 :5b<CR>
nnoremap <Leader>5 :6b<CR>
nnoremap <Leader>6 :7b<CR>
nnoremap <Leader>7 :8b<CR>
nnoremap <Leader>8 :9b<CR>
nnoremap <Leader>9 :10b<CR>
" close the tab
map <Leader>q :bd<CR>
set hidden " allow hidden buffers


"set ts=4 et sw=4 sts=4

" code folding
set foldmethod=indent
set foldlevel=99 " type za to open up

" execute python
set splitbelow
:map <leader>e :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee ~/.vim/output<CR>:split ~/.vim/output<CR>:redraw!<CR>

" move around windows
"map <c-j> <c-w>j
"map <c-k> <c-w>k
"map <c-l> <c-w>l
"map <c-h> <c-w>h

" don't outdent hashes
inoremap # #
"autocmd FileType python UltiSnipsAddFiletypes django
autocmd FileType html UltiSnipsAddFiletypes javascript
autocmd FileType css UltiSnipsAddFiletypes css
"autocmd FileType javascript UltiSnipsAddFiletypes javascript.javascript_jasmine.json
autocmd FileType xml UltiSnipsAddFiletypes xml

Bundle 'benjifisher/matchit.zip'

Bundle 'hynek/vim-python-pep8-indent'

Bundle 'nathanaelkane/vim-indent-guides'

Bundle 'pangloss/vim-javascript'
let g:javascript_enable_domhtmlcss=1

Bundle 'Raimondi/delimitMate'

Bundle 'valloric/MatchTagAlways'

"Bundle 'vim-scripts/buftabs'

Bundle 'vim-scripts/jQuery'
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
set shortmess=a
set smarttab
set cindent
set copyindent
set smartindent

Bundle 'altercation/vim-colors-solarized'

syntax enable
if !has('gui_running')
  set t_Co=256
  set term=xterm-256color
endif

set background=dark
"let g:solarized_termcolors=256
let g:solarized_termtrans = 1

" colorschems
Bundle 'jnurmine/Zenburn'
Bundle 'vim-scripts/Wombat'
Bundle 'tomasr/molokai'
"Bundle 'michalbachowski/vim-wombat256mod'

let g:rehash256 = 1
set laststatus=2
let g:lightline = {
\ 'colorscheme': 'jellybeans',
\ }

set tags=~/mytags
map <leader>t :silent! !ctags -R -o ~/mytags .<CR>

Bundle 'Shougo/neocomplete.vim'
let g:neocomplcache_enable_at_startup = 1
let g:acp_enableAtStartup = 1 
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_enable_fuzzy_completion = 0

Bundle 'ervandew/supertab'
set omnifunc=syntaxcomplete#Complete
"au FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
set completeopt=menu
let g:SuperTabDefaultCompletionType="context"
" to do text select via j/k
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))

Bundle 'davidhalter/jedi-vim'
let g:jedi#popup_select_first = 0
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 1
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#completions_enabled = 1
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
"let g:jedi#completions_command = "<C-Space>"
let g:jedi#completions_command = "<s-tab>"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "1"
au FileType python setlocal completeopt-=preview
"set omnifunc=jedi#completions

" to use with tmux -2 - so as to enable wombat
set t_ut=

"Bundle 'Valloric/YouCompleteMe'

call vundle#end()
filetype plugin indent on

autocmd GUIEnter * set vb t_vb=
abb btk `

" for 80 col coding
autocmd FileType python set colorcolumn=80
autocmd FileType ruby set colorcolumn=80
highlight ColorColumn ctermbg=brown guibg=orange
autocmd Syntax * syn match Error /\s\+$\| \+\ze\t/ containedin=ALL display
set ts=2 et sw=2 sts=2
set noswapfile

Bundle 'aklt/vim-substitute'

"let marvim_store = '/home/shirani/marvim.store'
"let marvim_find_key = '<Space>' " change find key from <F2> to 'space'
"let marvim_store_key = 'ms'     " change store key from <F3> to 'ms'
"let marvim_register = 'c'       " change used register from 'q' to 'c'
"let marvim_prefix = 0           " disable default syntax based prefix
"source /home/shirani/.vim/bundle/marvim/plugin/marvim.vim

Bundle 'elzr/vim-json'
let g:vim_json_syntax_conceal=0
"let g:indentLine_noConcealCursor=""
"augroup json_autocmd 
"  autocmd! 
"  autocmd FileType json set autoindent 
"  "autocmd FileType json set formatoptions=tcq2l 
"  autocmd FileType json set textwidth=78 shiftwidth=2 
"  autocmd FileType json set softtabstop=2 tabstop=8 
"  autocmd FileType json set expandtab 
"  autocmd FileType json set foldmethod=syntax 
"augroup END

Bundle 'rodnaph/vim-color-schemes'
colorscheme solarized

"http://stackoverflow.com/questions/2024443/saving-vim-macros
"http://www.nyayapati.com/srao/2013/08/run-a-macro-in-all-buffers-in-vim/
"source /var/tmp/buffers.vim
