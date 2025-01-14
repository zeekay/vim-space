" space.vim - Smart Space key
" Author:       Henrik Öhman <speeph@gmail.com>
" URL:          http://github.com/spiiph/vim-space/tree/master
" Version:      1.8
" ReleaseDate:  2011 jun 09
"
" Licensed under the same terms as Vim itself.
"
" NOTE: Using this script has some problems with 'foldopen', since vim won't
"       open folds if a command is part of a mapping. This is possible to
"       emulate in Normal mode, and in most cases in Visual mode. Only for
"       searches using '/' and '?' have I been unsuccessful in finding a
"       solution.
" ============================================================================


" Set this variable to disable space.vim
"
"   let g:space_loaded = 1

" Set this variable to disable select mode mappings
"
"   let g:space_disable_select_mode = 1

" These variables disables the usage of <Space> for groups of different
" movement commands
"
" Disable <Space> for character movements, e.g. fFtT;,
"   let g:space_no_character_movements = 1
"
" Disable <Space> for searches, e.g. /?#*nN
"   let g:space_no_search = 1
"
" Disable <Space> for jump commands, e.g. Ctrl-O, Ctrl-I, g, and g;
"   let g:space_no_jump = 1
"
" Disable <Space> for diff commands, e.g. [c and ]c
"   let g:space_no_diff = 1
"
" Disable <Space> for brace movement commands, e.g. [(, ]), [{ and ]}
"   let g:space_no_brace = 1
"
" Disable <Space> for method movement commands, e.g. [m, ]m, [M and ]M
"   let g:space_no_method = 1
"
" Disable <Space> for section movement commands, e.g. [[, ]], [] and ][
"   let g:space_no_section = 1
"
" Disable <Space> for fold movement commands, e.g. [z, ]z, zj and zk
"   let g:space_no_folds = 1
"
" Disable <Space> for tag movement commands, e.g. Ctrl-], :tag, etc.
"   let g:space_no_tags = 1
"
" Disable <Space> for quickfix and location list commands, e.g. :cc, :ll, etc.
"   let g:space_no_quickfix = 1
"
" Disable <Space> for undolist movements, e.g. g- and g+
"   let g:space_no_undolist = 1

" It is possible to display the current command assigned to <Space> in the
" status line using the GetSpaceMovement() function. Here's an example:
"
"   function! SlSpace()
"       if exists("*GetSpaceMovement")
"           return "[" . GetSpaceMovement() . "]"
"       else
"           return ""
"       endif
"   endfunc
"   set statusline+=%{SlSpace()}

" TODO: Make the mapping assignments more dynamical, and allow user defined
"       commands?

if exists("g:space_debug")
    let g:space_no_character_movements = 0
    let g:space_no_search = 0
    let g:space_no_jump = 0
    let g:space_no_diff = 0
    let g:space_no_brace = 0
    let g:space_no_method = 0
    let g:space_no_section = 0
    let g:space_no_folds = 0
    let g:space_no_quickfix = 0
    let g:space_no_undolist = 0
    let g:space_no_tags = 0
    echomsg "Running space.vim in debug mode."
elseif exists("g:space_loaded")
    finish
endif
let g:space_loaded = 1

" Mapping of <Space>/<S-Space> and possibly <BS>
noremap <expr> <silent> <Space>   <SID>do_space(0, "<Space>")
noremap <expr> <silent> <S-Space> <SID>do_space(1, "<S-Space>")

if exists("g:space_disable_select_mode")
    silent! sunmap <Space>
    silent! sunmap <S-Space>
    silent! sunmap <BS>
endif

if mapcheck("<BS>") == "" || !has("gui_running")
    noremap <expr> <silent> <BS>      <SID>do_space(1, "<BS>")
    if exists("g:space_disable_select_mode")
        silent! sunmap <BS>
    endif
endif


