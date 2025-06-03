package provide jfmDesign::VivadoInterface 0.1
package require jfmKit 0.1

namespace eval ::jfmDesign::VivadoInterface {
#    namespace export \
#    namespace ensemble create

proc addFilesForISE {args} {
	set startTime [jfmKit::getTime]
	set fileList ""
    set type ""
	jfmKit::parseArgs {-f -type} {fileList type} {-f} $args
	if {$fileList == ""} {
		puts "add files default"
        foreach ele $args {
            addOneFile $ele
        }
	} elseif {[regexp -nocase vhd $type]} {
        set contents [jfmKit::readFiles $fileList]
        set dir [file dirname $fileList]
        foreach line $contents {
            regsub -all {\s+} $line " " new1
            regsub -all {\"} $new1 "" new
            set lines [split $new " "]
            set len [llength $lines]
            if {$len ==3} {
                set language [lindex $lines 0]
                set library [lindex $lines 1]
                set fileName [lindex $lines 2]
            } elseif {$len == 2} {
                set library [lindex $lines 0]
                set fileName [lindex $lines 1]
            } else {
                puts "ignore line:$line"
                continue
            }
            if {$library == "work"} {
                set library "xil_defaultlib"
            }
            set vhdfile [file join $dir $fileName]
            addOneFile $vhdfile $library
        }
    } else {
        puts "not support yet."
        puts "please use '-type vhd -f fileList' as arguments"
    }
	set endTime [jfmKit::getTime]
	puts "addFiles complete! startTime:$startTime, endTime:$endTime."
}

#needed
proc addFilesForVivado {args} {
	set startTime [jfmKit::getTime]
	set fileList ""
	jfmKit::parseArgs {-f} {fileList} {-f} $args
	if {$fileList == ""} {
		puts "error: no filelist added, if you want to add one file, please use command: addOneFile"
	} else {
        set contents [jfmKit::readFiles $fileList]
        set dir [file dirname $fileList]
        set properties [dict create]
        foreach line $contents {
            if {[regexp {^library:\s*(.*)$} $line all library]} {
                dict set properties LIBRARY $library
            } elseif {[regexp {^type:\s*(.*)$} $line all type]} {
                dict set properties FILE_TYPE $type
            } elseif {[regexp {^file:\s*(.*)$} $line all fileName]} {
		puts $fileName
                add_files $fileName
	            dict for {key val} $properties {
		            if {[dict get $properties $key] != ""} {
			            set_property -quiet $key $val [get_files $fileName]
		            }
	            }
                import_files -force $fileName

            }
        }
    }
	set endTime [jfmKit::getTime]
	puts "addFiles complete! startTime:$startTime, endTime:$endTime."
}

#needed
proc addConstraintsForVivado {args} {
	set startTime [jfmKit::getTime]
	set fileList ""
	jfmKit::parseArgs {-f} {fileList} {-f} $args
	if {$fileList == ""} {
		puts "error: no filelist added, if you want to add one file, please use command: addOneFile"
	} else {
        set contents [jfmKit::readFiles $fileList]
        set dir [file dirname $fileList]
        set properties [dict create]
        foreach line $contents {
            if {[regexp {^order:\s*(.*)$} $line all order]} {
                dict set properties PROCESSING_ORDER $order
            } elseif {[regexp {^type:\s*(.*)$} $line all type]} {
                dict set properties FILE_TYPE $type
            } elseif {[regexp {^used_in_synthesis:\s*(.*)$} $line all used_in_synthesis]} {
                dict set properties USED_IN_SYNTHESIS $used_in_synthesis
            } elseif {[regexp {^used_in_implementation:\s*(.*)$} $line all used_in_implementation]} {
                dict set properties USED_IN_IMPLEMENTATION $used_in_implementation
            } elseif {[regexp {^scoped_to_ref:\s*(.*)$} $line all ref]} {
                dict set properties SCOPED_TO_REF $ref
            } elseif {[regexp {^scoped_to_cells:\s*(.*)$} $line all cells]} {
                dict set properties SCOPED_TO_CELLS $cells
            } elseif {[regexp {^file:\s*(.*)$} $line all fileName]} {
                add_files -fileset constrs_1 $fileName
	            dict for {key val} $properties {
		            if {[dict get $properties $key] != ""} {
			            set_property -quiet $key $val [get_files $fileName]
		            }
	            }
#                import_files -force $fileName
            }
        }
    }
	set endTime [jfmKit::getTime]
	puts "addFiles complete! startTime:$startTime, endTime:$endTime."
}

proc addOneFile {filePath {library 0}} {
    if {[file exists $filePath]} {
        puts "add file: $filePath"
        add_files $filePath
        if {$library != 0} {
            set_property library $library [get_files $filePath]
        }
        import_files -force $filePath
    } else {
        puts "error: no such file: $filePath"
    }
}

proc removeAllFiles {args} {
    set delete 0
	jfmKit::parseArgs {-delete} {delete} {} $args
    set files [get_files -all]
    foreach ele $files {
        set filePath [get_property NAME $ele]
	    remove_files $ele
        if {$delete == 1} {
            file delete -force $filePath
        }
    }
}
#needed
proc reportSourceToFile {} {
	set startTime [jfmKit::getTime]
    set directory [get_property DIRECTORY [current_project]]
    set filepath "$directory/source.list"
    set fh [open $filepath "w"]
    set filesetss {}
    set files [get_files -compile_order sources -used_in synthesis]
    foreach ele $files {
        set fileType [get_property FILE_TYPE $ele]
        set fileName [file tail $ele]
        if {$fileType == "Design Checkpoint"} {
            regexp {^(\w+)\.dcp$} $fileName allStr filesetName
            puts "fileset found: $filesetName"
            lappend filesetss [get_filesets $filesetName]
            set blockfiles [get_files -compile_order sources -used_in synthesis -of [get_filesets $filesetName]]
            foreach blockfile $blockfiles {
                puts "$blockfile"
                writeSrcFileProperty $blockfile $fh
            }
        } else {
            writeSrcFileProperty $ele $fh
        }
    }
    close $fh
	set endTime [jfmKit::getTime]
	puts "INFO:reportSources complete! outfile: $filepath, StartTime:$startTime, endTime:$endTime.\n"
    reportConstraintToFile $filesetss
}

proc writeSrcFileProperty {file fh} {
    set library [get_property LIBRARY $file]
    set fileType [get_property FILE_TYPE $file]
    puts $fh "library: $library"
    puts $fh "type: $fileType"
    puts $fh "file: $file"
}


proc reportConstraintToFile {filesetss} {
	set startTime [jfmKit::getTime]
    set directory [get_property DIRECTORY [current_project]]
    set filepath "$directory/constraint.list"
    set fh [open $filepath "w"]
    set files {}
    set xdcs [get_files -compile_order constraints -used_in synthesis]
    foreach ele $xdcs {lappend files $ele}
    set xdcs [get_files -compile_order constraints -used_in implementation]
    foreach ele $xdcs {lappend files $ele}
    foreach filesets $filesetss {
        set xdcs [get_files -compile_order constraints -used_in synthesis -of $filesets -quiet]
        foreach ele $xdcs {
            if {[regexp {_ooc.xdc$} $ele]} {
            } else {
	        lappend files $ele
            }
        }
        set xdcs [get_files -compile_order constraints -used_in implementation $filesets -quiet]
        foreach ele $xdcs {
            if {[regexp {_ooc.xdc$} $ele]} {
            } else {
	        lappend files $ele
            }
        }
    }
    set files [jfmKit::derepeat $files]
    foreach ele $files {
        puts $ele
        set obj [get_files $ele]
        writeConstraintFileProperty $obj $fh
    }
    close $fh
	set endTime [jfmKit::getTime]
	puts "INFO:reportConstraints complete! outfile: $filepath, StartTime:$startTime, endTime:$endTime."
}

proc writeConstraintFileProperty {file fh} {
    set fileType [get_property FILE_TYPE $file]
    set order [get_property PROCESSING_ORDER $file]
    set used_in_synthesis [get_property USED_IN_SYNTHESIS $file]
    set used_in_implementation [get_property USED_IN_IMPLEMENTATION $file]
    set scoped_to_ref [get_property SCOPED_TO_REF $file]
    set scoped_to_cells [get_property SCOPED_TO_CELLS $file]
    puts $fh "type: $fileType"
    puts $fh "order: $order"
    puts $fh "used_in_synthesis: $used_in_synthesis"
    puts $fh "used_in_implementation: $used_in_implementation"
    puts $fh "scoped_to_ref: $scoped_to_ref"
    puts $fh "scoped_to_cells: $scoped_to_cells"
    puts $fh "file: $file"
}

}

