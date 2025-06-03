package provide jfmDevice::VivadoInterface 0.1
package require jfmKit 0.1

namespace eval jfmDevice::VivadoInterface {
#    namespace export \
#    namespace ensemble create


proc writePart {args} {
	set startTime [jfmKit::getTime]
	set fileName ""
	jfmKit::parseArgs {-f} {fileName} {} $args
	if {$fileName == ""} {
		set fileName "temp.part"
	}
	set out [open $fileName w]
	set parts [get_parts]
	set i 0
	set len [llength $parts]
	set props [list_property [lindex $parts 0]]
	foreach part $parts {
		puts $out [format "part:%s" $part]
		puts [format "%s/%s" $i $len]
		foreach prop $props {
			set value [get_property $prop [lindex $parts $i]]
			puts $out [format "\t%s\t\t%s" $prop $value]
		}
		incr i
	}
	close $out
	set endTime [jfmKit::getTime]
	puts "write part info complete! startTime:$startTime, endTime:$endTime. Output File: $fileName"
}

}
