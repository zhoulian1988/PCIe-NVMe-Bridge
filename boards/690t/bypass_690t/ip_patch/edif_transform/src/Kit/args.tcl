package provide jfmKit 0.1

namespace eval ::jfmKit {
#    namespace export \
#    namespace ensemble create

proc parseArgs { options examples required arguments } {
    # Summary:
    # Parses the list "arguments" according to the given lists of argument categories:
    #   1.) options: These are arguments which take the form of -<option> <value>.
    #   2.) examples: corresponding uplevel variable name.
    #   3.) required: Arguments which are absolutely required.
    
    # Generate the usage statement
    set usage "USAGE: "
	append usage [lindex [::info level 1] 0]
	set i 0
	for {set i 0} {$i<[llength $options]} {incr i} {
        append usage " [lindex $options $i] [lindex $examples $i]"
		
	}
	if {[llength $required]} {
		append usage "\n Required Option is $required."
	} else {
		append usage "\n No Required Option Needed."
	}
	# check arguments
	for {set i 0} {$i < [llength $required]} {incr i} {
		set opt [lindex $required $i]
		if { [catch {dict get $arguments $opt} err] } {
			puts "ERROR: Arguments Error, Please refer the following usage!"
			error $usage
		}
	}

	if {[catch {dict keys $arguments} err]} {
		puts "ERROR: Arguments doesn't match 'option-value pair', Please refer the following usage!"
		error $usage
	} else {
		set keys [dict keys $arguments]
		foreach key $keys {
			set flag 1
			foreach opt $options {
				if {$opt == $key} {
					set flag 0
					break
				}
			}
			if {$flag} {
				puts "ERROR: Arguments error, unknown option: $key"
				error $usage
			}
		}
	}
	# assign parameter values
    for {set i 0} {$i < [llength $options]} {incr i} {
        set opt [lindex $options $i]
		set value ""
		if {[catch {dict get $arguments $opt} err]==0} {
			set value [dict get $arguments $opt]
		}
		upvar [lindex $examples $i] var
		set var $value
	}

    return $usage
}

proc readFiles {filePath} {
    if {[file exists $filePath]} {
        set fh [open $filePath "r"]
        set lines [split [read $fh] "\n"]
        set contents [list]
        foreach line $lines {
            if {[regexp {^\s*$} $line]} {
            } elseif {[regexp {^\s*#} $line]} {
            } else {
                lappend contents $line
            }
        }
        return $contents
    } else {
        error "error: no such file: $filePath"
    }
}

proc derepeat {mylist} {
    set news {}
    foreach ele $mylist {
        if {[lsearch -exact $news $ele]==-1 } {
            lappend news $ele
        }
    }
    return $news
}

}
