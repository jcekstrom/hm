" Ward off unexpected things that your distro might have made, as
" well as sanely reset options when re-sourcing .vimrc
set nocompatible

" lua require('init')

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
if has('filetype')
  filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
  syntax on
endif

" Uncomment if you want to install not-installed plugins on startup.
"if dein#check_install()
" call dein#install()
"endif

" Map keys
" map <A-f> :NERDTreeToggle<CR>

" Turn on Line numbers
set nu

" Colors
colorscheme molokai

