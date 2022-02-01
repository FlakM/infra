" Vim syntax file
" Language: Toktme script file
" Maintainer: FlakM
" Latest Revision: 19.11.2021

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'toktme_script'
endif

let s:cpo_save = &cpo
set cpo&vim



syn match toktmeNodeName "\s\(:[a-zA-Z_\-]\+\)\s*$"

syn region toktmeString start='"' end='"' 
syn match toktmeInclude "\(include:\)"
syn match toktmeBot "\(bot:\)"
syn match toktmeUser "\(user:\)"
syn match assert "\(assert:\)"

syn match toktmeSpecial "\([\{\}%\+\-=\[\]]\)"
syn match toktmeSpecial "\(-\+:\)"
syn match toktmeActionTag "<.*>"


syn case ignore
syn keyword toktmeTodo contained TODO FIXME XXX NOTE
syn case match

syn match toktmeComment "^\([#|\/\/]\).*$" contains=toktmeTodo



syn sync fromstart
syn sync maxlines=1000

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_toktme_syn_inits")
  if version < 508
    let did_toktme_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink toktmeTodo            Todo
  HiLink toktmeComment         Comment
  HiLink toktmeString          String
  HiLink toktmeBot             Function
  HiLink assert                Function
  HiLink toktmeUser            Constant
  HiLink toktmeSpecial         Keyword
  HiLink toktmeInclude         Special
  HiLink toktmeActionTag       Special
  HiLink toktmeNodeName        Comment

  delcommand HiLink
endif


let b:current_syntax = "toktme_script"
if main_syntax == 'toktme_script'
  unlet main_syntax
endif
let &cpo = s:cpo_save
unlet s:cpo_save


