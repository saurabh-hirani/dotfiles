" README!!
"
" Installing plugins
"   - git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"   - vim +BundleInstall

set nocompatible               " be iMproved
filetype off                   " required!

" ========== Use vundle ==========
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~~/.fzf
set title
call vundle#begin()
let mapleader=","
inoremap <leader>x <C-x><C-o>
" ========== Use vundle ==========

" Reload vim
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Reload file when changed on disk
set autoread | au CursorHold * checktime | call feedkeys("lh")


" ========== Global config ==========
filetype on
filetype indent on
filetype plugin on
set nu
set ts=2 et sw=2 sts=2
set noswapfile
syntax enable
" to use with tmux -2 - so as to enable wombat
set t_ut=
autocmd GUIEnter * set vb t_vb=
autocmd BufEnter * syntax sync fromstart
abb xybtk `
" ========== Global config ==========

" Prevent auto indenting for yaml comments
autocmd FileType yaml,yaml.ansible setlocal indentkeys-=0#

" ========== vim-commentary ==========
" Use gcc to comment out a line (takes a count)
" gc to comment out the target of a motion (for example, gcap to comment out a paragraph)
" gc in visual mode to comment out the selection
" gc in operator pending mode to target a comment.
" You can also use it as a command, either with a range like :7,17Commentary, or as part of a :global invocation like with :g/TODO/Commentary.
Bundle 'tpope/vim-commentary'
autocmd FileType apache setlocal commentstring=#\ %s
autocmd FileType text setlocal commentstring=#\ %s
" ========== vim-commentary ==========

" ========== vim-repeat ==========
" examples - https://catonmat.net/vim-plugins-repeat-vim
Bundle 'tpope/vim-repeat'
" ========== vim-repeat ==========

" ========== vim-surround ==========
" examples - https://catonmat.net/vim-plugins-surround-vim
" ds  - delete a surrounding - e.g ds"
" cs  - change a surrounding - e.g. cs"'
" ys  - add a surrounding - e.g ys"
" yss - add a surrounding to the whole line e.g yss"
Bundle 'tpope/vim-surround'
" ds" to remove quote
map <leader>" ysW"
map <leader>X ysW`
" ========== vim-surround ==========


" ========== Filetypes ==========
au BufRead,BufNewFile *.json set filetype=json
au BufRead,BufNewFile *.template set filetype=json
" ========== Filetypes ==========

" ========== Colorschemes ==========
Bundle 'jnurmine/Zenburn'
Bundle 'vim-scripts/Wombat'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-fugitive'
Bundle 'airblade/vim-gitgutter'
" Run - cp /home/saurabh/.vim/bundle/nord-vim/colors/nord.vim ~/.config/nvim/colors
Bundle 'arcticicestudio/nord-vim'
Bundle 'tomasiser/vim-code-dark'

let g:rehash256 = 1
let g:loaded_python_provider = 1
set laststatus=2

augroup nord-overrides
  autocmd!
  autocmd ColorScheme nord highlight Folded cterm=italic,bold ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#81A1C1
  autocmd ColorScheme nord highlight Comment ctermfg=12 guifg=#81A1C1
  autocmd ColorScheme nord highlight Search ctermbg=3 ctermfg=0 guibg=#EBCB8B guifg=#3B4252
  autocmd ColorScheme nord highlight IncSearch ctermbg=8 guibg=#4C566A
  autocmd ColorScheme nord highlight Visual ctermbg=8
augroup END

if !has('gui_running')
  "set term=xterm-256color
endif
set t_Co=256
set updatetime=2000

if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif
colorscheme nord
" ========== Colorschemes ==========


" ========== gitgutter ==========
" later - check https://github.com/mhinz/vim-signify in case of perf issues
" examples - https://www.youtube.com/watch?v=SLQWQ_R4bRI&ab_channel=BrodieRobertson
nnoremap <space>ggd :GitGutterDisable<CR>
nnoremap <space>gge :GitGutterEnable<CR>
nnoremap <space>ggt :GitGutterLineHighlightsToggle<CR>
nnoremap <space>ggl :GitGutterLineNrHighlightsToggle<CR>
nnoremap <space>ggf :GitGutterFold<CR>

