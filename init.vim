if(!filereadable(expand("~/.local/share/nvim/site/autoload/plug.vim")))
	echo 'plug.vim not found, trying to install...'
	call system(expand("curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"))
	PlugInstall
endif

"-- General --
set relativenumber " Relative line numeration
set number		"Show line numbers
set ruler		"Show the line and column number of the cursor position
set mouse=a
set nocompatible

" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim

call plug#begin()
" colorscheme, syntax highlighting
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'rust-lang/rust.vim'

" git helpers
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" utils
Plug 'vim-airline/vim-airline'
Plug 'neomake/neomake'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jiangmiao/auto-pairs'
Plug 'timonv/vim-cargo'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'Chiel92/vim-autoformat'
Plug 'ryanoasis/vim-devicons'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }

" CSS plugins
Plug 'JulesWang/css.vim'
Plug 'ap/vim-css-color'

call plug#end()

call deoplete#enable()
" omnifuncs
augroup omnifuncs
	autocmd!
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end
" tern
if exists('g:plugs["tern_for_vim"]')
	let g:tern_show_argument_hints = 'on_hold'
	let g:tern_show_signature_in_pum = 1
	autocmd FileType javascript setlocal omnifunc=tern#Complete
endif

" Hotkeys
map <Enter> o<ESC>
map <S-Enter> O<ESC>
map <F9> :YcmCompleter FixIt<CR>

if has('nvim')
	" Neovim true color
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

	set termguicolors
	set background=dark
	colorscheme solarized
endif

"-- Programming --
set autoindent		"Copy indent from current line when starting a new line
syntax on
" Remember cursor position between vim sessions
autocmd BufReadPost *
	\ if line("'\"") > 0 && line ("'\"") <= line("$") |
	\   exe "normal! g'\"" |
	\ endif
	" center buffer around cursor when opening files
autocmd BufRead * normal zz

"-- Spaces/Tabs --
set noexpandtab		"Strictly use tabs when tab is pressed (this is the default)
set shiftwidth=4
set tabstop=4

"-- Searching --
set hlsearch		"Highlight search results
set ignorecase		"When doing a search, ignore the case of letters
set smartcase		"Override the ignorecase option if the search pattern contains upper case letters
" clear the search highlight by pressing ESC when in Normal mode (Typing commands)
map <esc> :noh<cr>
noremap j gj
noremap k gk

"-- Tabbed Editing --
"Open a new (empty) tab by pressing CTRL-T. Prompts for name of file to edit
map <C-T> :tabnew<CR>:edit 
"Open a file in a new tab by pressing CTRL-O. Prompts for name of file to edit
map <C-O> :tabfind 
"Switch between tabs by pressing Shift-Tab
map <S-Tab> gt

"-- Tweaks --
set wildmenu
"Add tweak for better backspace support
set backspace=indent,eol,start
" clipboard
set clipboard=unnamed
set undofile
set undodir="$HOME/.VIM_UNDO_FILES"
" use powerline fonts
let g:airline_powerline_fonts=1
" Youcompleteme fix (kinda)
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"autopen NERDTree and focus cursor in new document
" autocmd VimEnter * NERDTree
" autocmd VimEnter * wincmd p
map <C-\> :NERDTreeToggle<CR>:wincmd p<CR>
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" NERDTree minimal UI
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Gist
if has('mac')
	let g:gist_clip_command = 'pbcopy'
elseif has('linux')
	let g:gist_clip_command = 'xclip -selection clipboard'
endif
let g:gist_detect_filetype = 1
let g:gist_post_private = 1

" autorun neomake on the current file write
autocmd! BufWritePost * Neomake

set tabstop=4
set noexpandtab

set cursorline

" Folding
set foldmethod=indent
set foldlevel=1
set foldclose=all

" Save current session
fu! SaveSess()
    execute '!bash -c "mkdir -p ~/.vim"'
    execute 'mksession! ~/.vim/session.vim'
endfunction

" Restore current session
fu! RestoreSess()
	execute 'so ~/.vim/session.vim'
	if bufexists(1)
		for l in range(1, bufnr('$'))
			if bufwinnr(l) == -1
				exec 'sbuffer ' . l
			endif
		endfor
	endif
endfunction

" Autosave session when open/exit
" autocmd VimLeave * call SaveSess()
" autocmd VimEnter * call RestoreSess()
