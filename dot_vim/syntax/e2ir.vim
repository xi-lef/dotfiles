" Vim syntax file
" Language: E2IR
" Maintainer: Patrick Kreutzer
" Latest Revision: 06 September 2016

if exists("b:current_syntax")
  finish
endif

" keywords
syn match e2IRKeyword '\.global'
syn match e2IRKeyword '\.func'
syn match e2IRKeyword '\.param'
syn match e2IRKeyword '\.local'
syn match e2IRKeyword '\.virt'
syn match e2IRKeyword '\.code'

" primitive types
syn keyword e2IRType int real

" integer
syn match e2IRNumber '\s$\d\+'

" floating point number
syn match e2IRNumber '\s$\d\+\.\d*'

" comments
syn match e2IRComment "#.*$"

let b:current_syntax = "e2IR"

hi def link e2IRKeyword   Statement
hi def link e2IRType      Type
hi def link e2IRNumber    Constant
hi def link e2IRComment   Comment
