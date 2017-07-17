#---------------------------------------------------------------------------------------------------- 
#--------------------Copyright @ 2016 C-L-G.FPGA1988.bwang. All rights reserved----------------------
#
#                   --              It to be define                --
#                   --                    ...                      --
#                   --                    ...                      --
#                   --                    ...                      --
#---------------------------------------------------------------------------------------------------- 
#File Information
#---------------------------------------------------------------------------------------------------- 
#File Name      : svn_director_create.pl 
#Project Name   : scripts
#Description    : The perl script which can create a standard svn work director.
#Github Address : https://github.com/C-L-G/scripts/file mkdir/svn_director_create.pl
#License        : CPL
#---------------------------------------------------------------------------------------------------- 
#Version Information
#---------------------------------------------------------------------------------------------------- 
#Create Date    : 01-07-2016 17:00(1th Fri,July,2016)
#First Author   : bwang
#Modify Date    : 03-07-2016 14:20(1th Sun,July,2016)
#Last Author    : bwang
#Version Number : 001   
#Last Commit    : 03-07-2016 14:30(1th Sun,July,2016)
#---------------------------------------------------------------------------------------------------- 
#Revison History
#---------------------------------------------------------------------------------------------------- 
#03-07-2016 - bwang - Add os match to use the tree command : Linux and Mac OS have been added.
#03-07-2016 - bwang - Add the project path and verif path parameter.
#02-07-2016 - bwang - Add the tree show operation of the project : linux and mac os.
#02-07-2016 - bwang - Add the file header and do some modification on the file mkdir.
#01-07-2016 - bwang - The initial version.
#---------------------------------------------------------------------------------------------------- 
#use File::Path


#---------------------------------------------------------------------------------------------------- 
#---------------------------------------------------------------------------------------------------- 
#1. The Global Parameter Define
#---------------------------------------------------------------------------------------------------- 
#---------------------------------------------------------------------------------------------------- 

#---------------------------------------------------------------------------------------------------- 
#1.1 the test variable
#---------------------------------------------------------------------------------------------------- 
#$os_get = "linux Centos 5.7" 

#puts "Now you are run the $os_get os.\n" 
#$project_path = "/Users/bwang/projects"
set project_path  "e:/projects"
puts "the project path = $project_path\n"
#$project_name = "$project_path/asic_project"
set project_name  "gt0000"
#$verif_arch   = "{bin,flist,model,tb,tc,wave}"

#---------------------------------------------------------------------------------------------------- 
#---------------------------------------------------------------------------------------------------- 
#2. The Main Code
#---------------------------------------------------------------------------------------------------- 
#---------------------------------------------------------------------------------------------------- 

#---------------------------------------------------------------------------------------------------- 
#2.1 The level 1
#---------------------------------------------------------------------------------------------------- 

file mkdir "$project_name"
file mkdir "$project_name/branches"
file mkdir "$project_name/tags"
file mkdir "$project_name/trunk"
file mkdir "$project_name/trunk/alg"
file mkdir "$project_name/trunk/doc"
file mkdir "$project_name/trunk/ic"
file mkdir "$project_name/trunk/person"
file mkdir "$project_name/trunk/sw"


#---------------------------------------------------------------------------------------------------- 
#2.2 The level 2 : doc
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/doc/alg"
file mkdir "$project_name/trunk/doc/design"
file mkdir "$project_name/trunk/doc/fpga"
file mkdir "$project_name/trunk/doc/kickoff"
file mkdir "$project_name/trunk/doc/market"
file mkdir "$project_name/trunk/doc/review"
file mkdir "$project_name/trunk/doc/sw"
file mkdir "$project_name/trunk/doc/tapeout"
file mkdir "$project_name/trunk/doc/vendor"
file mkdir "$project_name/trunk/doc/verif"

#---------------------------------------------------------------------------------------------------- 
#2.2 The level 2 : ic
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/analog"
file mkdir "$project_name/trunk/ic/apr"
file mkdir "$project_name/trunk/ic/digital"
file mkdir "$project_name/trunk/ic/env"
file mkdir "$project_name/trunk/ic/fpga"
file mkdir "$project_name/trunk/ic/fullchip"
file mkdir "$project_name/trunk/ic/typeout"
file mkdir "$project_name/trunk/ic/lib"
file mkdir "$project_name/trunk/ic/memory"
file mkdir "$project_name/trunk/ic/rule"
file mkdir "$project_name/trunk/ic/tapeout"

