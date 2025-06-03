
package ifneeded jfmJtagDebugTool 0.1 {
}
package ifneeded jfmKit 0.1 {
    set current_prj_path2 [get_property DIRECTORY [current_project]]
    set jfmScriptDir2 [file join $current_prj_path2 ip_patch edif_transform src]

	source [file join $jfmScriptDir2 Kit args.tcl]
	source [file join $jfmScriptDir2 Kit time.tcl]
}
package ifneeded jfmDesign::VivadoInterface 0.1 {
	set current_prj_path2 [get_property DIRECTORY [current_project]]
	set jfmScriptDir2 [file join $current_prj_path2 ip_patch edif_transform src]

	source [file join $jfmScriptDir2 Design VivadoInterface add_files.tcl]
	source [file join $jfmScriptDir2 Design VivadoInterface link.tcl]
	source [file join $jfmScriptDir2 Design VivadoInterface timing.tcl]
}
package ifneeded jfmDevice::VivadoInterface 0.1 {
	set current_prj_path2 [get_property DIRECTORY [current_project]]
	set jfmScriptDir2 [file join $current_prj_path2 ip_patch edif_transform src]

	source [file join $jfmScriptDir2 Device VivadoInterface libcell.tcl]
	source [file join $jfmScriptDir2 Device VivadoInterface part.tcl]
	source [file join $jfmScriptDir2 Device VivadoInterface pip.tcl]
	source [file join $jfmScriptDir2 Device VivadoInterface pkg.tcl]
	source [file join $jfmScriptDir2 Device VivadoInterface rule.tcl]
	source [file join $jfmScriptDir2 Device VivadoInterface tile.tcl]
}
