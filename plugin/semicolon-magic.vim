
if exists('g:SemicolonMagicLoaded') || &cp || version < 700
  finish
endif
let g:SemicolonMagicLoaded = 1

" Which pairs to auto-blance
" TODO not implemented, only a lookup-table for now
if !exists('g:SemicolonMagicPairs')
  let g:SemicolonMagicPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
end

" Add a semicolon to end of line
if !exists('g:SemicolonMagicAddSemicolon')
  let g:SemicolonMagicAddSemicolon = 1
end

" Balance triple quotes
if !exists('g:SemicolonMagicTripleQuotes')
  let g:SemicolonMagicTripleQuotes = 1
end

" Insert-mode mapping
if !exists('g:SemicolonMagicInsertMap')
  let g:SemicolonMagicInsertMap = ';;'
end

" Normal-mode mapping
if !exists('g:SemicolonMagicNormalMap')
  let g:SemicolonMagicNormalMap = ''
end

" Enabled
if !exists('g:SemicolonMagicEnabled')
  let g:SemicolonMagicEnabled = 1
end

" Debug Mode
if !exists('g:SemicolonMagicDebug')
  let g:SemicolonMagicDebug = 0
end

function! SemicolonMagic()
  if !b:SemicolonMagicEnabled
    return
  endif

  let skipsc = !b:SemicolonMagicAddSemicolon

  let origline = getline('.')
  echom 'Original line              : '.origline

  " Remove trailing whitespace/semicolons
  let origline = substitute(origline, '\s*;*\s*$', '' ,'')
  " Remove pipe character
  let origline = substitute(origline, '|', '' ,'')
  let line = origline
  echom 'Preprocessed Line          : '.line

  " Remove escaped characters
  let line = substitute(line, '\v\\.','','g')
  echom 'Removed escape characters  : '.line

  " Remove qualified triplets
  let line = substitute(line,'\v""".{-}"""','','g')
  let line = substitute(line,'\v''''''.{-}''''''','','g')
  let line = substitute(line,'\v```.{-}```','','g')
  echom 'Removed qualified triplets : '.line

  " Remove qualified strings
  let line = substitute(line,'\v".{-}"','','g')
  let line = substitute(line,'\v''.{-}''','','g')
  let line = substitute(line,'\v`.{-}`','','g')
  echom 'Removed !=0 quoted strings : '.line

  " Remove qualified empty strings (except triplets)
  "let line = substitute(line,'\v([^"])""([^"])','\1\2','g')
  "let line = substitute(line,'\v([^''])''''([^''])','\1\2','g')
  "let line = substitute(line,'\v([^`])``([^`])','\1\2','g')
  echom 'Removed qualified          : '.line

  " Actually parse the syntax
  let newline = ''
  while newline != line
    let newline = line
    let line = substitute(line,'\v\([^\(\)\[\]\{\}]*\)','','g')
    let line = substitute(line,'\v\[[^\(\)\[\]\{\}]*\]','','g')
    let line = substitute(line,'\v\{[^\(\)\[\]\{\}]*\}','','g')
  endwhile
  echom 'Parsed                     : '.line

  " Leave only open tags (and remove whitespace not between tags)
  let line = substitute(line,'\v([^\(\[\{"''`])\s*','\1','g')
  let line = substitute(line,'\v[^\(\[\{"''` ]*','','g')
  let line = substitute(line,'\v^\s*','','')
  echom 'Open Tags Only             : '.line

  " There can be at most one of each
  " Find the first occurrence
  let v = match(line, '\v(([''"`])\2\2\zs|[''"`]\zs)')
  if v > 0
    let line = strpart(line, 0, v)
  endif
  echom 'Parsed Open String         : '.line

  let chars = split(line,'\zs')
  let skipsc = skipsc || (len(chars)>0 && get(chars,0)=='{')
  let chars = reverse(copy(chars))

  let s = ''
  for char in chars
    if has_key(b:SemicolonMagicPairs,char)
      let s .= b:SemicolonMagicPairs[char]
    else
      let s .= char
    endif
  endfor
  echom 'Proposed Close String      : '.s

  let skipsc = skipsc || (origline[-1:]=='}')

  " Add a semicolon if the last char isn't }
  if skipsc
    echom 'Skipping Semicolon'
    call setline('.', substitute(origline.s, ';*\s*$', '', ''))
  else
    echom 'Adding Semicolon'
    call setline('.', substitute(origline.s, ';*\s*$', ';', ''))
  endif

endfunction

function! SemicolonMagicToggle()
  if b:SemicolonMagicEnabled
    let b:SemicolonMagicEnabled = 0
    echo 'SemicolonMagic Disabled.'
  else
    let b:SemicolonMagicEnabled = 1
    echo 'SemicolonMagic Enabled.'
  end
  return ''
endfunction

function! SemicolonMagicInit()
  if exists('b:SemicolonMagicLoaded')
    return
  endif
  let b:SemicolonMagicLoaded = 1

  " Load buffer local options first
  if !exists('b:SemicolonMagicEnabled')
    let b:SemicolonMagicEnabled = g:SemicolonMagicEnabled
  endif

  if !exists('b:SemicolonMagicPairs')
    let b:SemicolonMagicPairs = g:SemicolonMagicPairs
  endif

  if !exists('b:SemicolonMagicAddSemicolon')
    let b:SemicolonMagicAddSemicolon = g:SemicolonMagicAddSemicolon
  endif

  if !exists('g:SemicolonMagicTripleQuotes')
    let b:SemicolonMagicTripleQuotes = g:SemicolonMagicTripleQuotes
  end

  " Load the key mappings
  if g:SemicolonMagicInsertMap != ''
    if g:SemicolonMagicDebug
      execute 'inoremap <buffer> '.g:SemicolonMagicInsertMap. ' <ESC>:call SemicolonMagic()<CR>o'
    else
      execute 'inoremap <buffer> <silent> '.g:SemicolonMagicInsertMap. ' <ESC>:silent! call SemicolonMagic()<CR>o'
    endif
  endif

  if g:SemicolonMagicNormalMap != ''
    if g:SemicolonMagicDebug
      execute 'nnoremap <buffer>  '.g:SemicolonMagicNormalMap. ' <ESC>:call SemicolonMagic()<CR>'
    else
    execute 'nnoremap <buffer> <silent> '.g:SemicolonMagicNormalMap. ' <ESC>:silent! call SemicolonMagic()<CR>'
    endif
  endif

endfunction

" TODO check
autocmd BufEnter * :call SemicolonMagicInit()
