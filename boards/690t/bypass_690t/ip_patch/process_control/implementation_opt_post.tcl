set ::env(JFM_PATH) [file join [pwd] "../.."]
set run_tcl_path [file join $::env(JFM_PATH) "ip_patch" "run.tcl"]
source $run_tcl_path
set prj_path [get_prj_path]
open_project $prj_path
puts "step 4:post_opt_design_patch"
close_project
post_opt_design_patch 
