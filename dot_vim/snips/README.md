# SP Snippets

## Installation

Add the below configuration to your `vimrc` to install
[coc](https://github.com/neoclide/coc.nvim) and
[coc-snippets](https://github.com/neoclide/coc-snippets) (or rather, my fork of
it, see [below](#known-issues)). You need to have some plugin manager installed
(e.g., [vim-plug](https://github.com/junegunn/vim-plug)).  
Alternatively, you can also use the minimal `vimrc` provided in `vimrc_minimal`
(it works in the CIP-pool).

Then, copy the `*_sp.snippet`-files to `~/.vim/UltiSnips`.

```vim
" only these two lines are strictly required
Plug 'neoclide/coc.nvim', {'branch': 'fix/vim-onTextChange', 'do': 'npm ci'}
Plug 'xi-lef/coc-snippets', {'branch': 'sp', 'do': 'yarn install'}

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

    " the correct amount of spaces (depending on the cursor ) follow by '^'
    let arrow = !a:print_arrow ? '' : repeat(' ', virtcol('.') - 4) . '^'
    " helper-'function' to clear a line
    let clear = "\<Esc>0\"_Di"

    execute 'normal! o' . clear . start . 'K' . arrow . "\<CR>"
                \ . clear . end . "\<Esc>O" . clear . middle
    startinsert!
endfunction

" \c inserts a comment with an arrow, \C without an arrow
nnoremap <silent> <Leader>c :call SPComment()<CR>
nnoremap <silent> <Leader>C :call SPComment(0)<CR>
```

## Usage

1. Find a mistake in a student's submission.
2. With your cursor, go to the position the arrow is supposed to point to and
   hit `\c` (or `<Leader>c`, depending on your `mapleader`).
3. Start typing and use `coc`'s auto-completion to find a suitable snippet.
    1. All task-specific snippets start with the task name, so you can, for
       example, type `lilo` and see all snippets applicable to `lilo`.
         1. For this to work, the folder containing the submissions must contain
            the exercise name; for example, you need to rename 'aufgabe1-T01' to
            'aufgabe1-T01-lilo'.
    2. General snippets try to use descriptive names. Take a look at the
       available snippets beforehand to get an idea of the names.
4. Depending on the snippet, it might prompt you to enter/adjust some custom
   text. Just look out for a word being selected after inserting a snippet.

Of course, not every possible mistake is covered by a snippet; do not become
lazy. :)

## Known Issues

- You need to open a .c-file before grading Makefiles so the snippets work
    properly. This is because of Python-code in the C-snippets-file that needs
    to be loaded, and I couldn't figure out how to share it properly (e.g. in
    `~/.vim/pythonx`).
- Makefile-snippets are not pretty, because the first line mustn't contain a '#'
    at the start, but following lines need to have it. I think this is
    unavoidable, as Make doesn't have real multiline-comments.
- Until [this pull request](https://github.com/neoclide/coc.nvim/pull/4875) is
    merged, you need to use `coc`'s `fix/vim-onTextChange`-branch to avoid the
    specific problem described in the referenced issue. With neovim, this isn't
    a problem and you can just use the `release`- or `master`-branch.
- Until [my pull request](https://github.com/neoclide/coc-snippets/pull/349) is
    (maybe) merged, you need to use my fork of `coc-snippets` in order to
    actually use my snippets.
