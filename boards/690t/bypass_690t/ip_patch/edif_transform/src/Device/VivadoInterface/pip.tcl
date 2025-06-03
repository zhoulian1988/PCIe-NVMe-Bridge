package provide jfmDevice::VivadoInterface 0.1
package require jfmDesign::VivadoInterface 0.1
package require jfmKit 0.1

namespace eval jfmDevice::VivadoInterface {
#    namespace export \
#    namespace ensemble create

proc writePip {args} {
	set startTime [jfmKit::getTime]
	set part ""
	set fileName ""
	jfmKit::parseArgs {-p -f} {part fileName} {} $args
	if {$fileName == ""} {
		set fileName "temp.pip"
	}
	set out [open $fileName w]
	if {$part != ""} {
		jfmDesign::VivadoInterface::linkDesign -p $part
	}
	set tiles [get_tiles]
	set j 0
	set used_tile_type [dict create]
    foreach tile $tiles {
		set tile_type [get_property TYPE $tile]
		if {![dict exists $used_tile_type $tile_type]} {
        	dict set used_tile_type $tile_type $tile
			puts $out "\ntiletype:$tile_type"
			set props [list_property $tile]
			foreach prop $props {
				set value [get_property $prop $tile]
				puts $out "$prop\t$value"
			}
			set pips [get_pips -of $tile]
			foreach pip $pips {
				puts $out "tilepip:\t$pip";
			}
			set nodes [get_nodes -of $tile]
			foreach node $nodes {
				puts $out "tilenode:\t$node";
			}
			foreach node $nodes {
				puts $out "tilenode:\t$node";
				set node_pips [get_pips -of $node]
				foreach node_pip $node_pips {
					puts $out "\tnode_pip:\t$node_pip"
				}
			}
			set sites [get_sites -of $tile]
			if {[llength $sites] > 0} {
				foreach site $sites {
					set site_type [get_property SITE_TYPE $sites]
					puts $out "sitetype:$site_type"
					set site_pips [get_site_pips -of $site]
					foreach site_pip $site_pips {
						puts $out "site_pip:\t$site_pip"
					}
					set site_pins [get_site_pins -of $site]
					foreach site_pin $site_pins {
						set node [get_nodes -of $site_pin]
						puts $out "sitepin_node:\t$site_pin\t$node"
					}
				}
			}
		}
	}
	close $out
	if {$part != ""} {
		close_design
	}
	set endTime [jfmKit::getTime]
	puts "write libcell info complete! startTime:$startTime, endTime:$endTime. Output File: $fileName"
}

}