highlight GitGutterAdd guifg=#009900 ctermfg=Green
highlight GitGutterChange guifg=#bbbb00 ctermfg=Yellow
highlight GitGutterDelete guifg=#ff2222 ctermfg=Red

let g:gitgutter_enabled = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_highlight_lines = 0
let g:gitgutter_highlight_linenrs = 1

nmap ) <Plug>(GitGutterNextHunk)
nmap ( <Plug>(GitGutterPrevHunk)

" ========== gitgutter ==========

" ========== fugitive ==========
nnoremap <space>gd :Git diff<CR>
nnoremap <space>gb :Git blame<CR>
nnoremap <space>gs :Git status<CR>
nnoremap <space>gl :Git log<CR>
nnoremap <space>guno :Git status -uno .<CR>
nnoremap <space>go :Git checkout<Space>
nnoremap <space>ga :Git add %:p<CR><CR>
nnoremap <space>gcc :Git commit -v -q<CR>
nnoremap <space>gco :Git read<CR>
nnoremap <space>gl :silent! Git log<CR>:bot copen<CR>
nnoremap <space>gps :Git push<CR>
"nnoremap <space>gps :Dispatch! git push<CR>
" ========== fugitive ==========
"

" ========== python ==========
let g:python3_host_prog='/opt/homebrew/opt/python/libexec/bin/python'

python3 << EOF
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

" ========== airline ==========
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline_theme='nord'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#ignore_bufadd_pat = '!|defx|gundo|nerd_tree|startify|tagbar|term://|undotree|vimfiler'
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
" ========== airline ==========

" ========== ruby ==========
Bundle 'vim-ruby/vim-ruby'
let g:loaded_ruby_provider = 1
" ========== ruby ==========

" ========== golang ==========
au BufRead,BufNewFile *.go set filetype=go

Plugin 'fatih/vim-go'
Bundle 'fatih/molokai'

au FileType go nmap <leader>r <Plug>(go-run)
"au FileType go nmap <leader>b <Plug>(go-build)
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
map <leader>O :NERDTreeFind<CR>
map <leader>r :NERDTreeFind<cr>
" when done with vpslit work keep focus in window other than the one you want to quite and do - ctrl + w
" + o
nmap vv :vsplit<CR>
let NERDTreeShowHidden=1
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
" Uncomment the following to use todo.txt
" Bundle 'dbeniamine/todo.txt-vim'
" au BufRead,BufNewFile todo.txt set filetype=todo
" au filetype todo setlocal omnifunc=todo#Complete
" au filetype todo imap <buffer> + +<C-X><C-O>
" au filetype todo imap <buffer> @ @<C-X><C-O>
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
set nosmartindent
set cinkeys-=0#
set indentkeys-=0#
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


" ======================== following config after neovim installed =================="

" ========== neomake ==========
" to run linters
"Bundle "neomake/neomake"
"
"" Run NeoMake on read and write operations
"autocmd! BufReadPost,BufWritePost * Neomake
"
"let g:neomake_serialize = 1
"let g:neomake_serialize_abort_on_error = 1
"
"" (Optional)Remove Info(Preview) window
"set completeopt-=preview
"
"" (Optional)Hide Info(Preview) window after completions
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"
"" increase verbosity for debugging
"" let g:neomake_verbose=3
"" let g:neomake_logfile='/var/tmp/neomake.log'
"
"" pylint options are better set in ~/.pylintrc
"let g:neomake_python_enabled_makers = ['flake8', 'pylint']
"let g:neomake_json_enabled_makers = ['jsonlint']
" ========== neomake ==========

" ========== coc ==========
" Install diagnostic extension - :CocInstall coc-diagnostic
Bundle "neoclide/coc.nvim"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <Leader>d :CocDiagnostics<CR>

let g:coc_filetype_map = {
      \ 'py': 'python'
\ }

aug python
  au!
  au BufWrite *.py call CocAction('format')
aug END
" ========== coc ==========

" ========== coc-pyright ==========
" Run CoCInstall coc-pyright and CocInstall coc-json first
Bundle 'fisadev/vim-isort'

" ========== coc-pyright ==========

" ========== vundle ==========

" ========== 80col ==========
autocmd FileType python set colorcolumn=119
autocmd FileType ruby set colorcolumn=80
autocmd FileType text set colorcolumn=80
autocmd FileType python set sw=4 ts=4
highlight ColorColumn ctermbg=red guibg=orange
autocmd Syntax * syn match Error /\s\+$\| \+\ze\t/ containedin=ALL display
" markdown
autocmd FileType markdown set colorcolumn=80
autocmd BufNewFile,BufRead *.md,*.mkd,*.markdown set spell spelllang=en_us
" ========== 80col ==========

" ========== terraform ==========
Bundle 'hashivim/vim-terraform'
au BufRead,BufNewFile *.tfvars set filetype=terraform
au BufRead,BufNewFile *.tf set filetype=terraform
au BufRead,BufNewFile *.hcl set filetype=terraform
let g:terraform_align=1
let g:terraform_fmt_on_save = 0
" let g:terraform_fmt_on_save = 1
" autocmd BufWritePre *.hcl :normal gg=G``<CR>
" autocmd BufWritePre *.hcl.tpl :normal gg=G``<CR>
" autocmd FileType terraform setlocal commentstring=//%s

" ========== terraform ==========

" ========== Misc ==========

" escape the tyranny of escape
imap jj <Esc>
imap kk <Esc>O
"nmap tt :tabnew<CR>

" save on the fly
" :nmap <c-s> :w<CR>
" :imap <c-s> <Esc>:w<CR>a
noremap <C-s> :update<CR>

" Jingle no bells
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" tabbing through buffers
map <C-J> :bprev<CR>
map <C-K> :bnext<CR>
map <Leader>, :e#<CR>
nnoremap <Leader>1 :b1<CR>
nnoremap <Leader>2 :b2<CR>
nnoremap <Leader>3 :b3<CR>
nnoremap <Leader>4 :b4<CR>
nnoremap <Leader>5 :b5<CR>
nnoremap <Leader>6 :b6<CR>
nnoremap <Leader>7 :b7<CR>
nnoremap <Leader>8 :b8<CR>
nnoremap <Leader>9 :b9<CR>
nnoremap <Leader>e :enew<CR>
nnoremap <C-J> :call MyPrev()<CR>
nnoremap <C-K> :call MyNext()<CR>

" MyNext() and MyPrev(): Movement between tabs OR buffers
function! MyNext()
    if exists( '*tabpagenr' ) && tabpagenr('$') != 1
        " Tab support && tabs open
        normal gt
    else
        " No tab support, or no tabs open
        execute ":bnext"
    endif
endfunction

function! MyPrev()
    if exists( '*tabpagenr' ) && tabpagenr('$') != '1'
        " Tab support && tabs open
        normal gT
    else
        " No tab support, or no tabs open
        execute ":bprev"
    endif
endfunction

" close the buffer
map <Leader>q :bd<CR>
set hidden " allow hidden buffers

" Searching through buffers
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>l :Lines<CR>
nnoremap <Leader>' :Marks<CR>
nmap <Leader>/ :Ag<Space>

" indentation code folding - enable below 2 lines if you want indentation to code fold
set foldmethod=manual " set to indent to make auto folding enabled
set foldlevel=0

" augroup remember_folds
"   autocmd!
"   autocmd BufWinLeave *.* mkview
"   autocmd BufWinEnter *.* loadview
" augroup END

" folding commands
" zf#j creates a fold from the cursor down # lines.
" zf/string creates a fold from the cursor to string.
" zj moves the cursor to the next fold.
" zk moves the cursor to the previous fold.
" zo opens a fold at the cursor.
" zO opens all folds at the cursor.
" zm increases the foldlevel by one.
" zr decreases the foldlevel by one.
" zM closes all open folds.
" zR decreases the foldlevel to zero -- all folds will be open.
" zd deletes the fold at the cursor.
" zE deletes all folds.
" [z move to start of open fold.
" ]z move to end of open fold.
inoremap # #

set tags=~/mytags
map <leader>t :silent! !ctags -R -o ~/mytags .<CR>

Bundle 'gmarik/Vundle.vim'
Bundle 'bronson/vim-trailing-whitespace'
Bundle 'junegunn/fzf'
Bundle 'junegunn/fzf.vim'
Bundle 'wincent/command-t'
"let g:fzf_layout = { 'down': '20' }
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8, 'yoffset':5, 'xoffset': 5, 'relative': v:true, 'highlight': 'TODO'} }


