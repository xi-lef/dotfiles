# SP Snippets

## Installation

Add the below configuration to your `vimrc` to install
[coc](https://github.com/neoclide/coc.nvim) and
[coc-snippets](https://github.com/neoclide/coc-snippets). You need to have some
plugin manager installed (e.g.,
[vim-plug](https://github.com/junegunn/vim-plug)). Alternatively, you can also
use the minimal `vimrc` provided in `vimrc_minimal` (it works in the CIP-pool).

Then, copy the `*_sp.snippet`-files to `~/.vim/UltiSnips`.

```vim
" only these two lines are strictly required
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" version 3.0.5 is required so the context is considered for auto-completion suggestions
let g:coc_global_extensions = ['coc-snippets@3.0.5']

" use (shift +) tab to go through CoC's suggestions, and enter to confirm one
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : '<Tab>'
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : ''
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm() : '<CR>'

" Inserts an SP-grading comment, with the arrow pointing to the position of the
" cursor
function SPComment(print_arrow = 1)
    if &filetype ==# 'c' || expand('%') ==# 'machfile'
        let start = '/*'
        let middle = ''
        let end = '*/'
    elseif &filetype ==# 'make'
        let start = '##'
        let middle = '# '
        let end = '#/'
    else
        echoerr 'Unrecognized filetype'
        return
    endif

    " 'sp-comments' is bugged (or 'featured'?), so we have to limit the column for '^'
    let target = min([79, virtcol('.')])
    let arrow = !a:print_arrow ? '' : repeat(' ', target - 4) . '^'
    let clear = "\<Esc>0\"_Di" " helper-'function' to clear a line

    execute 'normal! o' . clear . start . 'K' . arrow . "\<CR>"
                \ . clear . end . "\<Esc>O" . clear . middle
    startinsert!
endfunction

" \c inserts a comment with an arrow, \C without an arrow
nnoremap <silent> <Leader>c :call SPComment()<CR>
nnoremap <silent> <Leader>C :call SPComment(0)<CR>
" 
```

## Usage

1. Find a mistake in a student's submission.
2. With your cursor, go to the position the arrow is supposed to point to and
   hit `\c` (or `<Leader>c`, depending on your `mapleader`).
3. Start typing and use `coc`'s auto-completion to find a suitable snippet.
    1. All task-specific snippets start with the task name, so you can, for
       example, type `lilo` and see all snippets applicable to `lilo`.
    2. General snippets try to use descriptive names. Take a look at the
       available snippets beforehand to get an idea of the names.
4. Depending on the snippet, it might prompt you to enter/adjust some custom
   text. Just look out for a word being selected after inserting a snippet.

Of course, not every possible mistake is covered by a snippet; do not become
lazy. :)
