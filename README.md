Semicolon Magic
===============

Auto-balance brackets and quotes in line

Installation
------------
copy plugin/semicolon-magic.vim to ~/.vim/plugin

if you are using `pathogen`:

    git clone git://github.com/optroot/semicolon-magic.git ~/.vim/bundle/semicolon-magic

if you are using `Vundle`:

    Plugin 'optroot/semicolon-magic'

if you are using `vim-plug`:

    Plug 'optroot/semicolon-magic'


Features
--------

Press `;;` in insert mode to auto-close the line and start a new line below.

It works in normal mode but does not add a new line.

Does not add semicolon after `}`.

Preserve space padding.

Will not double add semicolon.


Examples

    input:  f(x(y|
    output: f(x(y));
            |

    input:  if ("arg") { return (2+f(6|
    output: if ("arg") { return (2+f(6)) }
            |

    input:  |if ("arg") return 3
    output: if ("arg") return 3;
            |

    input:  |if ("arg") return 3;
    output: if ("arg") return 3;
            |

    input:  ( ( ( { [ |
    output: ( ( ( { [] } ) ) )
            |


Toggle with SemicolonMagicToggle()

Options
-------

Below are all the options and their defaults

* Which pairs to handle (NOT IMPLEMENTED,ONLY USE DEFAULT)

    let g:SemicolonMagicPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}

* Add semicolon to end of line

    let g:SemicolonMagicAddSemicolon = 1

* Handle triple quotes

    let g:SemicolonMagicTripleQuotes = 1

* Change the insert mode mapping

    let g:SemicolonMagicInsertMap = ';;'

* Change the normal mode map

    let g:SemicolonMagicNormalMap = ''

    Use ;; and 'rhysd/clever-f.vim' to not clash

    let g:SemicolonMagicNormalMap = ';;'

* Enable/Disable

  let g:SemicolonMagicEnabled = 1

* Turn on debug messages

    let g:SemicolonMagicDebug = 0


Buffer Level Setting
--------------------


* Language based semicolon

    autocmd Filetype FILETYPE let b:SemicolonmagicAddSemicolon = 0

* Language based triple quotes

    autocmd Filetype FILETYPE let b:SemicolonmagicTripleQuotes = 0

* Language based disable/enable

    autocmd Filetype FILETYPE let b:SemicolonMagicEnabled = 0

or call/map SemicolonMagicToggle()


Recommended Settings
--------------------

The defaults (if you often use ; as a line terminator) then for each non-; language

    autocmd Filetype FILETYPE let b:SemicolonmagicAddSemicolon = 0

Otherwise enable for each filetype

    let g:SemicolonMagicAddSemicolon = 0
    autocmd Filetype FILETYPE let b:SemicolonmagicAddSemicolon = 0


