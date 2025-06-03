set ::env(JFM_PATH) [file join [pwd] "../.."]
set run_tcl_path [file join $::env(JFM_PATH) "ip_patch" "run.tcl"]
source $run_tcl_path
set prj_path [get_prj_path]
open_project $prj_path
close_project
puts "step 5"
pre_write_bitstream_patch 

set JDY_top_u0_cell [get_cells -hierarchical -regexp  -filter {REF_NAME=~JDY_ip_top_.* || ORIG_REF_NAME=~JDY_ip_top_.*}]

if { [get_cells $JDY_top_u0_cell] != ""} {
    set_property IS_ENABLED 0 [get_drc_checks  REQP-44]
    set_property IS_ENABLED 0 [get_drc_checks  REQP-46]
}
		
