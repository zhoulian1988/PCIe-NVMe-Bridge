package provide jfmDevice::VivadoInterface 0.1
package require jfmDesign::VivadoInterface 0.1
package require jfmKit 0.1

namespace eval jfmDevice::VivadoInterface {
#    namespace export \
#    namespace ensemble create


proc writePkg {args} {
	set startTime [jfmKit::getTime]
	set part ""
	set fileName ""
	jfmKit::parseArgs {-p -f} {part fileName} {} $args
	regexp {(\w+)-(\w+).*} $part total device pkgType
	if {$fileName == ""} {
		set fileName "temp.pkg"
	}
	if {$part != ""} {
		jfmDesign::VivadoInterface::linkDesign -p $part
	}
	set out [open $fileName w]
	set temp_part [get_property PART [current_design]]
	puts $out "part:\t$temp_part"
	set pads [get_bels -filter {TYPE =~ "*PAD*"}]
	foreach pad $pads {
		set site [get_sites -of $pad]
		set type [get_property TYPE $pad]
		set state "unbonded"
		set pin_func "NA"
		set bank "NA"
		set pkgpin "NA"
		if {[get_property IS_BONDED $site]} {
			set state "bonded"
			set pkgpin [get_package_pins -of $pad]
			set pin_func [get_property PIN_FUNC $pkgpin]
			set bank [get_iobanks -of $pkgpin]
		}
		puts $out "$pad\t$type\t$pkgpin\t$site\t$state\t$bank\t$pin_func"
	}
	close $out
	if {$part != ""} {
		close_design
	}
	set endTime [jfmKit::getTime]
	puts "write $part package info complete! startTime:$startTime, endTime:$endTime. Output File: $fileName"
}

}
