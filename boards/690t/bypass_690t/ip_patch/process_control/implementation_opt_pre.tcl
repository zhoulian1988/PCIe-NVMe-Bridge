##################history########################
#version:1.0
#date:2022/05/10
#revision:initial version.
################################################
set ::env(JFM_PATH) [file join [pwd] "../.."]
set run_tcl_path [file join $::env(JFM_PATH) "ip_patch" "run.tcl"]
source $run_tcl_path
puts "Start pre_opt_design_patch :"
proc pre_opt_design_patch {} {
    set JDY_top_u0_cell [get_cells -hierarchical -regexp  -filter {REF_NAME=~JDY_ip_top_.* || ORIG_REF_NAME=~JDY_ip_top_.*}]

    if { [get_cells $JDY_top_u0_cell] != ""} {
	    
	    puts "Find $JDY_top_u0_cell cell!"
		
		set current_prj_path [file join [pwd] "../.."]
	    set dcp_path [format "%s/ip_patch/045ai/JDY_ip_top_0_route.dcp" $current_prj_path]
		if {[file exists $dcp_path] == 0} {
		    error "An error occurs:\n Can't find $dcp_path!"
		
		}

		resize_pblock [get_pblocks *jdy_top_agrp] -add { \
		SLICE_X80Y50:SLICE_X139Y149 \
		RAMB36_X4Y10:RAMB36_X5Y29 RAMB18_X4Y20:RAMB18_X5Y59 \
		DSP48_X4Y20:DSP48_X4Y59 \
		} -remove {SLICE_X80Y35:SLICE_X161Y174}


		resize_pblock [get_pblocks *cnu_fifo_agrp] -add { \
		SLICE_X90Y50:SLICE_X139Y74 \
		SLICE_X90Y75:SLICE_X139Y129 \
		} -remove {SLICE_X90Y75:SLICE_X161Y124}	
		set_property CONTAIN_ROUTING true [get_pblocks  *jdy_top_agrp]		
        set_property HD.PARTITION 1 [get_cells $JDY_top_u0_cell]
        update_design -cell [get_cells $JDY_top_u0_cell] -black_box
        read_checkpoint -cell [get_cells $JDY_top_u0_cell] $dcp_path
        lock_design -level routing [get_cells $JDY_top_u0_cell]
		# Disable bitstream CRC 
		set_property BITSTREAM.GENERAL.CRC DISABLE [current_design]
		#Disable DRC check during generating bitstream
		#set_property IS_ENABLED 0 [get_drc_checks  REQP-44]
		#set_property IS_ENABLED 0 [get_drc_checks  REQP-46]
	
	} else {
	    puts "Current project don't need to replace JDY_top_u0 cell!"
	}

}
pre_opt_design_patch
puts "Finish pre_opt_design_patch successfully!"
