##################### history ################################################
#version:1.2
#date:2020/8/20
#revision:
#1)add proc xc7z045_paspd_recover
############################################################################
#version:1.1
#date: 2021/01/06
#revision:
#1)add procise_incr_cfg_file_check command to determine whether we need to call the Procise to patch the bitstream. 
############################################################################
#version:1.0
#date:2020/10/09
#revision:initial version.
############################################################################

puts "write_bitstream post hook tcl begins to run."

set default_path [pwd]

regsub {/\w+\.runs/\w+$} $default_path "" prj_directory
set procise_incr_cfg_path [file join $prj_directory "procise_incr_cfg.txt"]

if {[file exists $procise_incr_cfg_path]} {
  
  set ::env(JFM_PATH) [file join [pwd] "../.."]
  
  set run_tcl_path [file join $::env(JFM_PATH) "ip_patch" "run.tcl"]
  source $run_tcl_path
  set procise_run_tcl_path [file join $prj_directory "procise_run.tcl"]
  
  set procise_path [file join $env(FMSH_PROCISE_PATH)]
  set call_procise_bat_path [file join $prj_directory "call_procise.bat"]
  
  set procise_patch_enable [procise_incr_cfg_file_check $procise_incr_cfg_path] 
  if {$procise_patch_enable == 1} {
     generate_call_procise_bat $procise_path $procise_run_tcl_path $call_procise_bat_path
     generate_procise_run_tcl $procise_incr_cfg_path $procise_run_tcl_path
     exec cmd /c $call_procise_bat_path
     puts "write_bitstream post hook tcl runs successfully."
  } else {
     puts "write_bitstream post hook tcl runs completely, but it does nothing because the Procise increment configuration is disabled." 
  }

}
catch {delete_ip_patch_runs}


