" README!!
"
" Supported OS:
"   1. Fedora 20 - you can get vim 7.4
"
"   2. Ubuntu - you have to compile 7.4
"
"     follow instructions on https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
"
"     add these steps to enable lua (required for jedi-vim):
"
"     apt-get install lua5.1 liblua5.1-0 liblua5.1-0-dev
"     cp -rpv /usr/include/lua5.1/* /usr/include/lua5.1/include
"     ln -s /usr/lib/x86_64-linux-gnu/liblua5.1.so /usr/local/lib/liblua.so
"     add  --enable-luainterp to above link configure phase
"     use checkinstall to create reusable package
"     check by doing: vim --version | grep lua | less
"
"   3. Mac OS X - using system vim causes problems with plugins - use neovim instead
"
" Installing plugins
"   - git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"   - vim +BundleInstall

set nocompatible               " be iMproved
filetype off                   " required!

" ========== Use vundle ==========
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
let mapleader=","
inoremap <leader>x <C-x><C-o>
" ========== Use vundle ==========

" ========== Global config ==========
filetype on
syntax on
filetype indent on
set nu
set ts=2 et sw=2 sts=2
set noswapfile
" to use with tmux -2 - so as to enable wombat
set t_ut=
autocmd GUIEnter * set vb t_vb=
abb xybtk `

Bundle 'tpope/vim-commentary'
" Use gcc to comment out a line (takes a count)
" gc to comment out the target of a motion (for example, gcap to comment out a paragraph)
" gc in visual mode to comment out the selection 
" gc in operator pending mode to target a comment. 
" You can also use it as a command, either with a range like :7,17Commentary, or as part of a :global invocation like with :g/TODO/Commentary.
" ========== Global config ==========


" ========== Filetypes ==========
au BufRead,BufNewFile *.json set filetype=json
au BufRead,BufNewFile *.template set filetype=json
" ========== Filetypes ==========

" ========== Colorschemes ==========
Bundle 'jnurmine/Zenburn'
Bundle 'vim-scripts/Wombat'
Bundle 'flazz/vim-colorschemes'
Bundle 'rodnaph/vim-color-schemes'

set background=dark
let g:solarized_termtrans = 1

let g:rehash256 = 1
set laststatus=2
let g:lightline = {
\ 'colorscheme': 'jellybeans',
\ }

Bundle 'itchyny/lightline.vim'
Bundle 'bling/vim-bufferline'

Bundle 'altercation/vim-colors-solarized'

syntax enable
if !has('gui_running')
  set t_Co=256
  "set term=xterm-256color
endif

"use autocmd because setting colorscheme via 'let' doesn't load it properly (long left vertical bar is shaded)
autocmd VimEnter * colorscheme solarized
" ========== Colorschemes ==========

" ========== python ==========
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
" execute python
set splitbelow
:map <leader>e :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee ~/.vim/output<CR>:split ~/.vim/output<CR>:redraw!<CR>
" ========== python ==========

" ========== ruby ==========
Bundle 'vim-ruby/vim-ruby'
" ========== ruby ==========


" ========== golang ==========
au BufRead,BufNewFile *.go set filetype=go

Plugin 'fatih/vim-go'
Bundle 'fatih/molokai'

"autocmd BufEnter *.go colorscheme molokai
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_autodetect_gopath = 0
" ========== golang ==========

" ========== nerdtree ==========
Bundle 'scrooloose/nerdtree'
map <leader>nt :NERDTreeToggle<CR>
" o - open file in current window and shift focus
" go - open file in current window but leave cursor in nerdtree
" i - open file in new split window and shift focus
" gi - open file in new split window but leave cursor in nerdtree
" ========== nerdtree ==========

" ========== Ultisnips ==========
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-i>"
let g:UltiSnipsJumpBackwardTrigger="<c-o>"
let g:UltiSnipsEditSplit="vertical"
set runtimepath+=~/.vim/bundle/ultisnips

"autocmd FileType python UltiSnipsAddFiletypes django
"autocmd FileType html UltiSnipsAddFiletypes javascript
"autocmd FileType css UltiSnipsAddFiletypes css
"autocmd FileType javascript UltiSnipsAddFiletypes javascript.javascript_jasmine.json
"autocmd FileType xml UltiSnipsAddFiletypes xml
"autocmd FileType python UltiSnipsAddFiletypes python
"autocmd FileType go UltiSnipsAddFiletypes go
"autocmd FileType ruby UltiSnipsAddFiletypes ruby

" work required post install to make auto file detection work
" mkdir -p ~/.vim/after/plugin
" ln -s ~/.vim/bundle/UltiSnips/after/plugin/UltiSnips_after.vim  ~/.vim/after/plugin
" mkdir ~/.vim/ftdetect
" ln -s ~/.vim/bundle/ultisnips/ftdetect/ ~/.vim/ftdetect
" ========== Ultisnips ==========



" ========== todo ==========
" add TODO at top of your file and ,td will search it
Bundle 'vim-scripts/TaskList.vim'
map <leader>td <Plug>TaskList
" ========== todo ==========

" ========== matchit ==========
Bundle 'tpope/vim-unimpaired'
Bundle 'voithos/vim-python-matchit'
" ]%  - go to end of block
" [%  - go to beginning of blck
" v]% - start selecting block in visual
" V]% - select whole block in visual
" d]% - select whole block in visual
Bundle 'benjifisher/matchit.zip'
" ========== matchit ==========

" ========== ctrlp ==========
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
" ========== ctrlp ==========

" ========== sessionman ==========
Bundle 'vim-scripts/sessionman.vim'
map <Leader>so :SessionOpen
map <Leader>ss :SessionSave<CR>
map <Leader>ssa :SessionSaveAs
" ========== sessionman ==========

" ========== indent ==========
Bundle 'hynek/vim-python-pep8-indent'

Bundle 'nathanaelkane/vim-indent-guides'

let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_guide_size=1

Bundle 'pangloss/vim-javascript'
let g:javascript_enable_domhtmlcss=1
" ========== indent ==========

" ========== delimitMate ==========
" This plug-in provides automatic closing of quotes, parenthesis, brackets, etc.,
Bundle 'Raimondi/delimitMate'
" ========== delimitMate ==========

" ========== MatchTagAlways ==========
" The MatchTagAlways.vim (MTA) plug-in for the Vim text editor always highlights the XML/HTML tags that enclose your cursor location.
Bundle 'valloric/MatchTagAlways'
" ========== MatchTagAlways ==========

" ========== jQuery ==========
Bundle 'vim-scripts/jQuery'
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
set shortmess=a
set smarttab
set cindent
set copyindent
set smartindent
" ========== jQuery ==========


" ========== vim-substitute ==========
"The substitute.vim script provides shortcuts for replacing the text under the cursor
";;  Run |:substitute| on the current buffer without prompting.
";'  The same, only prompt for each.
"';  Perform substitution on the lines that match a *multi-repeat*
"    expression, prompting for each.
Bundle 'aklt/vim-substitute'
let g:substitute_SingleWordSize = -1
" ========== vim-substitute ==========

" ========== jedi-vim ==========
Bundle 'davidhalter/jedi-vim'
set completeopt=menu
"Completion - tab
"Goto assignments <leader>g
"Goto definitions <leader>d
"Show Documentation/Pydoc K (shows a popup with assignments)
"Renaming <leader>r
"Usages <leader>n (shows all the usages of a name)
"Open module, e.g. :Pyimport os (opens the os module)<Paste>

"au FileType python let g:jedi#popup_select_first = 0
"au FileType python let g:jedi#popup_on_dot = 1
"au FileType python let g:jedi#auto_initialization = 1
"au FileType python let g:jedi#auto_vim_configuration = 0
"au FileType python let g:jedi#use_tabs_not_buffers = 0
"au FileType python let g:jedi#completions_enabled = 0
"au FileType python let g:jedi#goto_assignments_command = "<leader>g"
"au FileType python let g:jedi#goto_definitions_command = "<leader>d"
"au FileType python let g:jedi#documentation_command = "K"
"au FileType python let g:jedi#usages_command = "<leader>n"
"au FileType python let g:jedi#completions_command = "<s-tab>"
"au FileType python let g:jedi#rename_command = "<leader>r"
"au FileType python let g:jedi#show_call_signatures = 1
"
au FileType python setlocal completeopt-=preview
set omnifunc=jedi#completions
:inoremap <expr> j pumvisible() ? '<C-n>' : 'j'
:inoremap <expr> k pumvisible() ? '<C-p>' : 'k'

" ========== jedi-vim ==========



" ======================== following config after neovim installed =================="

" ========== obsolete syntastic ==========
" Not using syntastic in favor of neomake
"Bundle "vim-syntastic/syntastic"

"let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
"let g:go_term_enabled = 1

" Disable inherited syntastic
"let g:syntastic_mode_map = {
"  \ "mode": "passive",
"  \ "active_filetypes": [],
"  \ "passive_filetypes": [] }
" ========== obsolete syntastic ==========

" ========== neomake ==========
" to run linters
Bundle "neomake/neomake"

" Run NeoMake on read and write operations
autocmd! BufReadPost,BufWritePost * Neomake

let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1

" (Optional)Remove Info(Preview) window
set completeopt-=preview

" (Optional)Hide Info(Preview) window after completions
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" increase verbosity for debugging
"let g:neomake_verbose=3
"let g:neomake_logfile='/var/tmp/neomake.log'

" pylint options are better set in ~/.pylintrc
let g:neomake_python_enabled_makers = ['pylint']
let g:neomake_json_enabled_makers = ['jsonlint']
" ========== neomake ==========

" ========== deoplete ==========
" autocompletion
Bundle "Shougo/deoplete.nvim"
let g:loaded_python_provider = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#enable_debug=1
" ========== deoplete ==========

" ========== vundle ==========
call vundle#end()
filetype plugin indent on
" ========== vundle ==========

" ========== 80col ==========
autocmd FileType python set colorcolumn=80
autocmd FileType ruby set colorcolumn=80
autocmd FileType python set sw=2 ts=2
highlight ColorColumn ctermbg=red guibg=orange
autocmd Syntax * syn match Error /\s\+$\| \+\ze\t/ containedin=ALL display
" markdown
autocmd FileType markdown set colorcolumn=80
autocmd BufNewFile,BufRead *.md,*.mkd,*.markdown set spell spelllang=en_us
" ========== 80col ==========


" ========== geeknote ==========
" pre-req: install geeknote from -  https://github.com/jeffkowalski/geeknote
Bundle 'neilagabriel/vim-geeknote'
let g:GeeknoteFormat="markdown"
let g:GeeknoteNeovimMode="True"
" ========== geeknote ==========

" ========== terraform ==========

au BufRead,BufNewFile *.tfvars set filetype=terraform
au BufRead,BufNewFile *.tf set filetype=terraform

"Bundle "fatih/vim-hclfmt"

Bundle 'hashivim/vim-terraform'
let g:terraform_align=1

autocmd FileType terraform setlocal commentstring=//%s

" Download juliosueiras/vim-terraform-completion and dump it in ~/.vim/bundle/vim-snippets/UltiSnips/tf.snippets
" because this expects *.tf files to be of type terraform and is in conflict
" with vim-hclfmt which expects them to be of type hcl
Bundle "juliosueiras/vim-terraform-completion"

let g:terraform_fmt_on_save = 1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1 
let g:terraform_registry_module_completion = 0
:autocmd BufWritePost *.tf :TerraformFmt

" Update deoplete add in init.vim
" let g:deoplete#omni_patterns = {}
" let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'
" let g:deoplete#enable_at_startup = 1
" call deoplete#initialize()
"
" comment the following code chunk in ~/.vim/bundle/vim-terraform-completion/autoload/terraformcomplete.vim
" to prevent module source lookups which are useless
"if getline(".") =~ '\s*source\s*=\s*"'
"	for m in terraformcomplete#GetAllRegistryModules()
"		if m.word =~ '^' . a:base
"			call add(a:res, m)
"		endif
"	endfor
"	return a:res
"endif

" Add browser opening functionality by following
" https://superuser.com/questions/911735/how-do-i-use-xdg-open-from-xdg-utils-on-mac-osx
" to install xdg-open on Mac

" ========== terraform ==========

" ========== Misc ==========

" escape the tyranny of escape
imap jk 

" save on the fly
noremap <Leader>s :update<CR>

" Jingle no bells
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" tabbing through panes
map <C-J> :bprev<CR>
map <C-K> :bnext<CR>
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

" indentation code folding - enable below 2 lines if you want indentation to code fold
set foldmethod=manual " set to indent to make auto folding enabled
set foldlevel=0 

" uncomment to remember folds on save
"augroup remember_folds
"  autocmd!
"  autocmd BufWinLeave *.* mkview
"  autocmd BufWinEnter *.* loadview
"augroup END

" folding commands
" zf#j creates a fold from the cursor down # lines.
" zf/string creates a fold from the cursor to string.
" zj moves the cursor to the next fold.
" zk moves the cursor to the previous fold.
" zo opens a fold at the cursor.
" zO opens all folds at the cursor.
" zm increases the foldlevel by one.
" zM closes all open folds.
" zr decreases the foldlevel by one.
" zR decreases the foldlevel to zero -- all folds will be open.
" zd deletes the fold at the cursor.
" zE deletes all folds.
" [z move to start of open fold.
" ]z move to end of open fold.
" move around windows
"map <c-j> <c-w>j
"map <c-k> <c-w>k
"map <c-l> <c-w>l
"map <c-h> <c-w>h

" don't outdent hashes
inoremap # #

set tags=~/mytags
map <leader>t :silent! !ctags -R -o ~/mytags .<CR>

Bundle 'gmarik/Vundle.vim'
Bundle 'bronson/vim-trailing-whitespace'

" edit crontab on mac
autocmd filetype crontab setlocal nobackup nowritebackup

" to make copy-paste work in mac - this is simply awesome
set clipboard=unnamed
" ========== Misc ==========

""""" Tips """""""
" :g/pattern/d - delete all lines matching pattern
" :3,12g/pattern/d - delete all lines matching pattern from 3 to 12
" :.,$g/pattern/d - delete all lines matching pattern from current to end
" use gd to go to function definition if the function defined in the same file
" links to help out with mass edits
" http://stackoverflow.com/questions/2024443/saving-vim-macros
" http://www.nyayapati.com/srao/2013/08/run-a-macro-in-all-buffers-in-vim/
" source /var/tmp/buffers.vim
" shift+zz to save and quit
