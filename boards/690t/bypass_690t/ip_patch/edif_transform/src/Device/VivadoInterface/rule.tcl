package provide jfmDevice::VivadoInterface 0.1
package require jfmKit 0.1

namespace eval jfmDevice::VivadoInterface {
#    namespace export \
#    namespace ensemble create


proc writeRule {args} {
	set startTime [jfmKit::getTime]
	set fileName ""
	jfmKit::parseArgs {-f} {fileName} {} $args
	if {$fileName == ""} {
		set fileName "temp.rule"
	}
	set out [open $fileName w]
	set decks [get_drc_ruledecks]
	set j 0
	foreach deck $decks {
		puts [format "%s" $deck]
		set checks [get_drc_checks -of [get_drc_ruledecks $deck]]
		set len [llength $checks]
		puts $out [format "\n%s:%s" $deck $len]
		set i 0
		foreach check $checks {
			puts [format "%s/%s" $i $len]
			puts $out [format "\t%s" $check]
			set properties [list_property $check]
			foreach prop $properties {
				set value [get_property $prop $check]
				puts $out [format "\t\t%s\t\t%s" $prop $value]
			}
			incr i
		}
		incr j $len
	}
	puts $out "total No.$j";
	close $out
	set endTime [jfmKit::getTime]
	puts "write rule info complete! startTime:$startTime, endTime:$endTime.  Output File: $fileName"
}

}
