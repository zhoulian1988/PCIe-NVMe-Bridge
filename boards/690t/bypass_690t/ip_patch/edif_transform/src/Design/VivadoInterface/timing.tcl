package provide jfmDesign::VivadoInterface 0.1
package require jfmKit 0.1

namespace eval ::jfmDesign::VivadoInterface {
#    namespace export \
#    namespace ensemble create

proc reportTimingBycell {cell {path_num 100000} {delay_type min_max}} {
	set startTime [jfmKit::getTime]
    set log [open "./timing.log" "w"]
    set timing_paths [get_timing_paths -from [get_cells $cell] -max_paths $path_num -delay_type $delay_type -sort_by group]
    foreach path $timing_paths {
        puts $log $path
    }
    close $log
	set endTime [jfmKit::getTime]
	puts "reportTimingBycell complete! startTime:$startTime, endTime:$endTime."
}

}

