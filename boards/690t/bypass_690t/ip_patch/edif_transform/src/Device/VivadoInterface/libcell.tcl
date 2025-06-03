package provide jfmDevice::VivadoInterface 0.1
package require jfmDesign::VivadoInterface 0.1
package require jfmKit 0.1

namespace eval jfmDevice::VivadoInterface {
#    namespace export \
#    namespace ensemble create

proc getLibCells {} {
	set lib_cells [get_primitives -macro -hierarchy]
	return $lib_cells
}

proc writeLibcell {args} {
	set startTime [jfmKit::getTime]
	set part ""
	set fileName ""
	jfmKit::parseArgs {-p -f} {part fileName} {} $args
	if {$fileName == ""} {
		set fileName "temp.libcell"
	}
	if {$part != ""} {
		jfmDesign::VivadoInterface::linkDesign -p $part
	}
	set out [open $fileName w]
	set lib_cells [getLibCells]
	foreach cell $lib_cells {
		puts $out "libcell:$cell"
		puts $out "props"
		set props [list_property $cell]
		foreach prop $props {
			set value [get_property $prop $cell]
			puts $out "\t$prop\t\t$value"
		}
		set cell_instance [create_cell -reference $cell tmp -quiet]
		set pins [get_pins -of $cell_instance]
		puts $out "pins"
		foreach pin $pins {
			set direction [get_property DIRECTION $pin]
			set pin_name [get_property REF_PIN_NAME $pin]
			puts $out "\t$pin_name\t\t$direction"
		}
		remove_cell $cell_instance -quiet
	}
	close $out
	if {$part != ""} {
		close_design
	}
	set endTime [jfmKit::getTime]
	puts "write libcell info complete! startTime:$startTime, endTime:$endTime. Output File: $fileName"
}

proc writeGlobalSite {args} {
	set startTime [jfmKit::getTime]
	set part ""
	set fileName ""
	jfmKit::parseArgs {-p -f} {part fileName} {} $args
	if {$fileName == ""} {
		set fileName "temp.site_type"
	}
	set out [open $fileName w]
	if {$part != ""} {
		jfmDesign::VivadoInterface::linkDesign -p $part
	}
	set global_site_map [dict create]
	set sites [get_sites]
	foreach site $sites {
		set site_type [get_property SITE_TYPE $site]
		dict lappend global_site_map $site_type $site
	}
	dict for {type site} $global_site_map {
		puts $out $type
		puts $out $site
	}
	close $out
	set endTime [jfmKit::getTime]
	puts "write libcell info complete! startTime:$startTime, endTime:$endTime. Output File: $fileName"
}

proc writeSiteCellMap {args} {
	set startTime [jfmKit::getTime]
	set part ""
	set fileName ""
	jfmKit::parseArgs {-p -f} {part fileName} {} $args
	if {$fileName == ""} {
		set fileName "temp.site_map"
	}
	set out [open $fileName w]
	if {$part != ""} {
		jfmDesign::VivadoInterface::linkDesign -p $part
	}
	set lib_cells [getLibCells]
	set sites [get_sites]
	set i 0
	set j 0
	set leni [llength $lib_cells]
	set lenj [llength $sites]
	foreach lib_cell $lib_cells {
		puts $out "libcell:$lib_cell"
		set j 0
        set cell_instance [create_cell -reference $lib_cell tmp -quiet]
		set used_site_type [dict create]
        foreach site $sites {
			set site_type [get_property SITE_TYPE $site]
			if {![dict exists $used_site_type $site_type]} {
            	dict set used_site_type $site_type $site
            	if {[catch {[place_cell $cell_instance $site]} err] == 0} {
					puts $out "sitetype:$site_type"
            	    unplace_cell $cell_instance
					set bels [get_bels -of $site]
					foreach bel $bels {
            			if {[catch {[place_cell $cell_instance $bel]} err] == 0} {
							regexp {(.*)/(.*)} $bel match siteName belName
							puts $out "bel:$belName"
            	    		unplace_cell $cell_instance
						}
					}
				}
			}
			incr j
			if {[expr $j%5000]==0} {
				puts "$i/$leni---$j/$lenj"
			}
        }
		remove_cell $cell_instance -quiet
		incr i
	}
	close $out
	if {$part != ""} {
		close_design
	}
	set endTime [jfmKit::getTime]
	puts "write libcell info complete! startTime:$startTime, endTime:$endTime. Output File: $fileName"
}

}
