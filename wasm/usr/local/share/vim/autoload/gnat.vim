if version < 700
finish
endif
function gnat#Make () dict					     " {{{1
let &l:makeprg	 = self.Get_Command('Make')
let &l:errorformat = self.Error_Format
wall
make
copen
set wrap
wincmd W
endfunction gnat#Make						     " }}}1
function gnat#Pretty () dict					     " {{{1
execute "!" . self.Get_Command('Pretty')
endfunction gnat#Make						     " }}}1
function gnat#Find () dict					     " {{{1
execute "!" . self.Get_Command('Find')
endfunction gnat#Find						     " }}}1
function gnat#Tags () dict					     " {{{1
execute "!" . self.Get_Command('Tags')
edit tags
call gnat#Insert_Tags_Header ()
update
quit
endfunction gnat#Tags						     " }}}1
function gnat#Set_Project_File (...) dict			     " {{{1
if a:0 > 0
let self.Project_File = a:1
if ! filereadable (self.Project_File)
let self.Project_File = findfile (
\ fnamemodify (self.Project_File, ':r'),
\ $ADA_PROJECT_PATH,
\ 1)
endif
elseif strlen (self.Project_File) > 0
let self.Project_File = browse (0, 'GNAT Project File?', '', self.Project_File)
elseif expand ("%:e") == 'gpr'
let self.Project_File = browse (0, 'GNAT Project File?', '', expand ("%:e"))
else
let self.Project_File = browse (0, 'GNAT Project File?', '', 'default.gpr')
endif
if strlen (v:this_session) > 0
execute 'mksession! ' . v:this_session
endif
return
endfunction gnat#Set_Project_File				     " }}}1
function gnat#Get_Command (Command) dict			     " {{{1
let l:Command = eval ('self.' . a:Command . '_Command')
return eval (l:Command)
endfunction gnat#Get_Command					     " }}}1
function gnat#Set_Session (...) dict				     " {{{1
if argc() == 1 && fnamemodify (argv(0), ':e') == 'gpr'
call self.Set_Project_File (argv(0))
elseif  strlen (v:servername) > 0
call self.Set_Project_File (v:servername . '.gpr')
endif
endfunction gnat#Set_Session					     " }}}1
function gnat#New ()						     " {{{1
let l:Retval = {
\ 'Make'	      : function ('gnat#Make'),
\ 'Pretty'	      : function ('gnat#Pretty'),
\ 'Find'	      : function ('gnat#Find'),
\ 'Tags'	      : function ('gnat#Tags'),
\ 'Set_Project_File' : function ('gnat#Set_Project_File'),
\ 'Set_Session'      : function ('gnat#Set_Session'),
\ 'Get_Command'      : function ('gnat#Get_Command'),
\ 'Project_File'     : '',
\ 'Make_Command'     : '"gnat make -P " . self.Project_File . "  -F -gnatef  "',
\ 'Pretty_Command'   : '"gnat pretty -P " . self.Project_File . " "',
\ 'Find_Program'     : '"gnat find -P " . self.Project_File . " -F "',
\ 'Tags_Command'     : '"gnat xref -P " . self.Project_File . " -v  *.AD*"',
\ 'Error_Format'     : '%f:%l:%c: %trror: %m,'   .
\ '%f:%l:%c: %tarning: %m,' .
\ '%f:%l:%c: (%ttyle) %m'}
return l:Retval
endfunction gnat#New						  " }}}1
function gnat#Insert_Tags_Header ()				  " {{{1
1insert
!_TAG_FILE_FORMAT       1	 /extended format; --format=1 will not append ;" to lines/
!_TAG_FILE_SORTED       1	 /0=unsorted, 1=sorted, 2=foldcase/
!_TAG_PROGRAM_AUTHOR    AdaCore	 /info@adacore.com/
!_TAG_PROGRAM_NAME      gnatxref //
!_TAG_PROGRAM_URL       http://www.adacore.com  /official site/
!_TAG_PROGRAM_VERSION   5.05w   //
.
return
endfunction gnat#Insert_Tags_Header				  " }}}1
finish " 1}}}
