" This vimrc is based on https://github.com/chrisdean258/Dotfiles

" CONFIG SETTINGS {{{
" _________________________________________________________________________

    :syntax on                    " Syntax highlighting
    :set nowrap                   " Dont wrap text to newlines
    :set number                   " Show line numbers
    :set relativenumber           " Show line numbers relative to current line
    :colorscheme elflord

    :set scrolloff=5              " Keep cursor 5 lines in
    :set sidescroll=1             " Move on char at a time off the screen instead of jumping
    :set sidescrolloff=5          " Keep the cursor 5 chars from the left side of the screen
    :set softtabstop=-1           " Keep defaults to shitwidth
    :set shiftwidth=0             " Defaults to tabstop

    :set ttyfast                  " Fast scrolling
    :set nocompatible             " vim != vi
    :set autoindent          
    :set smartindent         
    :set showcmd                  " Show partial command before you finish typing
    :set wildmenu                 " Show menu completion on command line
    :set incsearch hlsearch       " Turn on search highlighting
    :filetype plugin indent on    " Indenting by filetype
    :set path+=**                 " Cheap fuzzy find

    :if &filetype !~ "vim"
    :   setlocal nofoldenable     " Turn off foldign except in files
    :endif
    :setlocal foldtext=MyFold()   " Show foldtext based on my function

    :set splitright               " Split to the right
    :set splitbelow               " Split to below

    :set tag=./tags,./Tags,tags   " Add a bunch of tag files that can be looked at
    :set tags+=./tags;$HOME
    :set tags+=./.tags;$HOME

    " Ignore standard ingnored files
    :set wildignore=*.o,*~,*.pyc
    :set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

    :set infercase                " Infer case for insert completion
    :set autoread                 " Reads from disk if no modifications in buffer
    :set switchbuf=usetab         " Default to jumping to a new tab
    :set hidden                   " Hide buffers instead of closing
    :set tabpagemax=1000          
    :set pumheight=15             " Limit completion options to 15
    :set shortmess+=atI           " See h: shm or h: shortmess

    " All encoding will be utf-8
    :set encoding=utf-8
    :set fenc=utf-8
    :set tenc=utf-8

    " See cinoptions-values for option explanations
    :set cinoptions=(4,N-s,l1,t0,c2
    :if getcwd() == expand("~")   " Turn off included file completion for home dir items
    :   set complete-=it
    :endif
    :set matchpairs+=<:>          " Add a matched pair for highlighting and wrapping
    :set ttyfast

    " Create backup and undo dirs if they don't exists
    :if !isdirectory($HOME . "/.vim/backup")
    :   call mkdir($HOME . "/.vim/backup", "p")
    :endif

    :if !isdirectory($HOME . "/.vim/undo")
    :   call mkdir($HOME . "/.vim/undo", "p")
    :endif

    " Set backup and undo dirs
    :set backupdir=~/.vim/backup//
    :set undodir=~/.vim/undo//

    " Undo Configuration
    :set undofile
    :set undolevels=1000
    :set undoreload=10000
    :set backup
    :set wildmode=longest,list,full
    :set smartcase

" }}}

" HIGHLIGHT SETTINGS {{{
" _________________________________________________________________________

    :function! HighlightSettings()
    " Setting for using hl after function
    :highlight LongLine guifg=Red ctermfg=Red
    :highlight Folded None 
    :highlight Folded guifg=Black ctermfg=Black
    
    " Settings for tabline
    :highlight tablinefill None
    :highlight tablinesel None
    :highlight tabline None
    :highlight tablinesel guifg=DarkGrey ctermfg=DarkGrey
    :highlight tabline guifg=black ctermfg=black

    " Settings for spelling
    :highlight spellrare None
    :highlight spellcap None
    :highlight spelllocal None
    :if get(g:, "light_folds", 1)
    :   highlight Folded guifg=DarkGrey ctermfg=DarkGrey
    :   highlight tabline guifg=DarkGrey ctermfg=DarkGrey
    :   highlight tablinesel guifg=Grey ctermfg=Grey
    :endif
    :endfunction
    :call HighlightSettings()

" }}}

" PLUGIN MANAGEMENT CONFIGURATION {{{
" _________________________________________________________________________

    " Create package dir for plugins for native (Requires Vim 8+)
    :if v:version >= 800
    :   if !isdirectory($HOME . "/.vim/pack")
    :       call mkdir($HOME . "/.vim/pack", "p")
    :   endif
    " If Vim is < ver. 8, make sure vim-plug is installed and add plugins via the plugin manager 
    " Using vim-plug only for compatibility with older versions of Vim
    :else
        " Check that vim-plug is installed and install if it is not
    :   if !exists("plugin#begin")
    :       silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    :   endif

    :   call plug#begin()
        " Using local, unmanaged plugins via git submodules
    :   Plug '~/.vim/pack/syntastic/start/syntastic'
    :   Plug '~/.vim/pack/vim-airline/start/vim-airline'
        " Use :PlugInstall to install plugins with vim-plug 
    :   call plug#end()
    :endif

" }}}


" PLUGIN CONFIGURATION {{{
" _________________________________________________________________________

    :if v:version >= 800
        " Ale Configuration
        :let g:ale_linters = {
        \    'python': ['bandit', 'flake8'],
        \} 

        " Ale Error Message Config
        :let g:ale_echo_msg_error_str = 'E'
        :let g:ale_echo_msg_warning_str = 'W'
        :let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

        " Airline Enable
        :let g:airline#extensions#ale#enabled = 1

    " If Vim is < ver. 8
    :else
        " Syntatstic Configuration
        :set statusline+=%#warningmsg#
        :set statusline+=%{SyntatsticStatuslineFlag()}
        :set statusline+=%*

        :let g:syntastic_always_populate_loc_list = 1
        :let g:syntastic_loc_list_height = 5
        :let g:syntastic_auto_loc_list = 0
        :let g:syntastic_check_on_open = 0
        :let g:syntastic_check_on_wq = 0

        :highlight link SyntasticErrorSign SignColumn
        :highlight link SyntasticWarningSign SignColumn
        :highlight link SyntasticStyleErrorSign SignColumn
        :highlight link SyntasticStyleWarningSign SignColumn

        :command Sc :SyntasticCheck

        " Python Linting
        :let g:syntastic_python_checkers=["bandit", "flake8"]

        " C/C++ Linting
        :let g:syntastic_cpp_compiler = "g++"
        :let g:syntastic_cpp_include_dirs = ["../../include", "../include", "include", ".", $HOME."/include"]

        :let g:airline#extensions#syntastic#enabled = 1        
    :endif

    " Airline Configuration
    :let g:airline_theme='luna'
    :let g:airline_powerline_fonts = 1
    :let g:airline#extensions#fugitive#enabled = 1        
    :let g:airline#extensions#tabline#enabled = 1        
    :let g:airline#extensions#tabline#formatter = 'unique_tail_improved'    

" }}}

" UNIVERSAL MAPPINGS {{{
" _________________________________________________________________________
    
    " Mapleader settings
    :let mapleader = ' '
    :let maplocalleader = '\'

    " Move up and down visually instead of by line
    :nnoremap j gj
    :nnoremap k gk

    " Use jk instead of escape
    :inoremap jk <esc>`^
    :imap Jk jk
    :imap JK jk
    :noremap <space> <nop>
    :imap <C-z> jk<C-z>i

    " Insert a single char
    " Use s<F12> mapping to prevent eval of macro until another char is input
    :nnoremap <silent><expr>s SingleInsert("i")
    :nnoremap <silent><expr>S SingleInsert("a")
    :nnoremap <silent>s<F12> <nop>
    :nnoremap <silent>S<F12> <nop>

    " Repeat mappings
    " Allow for repeated wrapping
    :nnoremap <silent>. :call RepeatFunc()<CR>

    " Move lines up and down respectively
    :nnoremap <silent>- :silent! call MoveLineDown()<CR>
    :nnoremap <slient>_ :silent! call MoveLineUp()<CR>

    " Indent entire file
    :nnoremap <slient><leader>g :call Indent()<CR>

    " Edit and reload vimrc
    :nnoremap <silent><leader>ev :vsplit $MYVIMRC<CR>
    :nnoremap <silent><leader>sv :silent source $MYVIMRC<CR>
    :nnoremap <silent><leader>s% :source %<CR>

    " Add an empty line right above or below current line
    :nnoremap <leader>o o<esc>
    :nnoremap <leader>O O<esc>

    " Clear highlighting from search
    :nnoremap <silent><c-L> :nohlsearch<CR><c-L>

    " Turn on highlighting every time you re-search/look for next item
    " And centers found item on page
    :nnoremap n :set hlsearch<cr>nzz
    :nnoremap N :set hlsearch<cr>Nzz
    :nnoremap / :set hlsearch<cr>/
    :nnoremap ? :set hlsearch<cr>?
    :nnoremap # :set hlsearch<cr>#zz
    :nnoremap * :set hlsearch<cr>*zz

    " Mapping for jumping to error
    :nnoremap <silent><C-up>    :lnext<CR>
    :nnoremap <silent><C-down>  :lprev<CR>
    :nnoremap <silent><C-left>  :lfirst<CR>
    :nnoremap <silent><C-right> :llast<CR>

    " Wrapping Dungeon
    " Allows you to target text and wrap it in characters repeatedly
    :nnoremap <silent><leader>w :set opfunc=Wrap<CR>g@
    :vnoremap <silent><leader>W :call Wrap(visualmode())<CR>

    :nnoremap <silent><leader>sww VV:call SwapArgs(visualmode())<CR>
    :nnoremap <silent><leader>sw :set opfunc=SwapArgs<CR>g@
    :vnoremap <silent><leader>sw :call SwapArgs(visualmode())<CR>

    :nnoremap <silent><leader>== VV:call MathEval(visualmode())<CR>
    :nnoremap <silent><leader>= :set opfunc=MathEval<CR>g@
    :vnoremap <silent><leader>= :call MathEval(visualmode())<CR>

    " Resizing Split
    :nnoremap <silent><S-right> :vertical resize +5 <CR>
    :nnoremap <silent><S-left>  :vertical resize -5 <CR>
    :nnoremap <silent><S-up>    :resize +5 <CR>
    :nnoremap <silent><S-down>  :resize -5 <CR>

    " Jumping Split 
    :nnoremap <leader>h <c-w>h
    :nnoremap <leader>j <c-w>j
    :nnoremap <leader>k <c-w>k
    :nnoremap <leader>l <c-w>l
    :nnoremap <expr>+ (len(tabpagebuflist()) > 1 ? "\<C-w>=": "+")

    " Creating and navigating tabs
    :nnoremap <silent><S-tab>       :tabnext<CR>
    :nnoremap <silent><S-q>         :tabprevious<CR>
    :nnoremap <silent><leader><tab> :tabnew<CR>

    " Pasting from clipboard
    :nnoremap <leader>p "+p
    :nnoremap <leader>P "+P

    " Yanking Ops
    :nnoremap Y y$

    " Use Ctrl j and k to navigate pop-up menu
    :inoremap <expr> <tab> (pumvisible() ? "\<C-p>" : CleverTab())
    :inoremap <expr> <S-tab> (pumvisible() ? "\<C-n>" : "\<c-x>\<c-f>")

    " Commenting out lines
    :nnoremap <silent><localleader>\ :call Comment()<CR>
    :inoremap <silent><localleader>\ :call Comment("visual")<CR>

    " Paste Mode
    :nnoremap \p :set paste<CR>
    :nnoremap \p <esc>:set paste<CR>i

    " Splitting into a file
    :nnoremap <leader>v :vs <cfile><CR>
    :nnoremap <leader>t :tabnew <cfile><CR>

    " Statistics <leader><space> g<c-g>

    " Opening Files
    :inoremap gqq <esc>gqqA
    :nnoremap VJ Vj
    :nnoremap VJJ Vjj
    :nnoremap VJJJ Vjjj

    :nnoremap <C-p> :vs<CR><C-]>

" }}}

" UNIVERSAL ABBREVIATIONS AND COMMANDS {{{
" _________________________________________________________________________
    
    " Vert splitting is better than horizontal splitting
    :cabbrev help <C-R>=CommandLineStart(":", "vert help", "help")<CR>
    :cabbrev sp <C-R>=CommandLineStart(":", "vs", "sp")<CR>
    :cabbrev sf <C-R>=CommandLineStart(":", "vert sf", "sf")<CR>
    :cabbrev vf <C-R>=CommandLineStart(":", "vert sf", "sf")<CR>
    :cabbrev find <C-R>=CommandLineStart(":", "Find", "find")<CR>

    " Quitting in its many forms
    :cabbrev W <C-R>=CommandLineStart(":", "w", "W")<CR>
    :cabbrev Q <C-R>=CommandLineStart(":", "q", "Q")<CR>
    :cabbrev Wq <C-R>=CommandLineStart(":", "wq", "Wq")<CR>
    :cabbrev WQ <C-R>=CommandLineStart(":", "wq", "WQ")<CR>
    :cabbrev Set <C-R>=CommandLineStart(":", "set", "Set")<CR>
    :cabbrev we <C-R>=CommandLineStart(":", "w\|e", "we")<CR>

    " Expanding for substitutions
    :cabbrev S <C-R>=CommandLineStart(":", "%s", "S")<CR>
    :cabbrev a <C-R>=CommandLineStart(":", "'a,.s", "a")<CR>
    :cabbrev $$ <C-R>=CommandLineStart(":", ".,$s", "$$")<CR>
    :cabbrev Q! <C-R>=CommandLineStart(":", "q!", "Q!")<CR>

    " Force Writing
    if !has('win32')
        :cabbrev w!! %!sudo tee > /dev/null %
    endif

    " Tags file for jumping
    :command! MakeTags !ctags -Rf .tags --exclude=.session.vim

    " Turn on folding
    :command! Fold :setlocal foldenable | setlocal foldmethod=syntax
    :command! Compile :call Compile()
    :command! Template :call NewFile()
    :command! -nargs=1 -complete=file_in_path Find :call Find("<args>")

" }}}

" AUTOCMD GROUPS {{{
" _________________________________________________________________________
" {{{
:if has("autocmd")
" }}}

    " Universal Commands
    " {{{
    :augroup Universal
    :autocmd!
    :autocmd BufNewFile *  :autocmd BufWritePost * :call IfScript() " Mark files with shebang as executable
    :autocmd BufRead *     :call CorrectFile()
    :autocmd BufNewFile *  :call CorrectFile()
    :autocmd CursorHold *  :if get(g:, "hltimeout", 1) | set nohlsearch | endif " Turn off highlighting after a few seconds of nouse
    :autocmd InsertLeave * :setlocal nopaste " Turn off paste when leaving insert mode
    :autocmd BufReadPost * :if line("'\'") > 0 && line("'\'") <= line("$") | exe "normal! g'\"" | endif " Jump to where you were in a file
    :autocmd BufEnter *    :let &commentstring = Strip(substitute(&commentstring, '\s*%\s*', ' %s ', ''))
    :autocmd SwapExists *  :call SwapExists()
    :autocmd BufNewFile *  :call NewFile()
    :autocmd VimLeave *    :call SaveSess()
    :autocmd VimEnter * nested call RestoreSess()
    :autocmd VimEnter *    :call HighlightSettings()
    :augroup END 
    " }}}
    
    " Option Autocmds
    " {{{
    :if exists("##OptionSet")
    :augroup options
    :autocmd!
    :autocmd OptionSet relativenumber :let &number=&relativenumber " Turn on and off number when we toggle relative number
    :autocmd OptionSet wrap           :let &linebreak=&wrap        " Break on words when wrapping
    :autocmd OptionSet spell          :setlocal spellland=en       " Set spell language when we turn on spell
    :autocmd OptionSet spell          :syntax spell toplevel       
    :autocmd OptionSet spell          :nnoremap <silent><buffer><localleader>s :call SpellReplace()<CR>
    :autocmd OptionSet spell          :inoremap <silent><buffer><localleader>s :call SpellReplace()<CR>a
    :augroup END
    :endif
    " }}}

    " C Style Formatting
    " {{{
    :augroup c_style
    :autocmd!
    :autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer><localleader>s :call SplitIf()<CR>
    :autocmd FileType c,cpp,javascript,java,perl,cs :nnoremap <silent><buffer>; :call AppendSemicolon()<CR>
    :autocmd FileType c,cpp,javascript,java,perl,cs :inoremap <buffer>{} {<CR>}<esc>Opening
    :autocmd FileType c,cpp,javascript,java,perl,cs :setlocal cindent
    :autocmd FileType c,cpp,javascript,java,perl,cs :iabbrev <buffer>csign <c-r>=Csign()<CR>
    :autocmd FileType c,cpp,javascript,java,perl,cs :autocmd BufRead, BufWrite, <buffer> :silent call RemoveTrailingWhiteSpace()
    :autocmd FileType c,cpp,javascript,java,perl,cs :command! Format :call CFormat()
    :autocmd FileType c,cpp,javascript,java,perl,cs :call CFold()
    :augroup END
    " }}}

    " C/Cpp Formatting
    " {{{
    :augroup c_cpp
    :autocmd!
    :autocmd FileType c,cpp :setlocal complete+=t
    :autocmd FileType c,cpp :iabbrev <buffer> #i #include
    :autocmd FileType c,cpp :iabbrev <buffer> #I #include
    :autocmd FileType c,cpp :iabbrev <buffer> #d #define
    :autocmd FileType c,cpp :iabbrev <buffer> #D #define
    :autocmd FileType c,cpp :iabbrev <buffer> cahr char
    :autocmd FileType c,cpp :iabbrev <buffer> main <C-R>=CMainAbbrev()<CR>
    :autocmd FileType cpp :iabbrev <buffer> enld endl
    :autocmd FileType cpp :iabbrev nstd using namespace std;<CR>
    :augroup END
    " }}}

    " Web Formatting
    " {{{
    :augroup web
    :autocmd!
    :autocmd FileType css,html,htmldjango :setlocal tabstop=2
    :autocmd FileType html,htmldjango :setlocal expandtab
    :autocmd FileType html,htmldjango :setlocal wrap
    :autocmd FileType html,htmldjango :setlocal linebreak
    :if exists("+breakindent")
    :   autocmd FileType html,htmldjango :setlocal breakindent
    :endif
    :autocmd FileType html,htmldjango :inoremap <silent><buffer>> ><esc>:call EndTagHTML()<CR>a
    :autocmd FileType html,htmldjango :inoremap <expr><buffer><CR> HTMLCarriageReturn()
    :let g:html_indent_script1 = "inc"
    :let g:html_indent_style1 = "inc"
    :let g:html_indent_inctags = "address,article,aside,audio,blockquote,canvas,dd,div,dl,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,header,hgroup,hr,main,nav,noscript,ol,output,p,pre,section,table,tfoot,ul,video"
    :autocmd FileType html,htmldjango :command! Preview call HTMLPreview()
    :autocmd FileType css :nnoremap <silent><buffer>; :call AppendSemicolon()<CR>
    :autocmd FileType css :inoremap <buffer>{} {<CR>}<esc>O
    :augroup END
    " }}}

    " Python Formatting
    " {{{
    :augroup python_
	:autocmd FileType python  :setlocal tabstop=4
	:autocmd FileType python  :setlocal expandtab
	:autocmd FileType python  :setlocal nosmartindent
	:autocmd FileType python  :setlocal complete-=i
	:autocmd FileType python  :iabbrev inport import
	:autocmd FileType python  :autocmd BufRead,BufWrite <buffer> :silent call RemoveTrailingWhitespace()
	:autocmd FileType python  :iabbrev <buffer> main <C-R>=PythonMainAbbrev()<CR>
	:autocmd FileType python  :let g:pyindent_open_paren = '&sw'
	:autocmd FileType python  :let g:pyindent_nested_paren = '&sw'
	:autocmd FileType python  :let g:pyindent_continue = '0'
	:autocmd FileType python  :autocmd BufEnter <buffer> :if getline(1) !~ '^#' | call append(0, "#!/usr/bin/env python3") | endif
	:autocmd FileType python  :autocmd CursorMoved,CursorMovedI <buffer> call HighlightAfterColumn(79)
	:autocmd FileType python  :autocmd BufWrite <buffer> :call PythonBlankLineFix()
    :augroup END
    " }}}

	" Vim file
	" {{{
	:augroup vim_
	:autocmd!
	:autocmd FileType vim :setlocal foldmethod=marker
	:autocmd FileType vim :setlocal foldenable
	:autocmd FileType vim :setlocal foldtext=MyFold()
	:autocmd BufWritePost .vimrc :source %
	:augroup END
	" }}}

:endif
" }}}

" FUNCTIONS {{{
" _________________________________________________________________________
    
    " Helpers
    " {{{
        :function! Strip(str)
        :   return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
        :endfunction

        :function! LStrip(str)
        :   return substitute(a:str, '^\s*', '', '')
        :endfunction

        :function! RStrip(str)
        :   return substitute(a:str, '\s*$', '', '')
        :endfunction

        :function! Text(line)
        :   return Strip(getline(a:line))
        :endfunction

        :function! LineFromCursor()
        :   return getline('.')[col('.')-1:]
        :endfunction

        :function! LineUntilCursor()
        :   return getline('.')[:col('.')-1]
        :endfunction

        :function! LineAfterCursor()
        :   return LineFromCursor()[1:]
        :endfunction

        :function! LineBeforeCursor()
        :   return LineUntilCursor()[:-2]
        :endfunction

        :function! TextFromCursor()
        :   return Strip(LineFromCursor())
        :endfunction

        :function! TextUntilCursor()
        :   return Strip(LineUntilCursor())
        :endfunction

        :function! TextAfterCursor()
        :   return Strip(LineFromCursor())
        :endfunction

        :function! TextBeforeCursor()
        :   return Strip(LineBeforeCursor())
        :endfunction

        :function! MotionHelp(type, func)
        :   let l:window = winsaveview()
        :   if a:type == "v" || a:type == "V" || a:type == "\<C-V>"
        :       let [l:startl, l:startc] = getpos("'<")[1:2]
        :       let [l:endl, l:endc] = getpos("'>")[1:2]
        :   else
        :       let [l:startl, l:startc] = getpos("'[")[1:2]
        :       let [l:endl, l:endc] = getpos("']")[1:2]
        :   endif
        :   if a:type == "line" || a:type == "V"
        :       call map(range(l:startl, l:endl), { i, l -> MotionHelpInt(l, 1, 0, a:func) })
        :   elseif a:type == "char" || a:type == "v"
        :       call MotionHelpInt(l:startl, l:startc, l:endc, a:func)
        :   elseif a:type == "block" || a:type == "\<C-V>"
        :       call map(range(l:startl, l:endl), { i, l -> MotionHelpInt(l, l:startl, l:endc, a:func) })
        :   endif
        :   call winrestview(l:window)
        :endfunction

        :function! MotionHelpInt(line, startc, endc, func)
        :   let l:line = getline(a:line)
        :   let l:start = a:startc <= 1 ? "" : (l:line[:(a:startc-2)])
        :   let l:end = a:endc == 0 ? "" : (l:line[(a:endc):])
        :   let l:val = l:line[(a:startc - 1):(a:endc - 1)]
        :   call setline(a:line, a:func(l:start, l:val, l:end))
        :endfunction

        :function! MotionWrap(type, start, end)
        :   MotionHelp(a:type, { a, b, c -> a . a:start . b . a:end . c })
        :endfunction

        :function! Input(arg)
        :   call inputsave()
        :   let l:input = input(a:arg)
        :   call inputrestore()
        :   return l:input
        :endfunction

    " }}}

    " HTML
    " {{{

        :let s:unclosed = [ "area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr", "canvas" ]
        
        :function! GetEndTagHTML()
        :   let l:line = TextUntilCursor()
        :   if l:line !~ '<\w\+[^>]*>$'
        :       return ""
        :   endif
        :   let l:tag = split(split(split(l:line, "<")[-1], ">")[0], " ")[0]
        :   if l:tag =~ '^' . join(s:unclosed, '$\|^') . '$'
        :       return ""
        :   endif
        :   return "</".l:tag.">"
        :endfunction

        :function! EndTagHTML()
        :   if LineAfterCursor() == "" 
        :       call setline(".", getline('.') . GetEndTagHTML())
        :   endif
        :endfunction

        :function! HTMLCarriageReturn()
        :   let l:leftside = TextBeforeCursor()
        :   let l:rightside = TextFromCursor()
        :   if l:leftside =~ '<.*>\s*$' && l:rightside =~ '^\s*</.*>'
        :       return "\<CR>\<esc>O"
        :   endif
        :   return "\<CR>"
        :endfunction

        :function! HTMLPreview()
        :   let l:refresh = '<meta http-equiv="refresh" content="1">'
        :   execute ':g/'.l:refresh.'/d'
        :   execute ':g/<head>/normal! o'.l:refresh
        :   write
        :   silent !xdg-open % >/dev/null 2>/dev/null &
        :endfunction

    " }}}

    " C Style Functions
    " {{{

        :function! Csign()
        :   if &l:formatoptions =~ "cro"
        :       let rtn = "/**\rBen Greenberg\r".strftime("%m/%d/%Y")."\r".split(expand('%:p'), '/')[-2]."\r".@%." \r\r<bs>*/"
        :   else
        :       let rtn = "/**\r<bs>* Ben Greenberg\r* ".strftime("%m/%d/%Y")."\r".split(expand('%:p'), '/')[-2].@%." \r* \r*/"
        :   endif
        :endfunction

        :function! CFold()
        :   setlocal foldtext=CFoldText()
        :   setlocal fillchars=fold:\ "
        :   highlight Folded guifg=DarkGreen ctermfg=DarkGreen
        :endfunction

        :function! CFoldText()
        :   let l:tablen = &l:shiftwidth
        :   let l:lines = v:foldend - v:foldstart - 1
        :   let l:line = getline(v:foldstart)
        :   let l:endline = getline(v:foldend)
        :   let l:line = substitute(getline(v:foldstart), '^\s*\(.\{-}\){\s*$', '\1', '')
        :   return (repeat(" ", indent(v:foldstart)).l:line.'{ '.l:lines.' line'.(l:lines!=1 ? "s" : "").' }')[winsaveview()['leftcol']:]
        :endfunction

        :function! HighlightAfterColumn(col)
        :   let s:exclude_patterns = [ '[^=]*<<[^=]*', '\/\/', '\/\*', '\*\/', '^\s*#', 'print', 'cout', 'cerr' ]
        :   for m in get(b:, "matches", [])
        :       silent! call matchdelete(m)
        :   endfor
        :   let b:matches = []
        :   if get(g:, "hllonglines", 1) && getline('.') !~ join(s:exclude_patterns, '\|')
        :       call add(b:matches, matchadd('LongLine', '\%'.line('.').'l\%>'.(a:col).'v.'))
        :   endif
        :endfunction

        :function! AppendSemicolon()
        :   let l:text = Text('.')
        :   if l:text =~ ';$'
        :       if l:text =~ '^if' || l:text =~ '^for' || l:text =~ '^while'
        :           call setline('.', getlline('.')[:-2])
        :       endif
        :   else
        :       call setline('.', getline('.') . ';')
        :   endif
        :endfunction

        :function! CMainAbbrev()
        :   if getline('.') =~ '^$'
        :       call getchar()
        :       if get(g:, 'inline_braces')
        :           return "int main(int argc, char **argv){\<CR>}\<up>\<esc>o"
        :       else
        :           return "int main(int argc, char **argv)\<CR>{\<CR>}\<up>\<esc>o"
        :       endif
        :   else
        :       return "main"
        :   endif
        :endfunction

		:function! CFormat()
		" {{{
		:  let l:window = winsaveview()
		:  %s/\s*,\s*/, /g
		:  call Indent()
		:  call winrestview(l:window)
		:endfunction

    " }}}

    " Python Functions
    " {{{

        :function! PythonMainAbbrev()
        :   if getline('.') =~ '^$'
        :       let l:rtn = 'import sys\n\n\ndef usage():\nprint(\"Usage: ' . expand("%") . '\", file=sys.stderr)\n'
        :       let l:rtn .= "sys.exit(1)\n\n\n\b"
        :       return l:rtn . "def main():\npass\n\n\nif __name__ == \"__main__\":\nsys.exit(main())"
        :   else
        :       return "main"
        :   endif
        :endfunction

    " }}}

    " Universal Functions
    " {{{

        :function! CleverTab()
        :   if pumvisible()
        :       return "\<C-P>"
        :   endif
        :   let l:str = strpart(getline('.'), 0, col('.') - 1)
        :   let l:words = split(l:str, " ")
        :   let l:last_word = len(l:words) > 0 ? l:words[-1] : ""
        :   if l:str =~ '^\s*$' || l:str =~ '\s$'
        :       return "\<Tab>"
        :   elseif l:last_word =~ '\/' && len(glob(l:last_word[1:] . "*") > 0
        :       return "\<C-X>\<C-F>"
        :   elseif l:last_word =~ '^\/' && len(glob(l:last_word[1:] . "*")) > 0 
        :       " Needs work
        :       return "\<C-P>"
        :   endif
        :   return "\<C-P>"
        :endfunction

        :function! CommandLineStart(type, arg, default)
        :   return (getcmdtype() == a:type && getcmdline() == "") ? a:arg : a:default
        :endfunction

        :function! Comment(...) range
        :   let l:window = winsaveview()
        :   if get(a:, 1, "") ==# 'visual'
        :       '<,'>call Comment()
        :       call winrestview(1:window)
        :       return
        :   endif
        :   let l:temp = split(&commentstring, "%s")
        :   let l:start = escape(get(l:temp, 0, ""), '\*/!"')
        :   let l:end = escape(get(l:temp, 1, ""), '\*/!"')
        :   let l:startshort = substitute(l:start, ' $', '', '')
        :   let l:endshort = substitute(l:end, '^ ', '', '')
        :   if l:end ==# ""
        :       execute "silent ".a:firstline.'s:^\(\s*\)\(.\(:\1'.l:start.'\2:e'
        :       execute "silent ".a:firstline.","a:lastline.'s:^\(\s*\)'.l:start.l:startshort.'\{,1}:\1:e'
        :   else 
        :       execute "silent ".a:firstline.'s:^\(\s*\)\(.\):\1'.l:start.'\2:e'
		:       execute "silent ".a:firstline.'s:^\(\s*\)'.l:start.l:startshort.' \{,1}:\1:e'
		:       execute "silent ".a:lastline.'s:$:'.l:end
		:       execute "silent ".a:lastline.'s: \{,1}'. l:endshort . l:end . '$::e'
        :   endif
        :   call winrestview(l:window)
        :   nohlsearch
        endfunction

		:function! Comment_New(...) range
		:  let l:window = winsaveview()
		:  if get(a:, 1, "") ==# 'visual'
		:    '<,'>call Comment()
		:    return
		:  endif
		:  let l:line = getline('.')
		:  let l:temp = split(&commentstring, "%s")
		:  let l:start = escape(get(l:temp, 0, ""), '\*/!"')
		:  let l:end = escape(get(l:temp, 1, ""), '\*/!"')
		:  let l:startshort = substitute(l:start, ' $', '', '')
		:  let l:endshort = substitute(l:end, '^ ', '', '')
		:  if l:end ==# ""
		:    execute "silent ".a:firstline.",".a:lastline.'s:^\(\s*\)\(.\):\1'.l:start.'\2:e'
		:    execute "silent ".a:firstline.",".a:lastline.'s:^\(\s*\)'.l:start.l:startshort.' \{,1}:\1:e'
		:  else
		:    execute "silent ".a:firstline.'s:^\(\s*\)\(.\):\1'.l:start.'\2:e'
		:    execute "silent ".a:firstline.'s:^\(\s*\)'.l:start.l:startshort.' \{,1}:\1:e'
		:    execute "silent ".a:lastline.'s:$:'.l:end
		:    execute "silent ".a:lastline.'s: \{,1}'. l:endshort . l:end . '$::e'
		:  endif
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction

        :function! Compile()
        :   call system("compile ".expand("%"))
        :endfunction

        :function! CorrectFile()
        :   let l:file = expand("%")
        :   if &ft == "" && stridx(l:file, ".") == -1 && executable(l:file)
        :       let l:glob = glob(l:file . ".*", 0, 1)
        :       if len(l:glob) == 1
        :           execute "e! ". l:glob[0]
        :       endif
        :   endif
        :endfunction

        :function! Find(name)
        :   let l:fn = findfile(a:name)
        :   if l:fn != ""
        :       execute ":e " . l:fns[0]
        :   endif
        :endfunction

        :function! GetChar()
        :   while getchar(1) == 0
        :   endwhile
        :   return nr2char(getchar())
        :endfunction

        :function! HJKL()
        :   noremap <Up> <NOP>
        :   noremap <Down> <NOP>
        :   noremap <Left> <NOP>
        :   noremap <Right> <NOP>
        :   inoremap <ESC> <NOP>
        :endfunction

        :function! IfScript()
        :   if getline(1) =~ '^#!/' && exists("*setfperm")
        :       let perm = getfperm(expand("%"))
        :       let perm = perm[:1] . "x" . perm[3:]
        :       call setfperm(expand("%"), perm)
        :   endif
        :endfunction

        :function! Indent()
        :   let l:window = winsaveview()
        :   normal! gg=G
        :   call winrestview(l:window)
        :endfunction

        :function! MathEval(type) range
        :   call MotionHelp(a:type, { a, b, c -> a . string(eval(b)) , c})
        :endfunction

        :function! MoveLineUp()
        :   silent move . -2
        :endfunction
        
        :function! MoveLineDown()
        :   silent move . +1
        :endfunction

        :function! MyFold()
        :   let l:tablen = &tabstop
        :   let line = getline(v:foldstart)
        :   let lines_count = v:foldend - v:foldstart + 1
        :   setlocal fillchars=fold:\ "
        :   let foldline = substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g')
        :   let foldline = (strlen(foldline) > 0 ? ': ' : "") . foldline
        :   return (repeat(" ", indent(v:foldstart)). '+--- ' . lines_count . ' lines' . foldline . ' ---+')[winsaveview()["leftcol"]:]
        :endfunction

        :function! NewFile()
        :   let l:fn = &filetype
        :   if filereadable($HOME . "/.vim/templates/" . l:fn)
        :       execute "%!cat " . $HOME . "/.vim/templates/" . l:fn
        :   endif
        :endfunction

        :function! Random(min, max)
        :   let l:rand = system("echo $RANDOM")
        :   return a:min + l:rand % (a:max - a:min)
        :endfunction

        :function! RemoveTrailingWhitespace()
		:  let l:window = winsaveview()
		:  let l:line = getline('.')
		:  %s/\s\+$//ge
		:  call winrestview(l:window)
		:  call setline('.', l:line)
		:  call winrestview(l:window)
		:  nohlsearch
		:endfunction

        :function! RepeatFunc()
        :   let s:repeat = get(s:, 'repeatstack', "")
        :   let s:repeatstack = ""
        :endfunction

        :function! RestoreSess()
        :   if system("stat -c '%U' .") != $USER
        :       return
        :   elseif expand("%") != ""
        :       return
        :   elseif get(g:, "manage_sessions") && filereadable(getcwd() . '/.session.vim') && argc() == 0
        :       execute 'so ' . getcwd() . '/.session.vim'
        :   elseif get(g:, "manage_session") && filereadable($HOME . '/session/.session.vim') && argc() == 0
        :       execute 'so ' . $HOME . '/session/.session.vim'
        :   endif
        :endfunction

        :function! SaveSess()
        :   if system("stat -c '%U' .") != $USER || getcwd() == $HOME
        :       return
        :   endif
        :   if get(g:, "manage_sessions")
        :       execute 'mksession! ' . getcwd() . '/.session.vim'
        :   elseif get(g:, "manage_session")
        :       call mkdir($HOME.'/.vim/session')
        :       execute 'mksession! ' . $HOME . '/session/.session.vim'
        :   endif
        :endfunction

        :function! SingleInsert(how)
        :   return a:how . GetChar() . "\<esc>`^"
        :endfunction

        :function! SpellReplace()
        :   let l:window = winsaveview()
        :   normal! [s1z=
        :   call winrestview(l:window)
        :endfunction
        
        :function! SwapArgs(type) range
        :   call MotionHelp(a:type, function("SwapArgsInt"))
        :endfunction

        :function! SwapArgsInt(start, val, end)
        :   if a:value =~ ","
        :       let l:v = join(reverse(map(split(a:value, ","), {i, v -> Strip(v)})), ", ")
        :   else
        :       let l:v = join(reverse(map(split(a:value), {i, v -> Strip(v)})))
        :   endif
        :   return a:start . l:v . a:end
        :endfunction

        :function! SwapExists()
        :   if getftime(expand("%")) > getftime(v:swapname)
        :       let v:swapchoice = "d"
        :       echohl WarningMsg | echom "Deleting Swapfile" | echohl None
        :   endif
        :endfunction

        :function! System(arg)
        :   if has('win32')
        :       throw "Calls to system()  not supported on windows"
        :   endif
        :   let l:return = system(a:arg)
        :   if v:shell_error != 0
        :       throw "Error: system(". a:arg .") returned ". v:shell_error
        :   endif
        :   return l:return
        :endfunction

        :function! Wrap(type) range
        :   let l:window = winsaveview()
        :   let l:sel_save = &selection
        :   let &selection = "inclusive"
        :   let s:wrapinput = get(s:, 'repeat', "") != "wrap" ? nr2char(getchar()) : get(s:, 'wrapinput', "")
        :   let [s:repeatstack, s:repeat] = ["wrap", ""]
        :   let [l:begin, l:ending] = WrapHelp(s:wrapinput)
        :   call MotionWrap(a:type, l:begin, l:ending)
        :endfunction

        :function! WrapHelp(arg)
        :   execute "let l:last  = {".substitute(&matchpairs, '\(.\):\(.\)', '"\1":"\2"', "g")."}"
		:   execute "let l:first = {".substitute(&matchpairs, '\(.\):\(.\)', '"\2":"\1"', "g")."}"
        :   let l:begin = get(l:first, a:arg, a:arg)
        :   let l:end = get(l:last, a:arg, a:arg)
        :   if l:begin ==? "t"
        :       let l:input = Input("tag: ")
        :       let l:begin = '<' . l:input . '>'
        :       let l:end = '</' . split(l:input)[0] . '>'
        :   elseif l:begin ==? "s"
        :       let [l:begin, l:end] = repeat([Input("string: ")], 2)
        :   elseif l:begin ==? "r"
        :       let l:begin = Input("string: ")
        :       let l:end = join(reverse(split(l:input, '.\zs')), '')
        :   endif
        :   return [l:begin, l:end]
        :endfunction

    " }}}

" }}}

" FEATURE ADDITION {{{
" _________________________________________________________________________

	:if filereadable(expand("~") . "/.vimrc.local")
	:  source ~/.vimrc.local
	:endif

    :if exists("g:imawimp")
    :   if !g:imawimp
    :       call HJKL()
    :   endif
    :else
    :   if !has('win32') 
    :       let s:response = confirm("I'm about to turn off the arrow keys. Use h,j,k,l for left, up, right, down respectively", "y\nn", "y")
    :       if s:response < 2
    :           call HJKL()
    :           call System("echo :let g:imawimp = 0 >> ~/.vim/.vimrc.local")
    :       else
    :           call System("echo :let g:imawimp = 1 >> ~/.vim/.vimrc.local")
    :       endif
    :   endif
    :endif

	:if get(g:, "format_text", 0)
	:   autocmd FileType text :setlocal textwidth=80
	:endif

	:if get(g:, "light_folds", 1)
	:   highlight Folded ctermfg=DarkGrey guifg=DarkGrey
	:   highlight tabline ctermfg=DarkGrey guifg=DarkGrey
	:   highlight tablinesel ctermfg=Grey guifg=Grey
	:endif

	:if get(g:, "old_c_comments")
	:   autocmd FileType c :setlocal commentstring=/*\ %s\ */
	:endif

" }}}