" character movement commands
if !exists("g:space_no_character_movements") || !g:space_no_character_movements
    noremap <expr> <silent> f <SID>setup_space("char", "f")
    noremap <expr> <silent> F <SID>setup_space("char", "F")
    noremap <expr> <silent> t <SID>setup_space("char", "t")
    noremap <expr> <silent> T <SID>setup_space("char", "T")
    " noremap <expr> <silent> ; <SID>setup_space("char", ";")
    " noremap <expr> <silent> , <SID>setup_space("char", ",")

    if exists("g:space_disable_select_mode")
        silent! sunmap f
        silent! sunmap F
        silent! sunmap t
        silent! sunmap T
        " silent! sunmap ;
        " silent! sunmap ,
    endif
endif

" search commands
if !exists("g:space_no_search") || !g:space_no_search

    " do not override visual mappings for * and #
    " because these are often used for visual search functions
    if maparg('*', 'v') != ''
        nnoremap <expr> <silent> *           <SID>setup_space("search", "*")
        onoremap <expr> <silent> *           <SID>setup_space("search", "*")
        nnoremap <expr> <silent> <kMultiply> <SID>setup_space("search", "*")
        onoremap <expr> <silent> <kMultiply> <SID>setup_space("search", "*")
    else
        noremap <expr> <silent> *           <SID>setup_space("search", "*")
        noremap <expr> <silent> <kMultiply> <SID>setup_space("search", "*")
    endif

    if maparg('#', 'v') != ''
        nnoremap <expr> <silent> # <SID>setup_space("search", "#")
        onoremap <expr> <silent> # <SID>setup_space("search", "#")
    else
        noremap  <expr> <silent> # <SID>setup_space("search", "#")
    endif

    noremap <expr> <silent> g* <SID>setup_space("search", "g*")
    noremap <expr> <silent> g# <SID>setup_space("search", "g#")
    noremap <expr> <silent> n  <SID>setup_space("search", "n")
    noremap <expr> <silent> N  <SID>setup_space("search", "N")

    if exists("g:space_disable_select_mode")
        silent! sunmap *
        silent! sunmap #
        silent! sunmap <kMultiply>
        silent! sunmap g*
        silent! sunmap g#
        silent! sunmap n
        silent! sunmap N
    endif

    let s:search_mappings = 1
else
    let s:search_mappings = 0
endif

" jump commands
" NOTE: Jumps are not motions. They can't be used in Visual mode.
if !exists("g:space_no_jump") || !g:space_no_jump
    nnoremap <expr> <silent> g, <SID>setup_space("cjump", "g,")
    nnoremap <expr> <silent> g; <SID>setup_space("cjump", "g;")
    nnoremap <expr> <silent> <C-O> <SID>setup_space("jump", "\<C-o>")
    nnoremap <expr> <silent> <C-I> <SID>setup_space("jump", "\<C-i>")
endif

