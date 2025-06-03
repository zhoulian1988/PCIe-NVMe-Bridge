package provide jfmDesign::VivadoInterface 0.1
package require jfmKit 0.1

namespace eval ::jfmDesign::VivadoInterface {
#    namespace export \
#    namespace ensemble create

proc linkDesign {args} {
	set startTime [jfmKit::getTime]
	set part ""
	jfmKit::parseArgs {-p} {part} {} $args
	if {$part == ""} {
		puts "set default part: xc7a50tfgg484-2"
		set part "xc7a50tfgg484-2"
	}
	link_design -part $part
	set endTime [jfmKit::getTime]
	puts "link_design complete! startTime:$startTime, endTime:$endTime."
}

proc test {} {
	puts "jfmDesign::VivadoInterface";
}

}