#---------------------------------------------------------------------------------------------------- 
#2.3 The level 3 : apr
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/apr/datain"
file mkdir "$project_name/trunk/ic/apr/dataout"
file mkdir "$project_name/trunk/ic/apr/db"
file mkdir "$project_name/trunk/ic/apr/lib"
file mkdir "$project_name/trunk/ic/apr/script"
file mkdir "$project_name/trunk/ic/apr/tf"
file mkdir "$project_name/trunk/ic/apr/work"

#---------------------------------------------------------------------------------------------------- 
#2.4 The level 3 : digital
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/digital/formal"
file mkdir "$project_name/trunk/ic/digital/nlint"
file mkdir "$project_name/trunk/ic/digital/power"
file mkdir "$project_name/trunk/ic/digital/rtl"
file mkdir "$project_name/trunk/ic/digital/sta"
file mkdir "$project_name/trunk/ic/digital/syn"
file mkdir "$project_name/trunk/ic/digital/verif"
#2.1.1 you can use -p to create the director
#---------------------------------------------------------------------------------------------------- 
#2.5 The level 4 : formal
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/digital/formal/pre_layout"
file mkdir "$project_name/trunk/ic/digital/formal/pre_layout/report"
file mkdir "$project_name/trunk/ic/digital/formal/post_layout"
file mkdir "$project_name/trunk/ic/digital/formal/post_layout/report"

#---------------------------------------------------------------------------------------------------- 
#2.5 The level 5 : nlint
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/digital/nlint/bin"
file mkdir "$project_name/trunk/ic/digital/nlint/result"

#---------------------------------------------------------------------------------------------------- 
#2.5 The level 5 : power
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/digital/power/log"
file mkdir "$project_name/trunk/ic/digital/power/reports"
file mkdir "$project_name/trunk/ic/digital/power/results"
file mkdir "$project_name/trunk/ic/digital/power/run_dir"
file mkdir "$project_name/trunk/ic/digital/power/scripts"

#---------------------------------------------------------------------------------------------------- 
#2.5 The level 5 : sta
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/digital/sta/pre_layout"
file mkdir "$project_name/trunk/ic/digital/sta/post_layout"

#---------------------------------------------------------------------------------------------------- 
#2.5 The level 5 : syn
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/digital/syn"
file mkdir "$project_name/trunk/ic/digital/syn/reports"
file mkdir "$project_name/trunk/ic/digital/syn/results"
file mkdir "$project_name/trunk/ic/digital/syn/scripts"
#---------------------------------------------------------------------------------------------------- 
#2.5 The level 5 : verif
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/digital/verif/bin"
file mkdir "$project_name/trunk/ic/digital/verif/coverage"
file mkdir "$project_name/trunk/ic/digital/verif/hsim"
file mkdir "$project_name/trunk/ic/digital/verif/flist"
file mkdir "$project_name/trunk/ic/digital/verif/lib"
file mkdir "$project_name/trunk/ic/digital/verif/log"
file mkdir "$project_name/trunk/ic/digital/verif/model"
file mkdir "$project_name/trunk/ic/digital/verif/run"
file mkdir "$project_name/trunk/ic/digital/verif/tb"
file mkdir "$project_name/trunk/ic/digital/verif/tc"
file mkdir "$project_name/trunk/ic/digital/verif/wave"
#---------------------------------------------------------------------------------------------------- 
#2.2 The fpga director
#---------------------------------------------------------------------------------------------------- 
file mkdir "$project_name/trunk/ic/fpga/constraint"
file mkdir "$project_name/trunk/ic/fpga/prj"
file mkdir "$project_name/trunk/ic/fpga/cfg"
file mkdir "$project_name/trunk/ic/fpga/src"
file mkdir "$project_name/trunk/ic/fpga/verif"
file mkdir "$project_name/trunk/ic/fpga/verif/bin"
file mkdir "$project_name/trunk/ic/fpga/verif/flist"
file mkdir "$project_name/trunk/ic/fpga/verif/tb"
file mkdir "$project_name/trunk/ic/fpga/verif/tc"
file mkdir "$project_name/trunk/ic/fpga/verif/wave"
#file mkdir -p "$project_name/trunk/ic/fpga/verif/$verif_arch"

#---------------------------------------------------------------------------------------------------- 
#2.3 The tree function
#---------------------------------------------------------------------------------------------------- 

puts "Thank you for use the script!\n"


#---------------------------------------------------------------------------------------------------- 
#---------------------------------------------------------------------------------------------------- 
#3. The End
#---------------------------------------------------------------------------------------------------- 
#---------------------------------------------------------------------------------------------------- 