" diff next/prev
if !exists("g:space_no_diff") || !g:space_no_diff
    noremap <expr> <silent> ]c <SID>setup_space("diff", "]c")
    noremap <expr> <silent> [c <SID>setup_space("diff", "[c")

    if exists("g:space_disable_select_mode")
        silent! sunmap ]c
        silent! sunmap [c
    endif
endif

" previous/next unmatched ( or [
if !exists("g:space_no_brace") || !g:space_no_brace
    noremap <expr> <silent> ]) <SID>setup_space("paren", "])")
    noremap <expr> <silent> [( <SID>setup_space("paren", "[(")

    noremap <expr> <silent> ]} <SID>setup_space("curly", "]}")
    noremap <expr> <silent> [{ <SID>setup_space("curly", "[{")

    if exists("g:space_disable_select_mode")
        silent! sunmap ])
        silent! sunmap [(
        silent! sunmap ]}
        silent! sunmap [{
    endif
endif

" start/end of a method
if !exists("g:space_no_method") || !g:space_no_method
    noremap <expr> <silent> ]m <SID>setup_space("method_start", "]m")
    noremap <expr> <silent> [m <SID>setup_space("method_start", "[m")

    noremap <expr> <silent> ]M <SID>setup_space("method_end", "]M")
    noremap <expr> <silent> [M <SID>setup_space("method_end", "[M")

    if exists("g:space_disable_select_mode")
        silent! sunmap ]m
        silent! sunmap [m
        silent! sunmap ]M
        silent! sunmap [M
    endif
endif

" previous/next section or '}'/'{' in the first column
if !exists("g:space_no_section") || !g:space_no_section
    noremap <expr> <silent> ]] <SID>setup_space("section_start", "]]")
    noremap <expr> <silent> [[ <SID>setup_space("section_start", "[[")

    noremap <expr> <silent> ][ <SID>setup_space("section_end", "][")
    noremap <expr> <silent> [] <SID>setup_space("section_end", "[]")

    if exists("g:space_disable_select_mode")
        silent! sunmap ]]
        silent! sunmap [[
        silent! sunmap ][
        silent! sunmap []
    endif
endif

" previous/next fold
if !exists("g:space_no_folds") || !g:space_no_folds
    noremap <expr> <silent> zj <SID>setup_space("fold_next", "zj")
    noremap <expr> <silent> zk <SID>setup_space("fold_next", "zk")

    noremap <expr> <silent> ]z <SID>setup_space("fold_start", "]z")
    noremap <expr> <silent> [z <SID>setup_space("fold_start", "[z")

    if exists("g:space_disable_select_mode")
        silent! sunmap zj
        silent! sunmap zk
        silent! sunmap ]z
        silent! sunmap [z
    endif
endif

" tag movement
if !exists("g:space_no_tags") || !g:space_no_tags
    noremap <expr> <silent> <C-]> <SID>setup_space("tag", "\<C-]>")

    if exists("g:space_disable_select_mode")
        silent! sunmap <C-]>
    endif

    let s:tag_mappings = 1
else
    let s:tag_mappings = 0
endif

" undolist movement
if !exists("g:space_no_undolist") || !g:space_no_undolist
    noremap <expr> <silent> g- <SID>setup_space("undo", "g-")
    noremap <expr> <silent> g+ <SID>setup_space("undo", "g+")

    if exists("g:space_disable_select_mode")
        silent! sunmap g-
        silent! sunmap g+
    endif
endif

" quickfix and location list commands
if !exists("g:space_no_quickfix") || !g:space_no_quickfix
    cnoremap <expr> <CR> <SID>parse_cmd_line()
    let s:quickfix_mappings = 1
else
    let s:quickfix_mappings = 0
endif