let g:CommandTPreferredImplementation='lua'

set clipboard=unnamed
" let g:clipboard = {
"   \   'name': 'xclip-xfce4-clipman',
"   \   'copy': {
"   \      '+': 'xclip -selection clipboard',
"   \      '*': 'xclip -selection clipboard',
"   \    },
"   \   'paste': {
"   \      '+': 'xclip -selection clipboard -o',
"   \      '*': 'xclip -selection clipboard -o',
"   \   },
"   \   'cache_enabled': 1,
"   \ }

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" ========== Misc ==========

" Search in all currently opened buffers
function! ClearQuickfixList()
  call setqflist([])
endfunction
function! Vimgrepall(pattern)
  call ClearQuickfixList()
  exe 'bufdo vimgrepadd ' . a:pattern . ' %'
  cnext
endfunction
command! -nargs=1 Vim call Vimgrepall(<f-args>)

"========= fzf ===========
" current file's dir files

nnoremap <space>fc :Files %:p:h<CR>
nnoremap <space>ff :AllFiles %:p:h<CR>
nnoremap <space>fh :HomeFiles<CR>
nnoremap <space>fr :RepoFiles<CR>

command! -bang -nargs=? -complete=dir AllFiles call fzf#vim#files('/', fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang -nargs=? -complete=dir HomeFiles call fzf#vim#files('/Users/saurabhhirani/', fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang -nargs=? -complete=dir RepoFiles call fzf#vim#files('/Users/saurabhhirani/github/', fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

