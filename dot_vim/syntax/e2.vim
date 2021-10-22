" Vim syntax file
" Language: E2
" Maintainer: Patrick Kreutzer
" Latest Revision: 22 August 2016

if exists("b:current_syntax")
  finish
endif

" keywords
syn keyword e2Keyword func end if then else while do return var and or as

" primitive types
syn keyword e2Type int real

" integer
syn match e2Number '\<\d\+'

" character literal
syn match e2Character "'[^\\]'"

" floating point number
syn match e2Number '\<\d\+\.\d*'

" comments
syn match e2Comment "#.*$"

let b:current_syntax = "e2"

hi def link e2Keyword   Statement
hi def link e2Type      Type
hi def link e2Number    Constant
hi def link e2Character Character
hi def link e2Comment   Comment
