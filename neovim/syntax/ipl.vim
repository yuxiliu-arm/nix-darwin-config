" https://vim.fandom.com/wiki/Creating_your_own_syntax_files
if exists("b:current_syntax")
  finish
endif

syn keyword iplKeyword None Some TimeStampPrecisions VerificationPacks _ abs action add admin adminEnums adminFields adminMessages adminRecords alias assignFrom assignable break builtin case dataset datatype declare default delete description element else enum exists expanding extend false filter find for forall fresh fun function get getDefault hd if ign imandramarkets import in initialise insert intOfString interLibraryCheck internal invalid invalidfield len let library libraryMarker list makeUTCTimestamp map message messageFlows micro milli missingfield name now ofList opt option outbound overloadFunction overrideFieldTypes precision present receive record reject remove repeating repeatingGroup req return rev send service set strLen stringOfInt subset template testfile then tl toFloat toInt toList toLocalMktDate toMonthYear toUTCDateOnly toUTCTimeOnly true truncate using valid validate when with

" Integer with - + or nothing in front
syn match iplNumber '\d\+'
syn match iplNumber '[-+]\d\+'

" Floating point number with decimal no E or e 
syn match iplNumber '[-+]\d\+\.\d*'

" Floating point like number with E and no decimal point (+,-)
syn match iplNumber '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+'
syn match iplNumber '\d[[:digit:]]*[eE][\-+]\=\d\+'

" Floating point like number with E and decimal point (+,-)
syn match iplNumber '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'
syn match iplNumber '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'

syn keyword iplTodo contained TODO FIXME XXX NOTE

syn region iplString start='"' end='"' contained
syn region iplString start="'" end="'" contained

syn region iplBlock start="{" end="}" fold transparent contains=iplNumber,iplKeyword,iplString
syn match iplComment "//.*$" contains=iplTodo

let b:current_syntax = "ipl"

hi def link iplKeyword     Keyword
hi def link iplTodo        Todo
hi def link iplComment     Comment
hi def link iplBlock       Statement
hi def link iplString      Constant
hi def link iplNumber      Constant