source ~/.vimrc.work

command! -bang -nargs=* Ag call fzf#vim#grep('ag --column --numbers --noheading --color --smart-case '.shellescape(<q-args>), 1,  fzf#vim#with_preview('right:60%'), <bang>0)

map <Leader>g :Ag<Space>
"======== fzf ===========

"========== ack =============
Bundle 'mileszs/ack.vim'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev Ack Ack!
nnoremap <Leader>c :Ack!<Space>
let g:ackpreview = 0
let g:ack_apply_lmappings = 0
let g:ack_apply_qmappings = 0
"========== ack =============

Bundle "yegappan/mru"
Bundle "tpope/vim-obsession"
Bundle 'iamcco/markdown-preview.nvim'


" ========== vundle ==========
call vundle#end()
syntax on

" ========== Tips ==========
"
" links to help out with mass edits
" http://stackoverflow.com/questions/2024443/saving-vim-macros
" http://www.nyayapati.com/srao/2013/08/run-a-macro-in-all-buffers-in-vim/
" source /var/tmp/buffers.vim
"
" :g/pattern/d - delete all lines matching pattern
" :3,12g/pattern/d - delete all lines matching pattern from 3 to 12
" :.,$g/pattern/d - delete all lines matching pattern from current to end
" gd  - go to function definition if the function defined in the same file
" shift+zz - save and quit
" esc + q/p - to search for yanked text
" let @+=@% - copy current file path into buffer
" ctrl + o - navigate to previous
" ctrl + i - navigate to previous
" g; - go to the previous change location
" g, - go to the newer change location
" gi - place the cursor at the same position where it was left last time in the Insert mode
" zg - add word to dictionary
" z= - check work spelling
" ========== Tips ==========
"
