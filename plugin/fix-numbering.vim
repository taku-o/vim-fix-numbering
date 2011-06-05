" fix-numbering.vim:
" Load Once:
if &cp || exists("g:loaded_fix_numbering")
    finish
endif
let g:loaded_fix_numbering = 1
let s:keepcpo = &cpo
set cpo&vim
" ---------------------------------------------------------------------

function! s:FindValue(line, no)
    let l:l = 0
    let l:i = 0
    let l:s = -1
    let l:e = -1
    while l:l < a:no
        let l:s = match(a:line, '\d\+', l:i)
        let l:e = matchend(a:line, '\d\+', l:i)
        let l:i = l:e

        if l:s == -1
            return []
        endif

        let l:l += 1
    endwhile

    return [ l:s, l:e]
endfunction

function! s:GetValue(lineno, pos)
    if len(a:pos) < 2
        return ''
    endif

    let l:line = getline(a:lineno)
    return strpart(l:line, a:pos[0] , a:pos[1] - a:pos[0])
endfunction

function! s:SetValue(lineno, pos, value)
    if len(a:pos) < 2
        return
    endif

    let l:line = getline(a:lineno)
    let l:t = strpart(l:line, 0, a:pos[0])
    let l:l = strpart(l:line, a:pos[1])
    call setline(a:lineno, l:t. a:value. l:l)
endfunction

function! s:FixNumbering(...)
    if len(a:000) > 0
        let l:column_no = str2nr(a:000[0])
    else
        let l:column_no = 1
    endif

    let l:lno = line('.')

    let l:pline = getline(l:lno - 1)
    let l:ppos = s:FindValue(l:pline, l:column_no)
    if len(l:ppos) < 2
        return
    endif
    let l:pvalue = s:GetValue(l:lno - 1, l:ppos)

    let l:cline = getline('.')
    let l:cpos = s:FindValue(l:cline, l:column_no)
    if len(l:cpos) < 2
        return
    endif
    call s:SetValue(l:lno, l:cpos, l:pvalue + 1)
endfunction

command! -nargs=? -range FixNumbering :<line1>,<line2>call <SID>FixNumbering(<f-args>)

" ---------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

