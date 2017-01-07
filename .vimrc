set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
call vundle#end()

Plugin 'align'
Plugin 'snipMate'
Plugin 'AutoComplPop'
Plugin 'Syntastic'
Plugin 'fugitive.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'The-NERD-tree'
Plugin 'ctrlp.vim'
Plugin 'commentary.vim'
Plugin 'flazz/vim-colorschemes'

filetype indent plugin on
syntax on
set hidden
set wildmenu
set showcmd
set hlsearch
set backspace=indent,eol,start
set autoindent
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell                         " don't beep
set noerrorbells                       " don't beep
set t_vb=
set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200
set shiftwidth=2
set softtabstop=2
set expandtab
set t_Co=256
set encoding=utf-8
set incsearch                          " show search matches as you type
set pastetoggle=<F2>                   " toggle paste-mode with F2
silent! colorscheme molokai            " default colorscheme (wombat/molokai)


"=============Syntastic===============
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1


"=============Airline Settings===============
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline#extensions#syntastic#enabled = 1    " Enable syntastic plugin


"=============Show mouse-state in airline statusbar===============
function! GetMouseMode()
  return "MOUSE"
endfunction
call airline#parts#define_function('mouse', 'GetMouseMode')
call airline#parts#define_condition('mouse', '&mouse == "a"')
call airline#parts#define_accent('mouse', 'bold')
let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'paste', 'mouse', 'spell', 'iminsert'])


"=============Commentary change PHP comment from /**/ to //===============
autocmd FileType php setlocal commentstring=//\ %s


"=============NerdTree Settings===============
let NERDTreeIgnore=['.swp$'] " ignore .swp files
let NERDTreeShowHidden=1
let NERDTreeWinPos="right"
let NERDTreeMinimalUI=1


"=============Toggle Mouse Function===============
fun! s:ToggleMouse()
  if !exists("s:old_mouse")
    let s:old_mouse = "a"
  endif

  if &mouse == ""
    let &mouse = s:old_mouse
  else
    let s:old_mouse = &mouse
    let &mouse=""
  endif
endfunction


"=============Key Mapping===============
nnoremap <C-L> :nohl<CR><C-L>                   " reset search highlight
nnoremap <Tab> <C-W><C-W>
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <F12> :call <SID>ToggleMouse()<CR>