" TODO: Have all mappings add the remapped sequence to a list, and use that
"       list to remove mappings.
command! SpaceRemoveMappings call <SID>remove_space_mappings()
function! s:remove_space_mappings()
    silent! unmap <Space>
    silent! unmap <S-Space>
    silent! unmap <BS>

    silent! unmap f
    silent! unmap F
    silent! unmap t
    silent! unmap T
    silent! unmap ;
    silent! unmap ,

    silent! unmap *
    silent! unmap #
    silent! unmap g*
    silent! unmap g#
    silent! unmap n
    silent! unmap N

    silent! nunmap g,
    silent! nunmap g;
    silent! nunmap <C-o>
    silent! nunmap <C-i>

    silent! unmap ]c
    silent! unmap [c

    silent! unmap [(
    silent! unmap ])
    silent! unmap [{
    silent! unmap ]}

    silent! unmap ]]
    silent! unmap [[
    silent! unmap ][
    silent! unmap []

    silent! unmap ]m
    silent! unmap [m
    silent! unmap ]M
    silent! unmap [M

    silent! unmap zj
    silent! unmap zk
    silent! unmap ]z
    silent! unmap [z

    silent! unmap <C-]>

    silent! unmap g-
    silent! unmap g+

    silent! cunmap <CR>

    silent! unlet g:space_loaded
endfunction

" TODO: Check if the '\>!\=' part of the pattern fails when 'iskeyword'
"       contains '!'
" NOTE: Since Vim allows commands like ":'k,'lvim /foo/ *", it's a little
"       tedious to write a perfect regexp.

let s:pre_re = '^\%(' .
    \   '\%(noa\%[utocmd]\s\+\)\=' .
    \   '\%(' .
    \     '\%(' .
    \       '\%(\d\+\)\|' .
    \       '\%(''[0-9a-zA-Z><.]\)\|' .
    \       '\%(\\[/?&]\)\|' .
    \       '[%$.]' .
    \     '\)' .
    \     '\%([-+]\d*\)\=' .
    \   '\)\=' .
    \   ',\=' .
    \   '\%(' .
    \     '\%(' .
    \       '\%(\d\+\)\|' .
    \       '\%(''[0-9a-zA-Z><.]\)\|' .
    \       '\%(\\[/?&]\)\|' .
    \       '[%$.]' .
    \     '\)' .
    \     '\%([-+]\d*\)\=' .
    \   '\)\=' .
    \ '\)\='

let s:qf_re = '\%(' .
    \ 'mak\%[e]\|' .
    \ 'v\%[imgrep]\|' .
    \ 'gr\%[ep]\|' .
    \ 'c\%(' .
    \   'c\|' .
    \   'p\%[revious]\|' .
    \   '[nN]\%[ext]\|' .
    \   '\(fir\|la\)\%[st]\|' .
    \   'r\%[ewind]\|' .
    \   '\(f\|nf\|Nf\|pf\)\%[ile]' .
    \   '\)' .
    \ '\)\>!\='

let s:lf_re = 'l\%(' .
    \ 'mak\%[e]\|' .
    \ 'v\%[imgrep]\|' .
    \ 'gr\%[ep]\|' .
    \ 'l\|' .
    \ 'p\%[revious]\|' .
    \ 'ne\%[xt]\|N\%[ext]\|' .
    \ '\(fir\|la\)\%[st]\|' .
    \ 'r\%[ewind]\|' .
    \ '\(f\|nf\|Nf\|pf\)\%[ile]' .
    \ '\)\>!\='

let s:ta_re = 't\%(' .
    \ 'a\%[g]\|' .
    \ 'n\%[ext]\|' .
    \ 'p\%[revious]\|' .
    \ 'N\%[ext]\|' .
    \ 'r\%[ewind]\|' .
    \ 'f\%[irst]\|' .
    \ 'l\%[ast]\|' .
    \ '\)\>!\='

function! s:parse_cmd_line()
    let cmd = getcmdline()
    let type = getcmdtype()

    if s:search_mappings && (type == '/' || type == '?')
        return <SID>setup_space("search", cmd)
    elseif type == ':'
        if s:quickfix_mappings
            if cmd =~ s:pre_re . s:lf_re
                return <SID>setup_space("lf", cmd)
            elseif cmd =~ s:pre_re . s:qf_re
                return <SID>setup_space("qf", cmd)
            endif
        endif
        if s:tag_mappings && cmd =~ s:pre_re . s:ta_re
            return <SID>setup_space("tag", cmd)
        endif
    end
    return "\<CR>"
endfunc

function! s:setup_space(type, command)
    let cmd = a:command
    let s:cmd_type = "undefined"

    if a:type == "char"
        let s:space_move = ";"
        let s:shift_space_move = ","
        let s:cmd_type = "hor"
        if cmd =~ "[;,]$"
            let cmd = <SID>maybe_open_fold(cmd)
        endif
    elseif a:type == "diff"
        let s:space_move = "]c"
        let s:shift_space_move = "[c"
    elseif a:type == "method_start"
        let s:space_move = "]m"
        let s:shift_space_move = "[m"
        let s:cmd_type = "block"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "method_end"
        let s:space_move = "]M"
        let s:shift_space_move = "[M"
        let s:cmd_type = "block"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "section_start"
        let s:space_move = "]]"
        let s:shift_space_move = "[["
        let s:cmd_type = "block"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "section_end"
        let s:space_move = "]["
        let s:shift_space_move = "[]"
        let s:cmd_type = "block"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "paren"
        let s:space_move = "])"
        let s:shift_space_move = "[("
        let s:cmd_type = "block"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "curly"
        let s:space_move = "]}"
        let s:shift_space_move = "[{"
        let s:cmd_type = "block"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "fold_next"
        let s:space_move = "zj"
        let s:shift_space_move = "zk"
    elseif a:type == "fold_start"
        let s:space_move = "]z"
        let s:shift_space_move = "[z"
    elseif a:type == "search"
        let s:space_move = "n"
        let s:shift_space_move = "N"
        let s:cmd_type = "search"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "cjump"
        let s:space_move = "g,"
        let s:shift_space_move = "g;"
        let s:cmd_type = "jump"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "jump"
        let s:space_move = "\<C-i>"
        let s:shift_space_move = "\<C-o>"
        let s:cmd_type = "jump"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "tag"
        let s:space_move = "tn"
        let s:shift_space_move = "tp"
        let s:cmd_type = "tag"
        if getcmdtype() == ':'
            let cmd = <SID>maybe_open_fold(cmd)
        endif
    elseif a:type == "qf"
        let s:space_move = "cn"
        let s:shift_space_move = "cN"
        let s:cmd_type = "quickfix"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "lf"
        let s:space_move = "lne"
        let s:shift_space_move = "lN"
        let s:cmd_type = "quickfix"
        let cmd = <SID>maybe_open_fold(cmd)
    elseif a:type == "undo"
        let s:space_move = "g-"
        let s:shift_space_move = "g+"
        let s:cmd_type = "undo"
        let cmd = <SID>maybe_open_fold(cmd)
    endif
    call <SID>debug_msg("setup_space(type = " . a:type .
        \ ", command = " . cmd . ")")
    return cmd
endfunc

function! s:do_space(shift, default)
    " <Space>
    if a:shift == 0
        if exists("s:space_move")
            let cmd = <SID>maybe_open_fold(s:space_move)
            call <SID>debug_msg("do_space(cmd = " . cmd . ")")
        else
            let cmd = a:default
        endif
    " <S-Space> and <BS>
    else
        if exists("s:shift_space_move")
            let cmd = <SID>maybe_open_fold(s:shift_space_move)
            call <SID>debug_msg("do_space(cmd = " . cmd . ")")
        else
            let cmd = a:default
        endif
    endif
    return cmd
endfunc

function! s:maybe_open_fold(cmd)
    if !exists("g:space_no_foldopen") && &foldopen =~ s:cmd_type && v:operator != "c"
        " special treatment of :ex commands
        if s:cmd_type == "quickfix" || s:cmd_type == "tag"
            if getcmdtype() == ':'
                return "\<CR>"
            else
                return ":\<C-u>" . (v:count ? v:count : "") . a:cmd . "\<CR>zv"
            endif
        " special treatment of /foo and ?foo commands
        elseif s:cmd_type == "search" && getcmdtype() =~ "[/?]"
            return "\<CR>zv"
        else
            if mode() =~ "[vV]"
                " NOTE: That this works is probably a bug in vim.  Let's hope
                "       it stays that way. ;)
                return ":\<C-u>normal! gv" . (v:count ? v:count : "")
                    \ . a:cmd . "zv\<CR>"
                "return a:cmd . "zv"
            else
                return a:cmd . "zv"
            endif
        endif
    else
        if s:cmd_type == "quickfix" || s:cmd_type == "tag"
            if getcmdtype() == ':'
                return "\<CR>"
            else
                return ":\<C-u>" . (v:count ? v:count : "") . a:cmd . "\<CR>"
            endif
        elseif s:cmd_type == "search" && getcmdtype() =~ "[/?]"
            return "\<CR>"
        else
            return a:cmd
        endif
    endif
endfunc

function! s:debug_msg(string)
    if exists("g:space_debug")
        echomsg a:string
    endif
endfunc

function! GetSpaceMovement()
    if exists("s:space_move")
        return s:space_move == "\<C-i>" ? "^I" : s:space_move
    else
        return ""
    end
endfunc

" vim: et sts=4 sw=4
