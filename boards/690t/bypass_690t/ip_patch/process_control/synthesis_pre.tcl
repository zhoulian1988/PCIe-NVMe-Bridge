set parent [get_property parent.project_path [current_project] -quiet]
set current_prj_path [file dirname $parent]
set ::env(JFM_PATH) $current_prj_path
set run_tcl_path [file join $::env(JFM_PATH) "ip_patch" "run.tcl"]
source $run_tcl_path
set prj_path [get_prj_path]
open_project $prj_path
puts "step 1:pre_patch_check"
pre_patch_check
puts "step 2:pre_synthesis_patch"
pre_synthesis_patch 
puts "step 3:runEco0"
runEco 0 0
close_project
