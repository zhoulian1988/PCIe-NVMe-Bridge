package provide jfmDevice::VivadoInterface 0.1
package require jfmDesign::VivadoInterface 0.1
package require jfmKit 0.1

namespace eval jfmDevice::VivadoInterface {
#    namespace export \
#    namespace ensemble create

proc writeTileInfoByList {args} {
	set partList ""
	jfmKit::parseArgs {-f} {partList} {-f} $args
	set filein [open $partList r]
	set textin [split [string trim [read $filein] "\n"] "\n"]
	foreach line $textin {
		set part $line
		puts $part
		writeTileInfo $part
	}
}

proc writeTileInfo {args} {
	set startTime [jfmKit::getTime]
	set part ""
	set fileName ""
	jfmKit::parseArgs {-p -f} {part fileName} {} $args
	if {$fileName == ""} {
		set fileName "temp.tile"
	}
	if {$part != ""} {
		jfmDesign::VivadoInterface::linkDesign -p $part
	}
	set out [open $fileName w]
	set tiles [get_tiles]
	set i 0
	set len [llength $tiles]
	set props [list_property [lindex $tiles 0]]
	foreach tile $tiles {
		set propvalues ""
		puts $out [format "tile:%s" $tile]
		foreach prop $props {
			set value [get_property $prop [lindex $tiles $i]]
#			puts $out [format "\t%s\t\t%s" $prop $value]
			set propvalues [format "%s\t%s\t\t%s\n" $propvalues $prop $value]
		}
		puts $out $propvalues
		incr i
		if {[expr $i%5000]==0} {
			puts [format "%s/%s--%s" $i $len $part]
		}
	}
	close $out
	if {$part != ""} {
		close_design
	}
	set endTime [jfmKit::getTime]
	puts "write $part tile info complete! startTime:$startTime, endTime:$endTime. Output File: $fileName"
}

proc writeBel {args} {
	set startTime [jfmKit::getTime]
	set part ""
	set fileName ""
	jfmKit::parseArgs {-p -f} {part fileName} {} $args
	if {$fileName == ""} {
		set fileName "temp.bel"
	}
	if {$part != ""} {
		jfmDesign::VivadoInterface::linkDesign -p $part
	}
	set out [open $fileName w]
	set tiles [get_tiles]
	set len [llength $tiles]
	set i 0
	foreach tile $tiles {
		puts $out $tile
		if {[expr $i%1000]==0} {
			puts "$i/$len"
		}
		set sites [get_sites -of $tile]
		foreach site $sites {
			puts $out "\t$site"
			set bels [get_bels -of $site]
			foreach bel $bels {
				puts $out "\t\t$bel"
			}
		}
		incr i
	}
	close $out
	if {$part != ""} {
		close_design
	}
	set endTime [jfmKit::getTime]
	puts "write $part bel info complete! startTime:$startTime, endTime:$endTime. Output File: $fileName"
}

}
