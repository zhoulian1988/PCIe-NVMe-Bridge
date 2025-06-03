
proc getTapValue {dqMap IODELAY_PARAM bank byte bit} {
    set value 0
    set dataWidth [dict size $dqMap]
    for {set i 0} {$i<$dataWidth} {incr i} {
        set bankByteBit [dict get $dqMap $i]
        set bank0 [lindex $bankByteBit 0]
        set byte0 [lindex $bankByteBit 1]
        set bit0 [lindex $bankByteBit 2]
        if {($bank0 == $bank) && ($byte0 == $byte) && ($bit0 == $bit)} {
            set value [dict get $IODELAY_PARAM $i]
            break
        }
    }
    return $value
}

proc printLogFile {dqMap IODELAY_PARAM fh} {
    set bytes [list A B C D]
    puts $fh "parameter DEBUG_PHASER_VIO = \"TRUE\","
    puts $fh "parameter ODELAYE2_DATA_ENABLE = \"TRUE\","
    puts $fh "parameter ODELAYE2_CMD_ENABLE = \"FALSE\","
    puts $fh "parameter DEBUG_IODELAY_VIO = \"FALSE\","
    for {set bank 0} {$bank < 3} {incr bank} {
        foreach byte $bytes {
            for {set i 0} {$i<10} {incr i} {
                set value [getTapValue $dqMap $IODELAY_PARAM $bank $byte $i]
                set iStr [format "parameter PHY_%s_%s_IDELAYE2_DELAYVALUE_%s = %s," $bank $byte $i $value]
                puts $fh $iStr
            }

            for {set i 0} {$i<12} {incr i} {
                set value [getTapValue $dqMap $IODELAY_PARAM $bank $byte $i]
                set oStr [format "parameter PHY_%s_%s_ODELAYE2_DELAYVALUE_%s = %s," $bank $byte $i $value]
                puts $fh $oStr
            }
            set oStr [format "parameter PHY_%s_%s_ODELAYE2_DELAYVALUE_DQS = 0," $bank $byte]
            puts $fh $oStr
        }
    }
    close $fh
}

proc getListAvg {tmpList} {
    set length [llength $tmpList]
    if {$length} {
        set sumList 0
        foreach ele $tmpList {
            set sumList [expr $sumList + $ele + 0.001]
        }
        set avg [expr $sumList/$length]
        set avg [format "%.0f" $avg]
        if {$avg > 0} {
            set avg [expr $avg - 0]
        }
        return $avg
    } else {
        return 0
    }
}

proc getTargetVio {vioName {index 0}} {
    set vios [get_hw_vios -of [lindex [get_hw_devices] $index]]
    set filterVios {}
    set fh [open "./vio.log" "w"]
    set i 0
    foreach vio $vios {
        set cellName [get_property CELL_NAME $vio]
        set name [get_property NAME $vio]
        if {[regexp $vioName $cellName]} {
            puts $fh "$name:$cellName"
            incr i
            lappend filterVios $vio
        }
    }
    close $fh
    puts "INFO:$vioName of device:$index has $i vios."
    return $filterVios
}

proc getControlVio {vios} {
    foreach vio $vios {
        set cellName [get_property CELL_NAME $vio]
        if {[regexp {_ddrx} $cellName]} {
            return $vio
        }
    }
}

proc getSysVio {vios} {
    foreach vio $vios {
        set cellName [get_property CELL_NAME $vio]
        if {[regexp {vio_0} $cellName]} {
            return $vio
        }
    }
    return ""
}

proc readMIGcfg {filePath} {
    set dqMap [dict create]
    set dmMap [dict create]
    if {[file exists $filePath]} {
        set fh [open $filePath "r"]
        set lines [split [read $fh] "\n"]
        foreach line $lines {
            if {[regexp DATA.*_MAP $line]} {
                regexp {DATA(\d+)_MAP.*96'h(\w+)} $line all byteGroup sub
                if {$sub == "000_000_000_000_000_000_000_000"} {
                } else {
                    set dqInfo [split $sub "_"]
                    set base [expr $byteGroup * 8]
                    set base [expr $base + 7]
                    foreach dq $dqInfo {
                        set bank [string index $dq 0]
                        set byte [string index $dq 1]
                        if {$byte == 0} {
                            set byte "A"
                        } elseif {$byte == 1} {
                            set byte "B"
                        } elseif {$byte == 2} {
                            set byte "C"
                        } elseif {$byte == 3} {
                            set byte "D"
                        }
                        set bit [string index $dq 2]
                        if {$bit == "A"} {
                            set bit "10"
                        } elseif {$bit == "B"} {
                            set bit "11"
                        } elseif {$bit == "C"} {
                            set bit "12"
                        }
                        set tmpList [list $bank $byte $bit]
                        dict set dqMap $base $tmpList
                        incr base -1
                    }
                }
            } elseif {[regexp MASK.*_MAP $line]} {
                regexp {MASK(\d+)_MAP.*108'h(\w+)} $line all byteGroup sub
                if {$sub == "000_000_000_000_000_000_000_000_000"} {
                } else {
                    set dqInfo [split $sub "_"]
                    set base [expr $byteGroup * 9]
                    set base [expr $base + 8]
                    foreach dq $dqInfo {
                        set bank [string index $dq 0]
                        set byte [string index $dq 1]
                        if {$byte == 0} {
                            set byte "A"
                        } elseif {$byte == 1} {
                            set byte "B"
                        } elseif {$byte == 2} {
                            set byte "C"
                        } elseif {$byte == 3} {
                            set byte "D"
                        }
                        set bit [string index $dq 2]
                        if {$bit == "A"} {
                            set bit "10"
                        } elseif {$bit == "B"} {
                            set bit "11"
                        } elseif {$bit == "C"} {
                            set bit "12"
                        }
                        set tmpList [list $bank $byte $bit]
                        dict set dmMap $base $tmpList
                        incr base -1
                    }
                }
                
            }
        }
    } else {
        error "ERROR: $filePath doesnot exist!"
    }
    return $dqMap
}

proc probeFilter {probeName probes} {
    set re ""
    foreach probe $probes {
        set name [get_property NAME [get_hw_probes $probe]]
        if {[regexp $probeName $name]} {
            set re $probe
            return $re
        }
    }
    return $re
}

proc setValues {vio probeName value} {
    set hw_probe [probeFilter $probeName [get_hw_probes -of [get_hw_vios $vio]]]
    if {$hw_probe != ""} {
        set_property OUTPUT_VALUE_RADIX UNSIGNED [get_hw_probes $hw_probe]
        set_property OUTPUT_VALUE $value [get_hw_probes $hw_probe]
        commit_hw_vio [get_hw_probes $hw_probe]
    } else {
        error "ERROR: set $value for probe:$probeName is failed. VIO:$vio, $probeName is not found!"
    }
}

proc getValues {vio probeName} {
    refresh_hw_vio [get_hw_vios $vio]
    set hw_probe [probeFilter $probeName [get_hw_probes -of [get_hw_vios $vio]]]
    if {$hw_probe != ""} {
        set_property INPUT_VALUE_RADIX UNSIGNED [get_hw_probes $hw_probe]
        set value [get_property INPUT_VALUE [get_hw_probes $hw_probe]]
        return $value
    } else {
        error "ERROR: get value for probe:$probeName is failed. VIO:$vio, $probeName is not found!"
    }
}

proc checkTgError {vio} {
    set tg_status [getValues $vio "tg_compare_error"]
    return $tg_status
}

proc clearTgError {vio} {
    setValues $vio "clear_error" 1
    setValues $vio "clear_error" 0
    after 200
}

proc setWindowCheck {byte vio} {
    clearTgError $vio
    setValues $vio "sel_mux_rdd" $byte
    setValues $vio "dbg_sel_pi_incdec" 1
    setValues $vio "dbg_sel_po_incdec" 1
    setValues $vio "dbg_po_f_stg23_sel" 1
}

proc restoreWindowCheck {vio} {
    clearTgError $vio
    setValues $vio "sel_mux_rdd" 0
    setValues $vio "dbg_sel_pi_incdec" 0
    setValues $vio "dbg_sel_po_incdec" 0
    setValues $vio "dbg_po_f_stg23_sel" 0
}


proc getOdelayVio {dq dqMap vios} {
    set bankByteBit [dict get $dqMap $dq]
    set bank [lindex $bankByteBit 0]
    set byte [lindex $bankByteBit 1]
    set bit [lindex $bankByteBit 2]
    foreach vio $vios {
        set cellName [get_property CELL_NAME $vio]
        if {[regexp "_4lanes_$bank.*byte_lane_$byte.*output.*$bit.*oserdes" $cellName] } {
            return $vio
        }
    }
}

proc getDqsOdelayVio {dq dqMap vios} {
    set bankByteBit [dict get $dqMap $dq]
    set bank [lindex $bankByteBit 0]
    set byte [lindex $bankByteBit 1]
    set bit [lindex $bankByteBit 2]
    foreach vio $vios {
        set cellName [get_property CELL_NAME $vio]
        if {[regexp "_4lanes_$bank.*byte_lane_$byte.*odelaye2_dqs" $cellName] } {
            return $vio
        }
    }
}

proc getPhaserVio {byte dqMap vios} {
    set base [expr $byte*8]
    set bankByteBit [dict get $dqMap $base]
    set bank [lindex $bankByteBit 0]
    foreach vio $vios {
        set cellName [get_property CELL_NAME $vio]
        if {[regexp "_4lanes_$bank.*vio_phaser_in_out_tap" $cellName] } {
            return $vio
        }
    }
}

proc setIdelayTap {vio value} {
    setValues $vio "cntvaluein" $value
}

proc setOdelayTap {vio value} {
    setValues $vio "cntvaluein" $value
    setValues $vio "odelay_ld" 1
    setValues $vio "odelay_ld" 0
}

proc getIdelayTap {vio} {
    set currentTap [getValues $vio "cntvalueout"]
    return $currentTap
}

proc getOdelayTap {vio} {
    set currentTap [getValues $vio "cntvalueout"]
    return $currentTap
}

###window move and restore###
##############################
proc tapMove {ctrVio probeName phaserProbeName} {
    set tg_status [checkTgError $ctrVio]
    set i 0
    while {$tg_status == 0} {
        set value [getValues $ctrVio $phaserProbeName]
        if {$value == 0} {
            break
        }
        if {$value == 63} {
            break
        }
        setValues $ctrVio $probeName 1
        setValues $ctrVio $probeName 0
        after 200
        set tg_status [checkTgError $ctrVio]
        if {$i == 64} {
            error "ERROR: please check init_complete and tg_error status, incr exceed 64 times."
        }
        incr i
    }
}

proc tapRestore {ctrVio probeName phaserProbeName initalVal} {
    set value [getValues $ctrVio $phaserProbeName]
    while {$value != $initalVal} {
        setValues $ctrVio $probeName 1
        setValues $ctrVio $probeName 0
        after 200
        set value [getValues $ctrVio $phaserProbeName]
    }
}
proc moveAndResume {byte ctrVio probeName probeName1 phaserProbeName initalVal} {
    tapMove $ctrVio $probeName $phaserProbeName
    set finalTap [getValues $ctrVio $phaserProbeName]
    tapRestore $ctrVio $probeName1 $phaserProbeName $initalVal
    clearTgError $ctrVio
    set tg_status [checkTgError $ctrVio]
    if {$tg_status == 1} {
        error "byte:$byte, resume is not complete, tg is error still!"
    }
    return $finalTap
}

##############################

proc windowCheck {menClkPeriod dataWidth ctrVio {byteLane "all"}} {
    set fn [open "mig_window_check.log" "w"]	
    set byteNum [expr $dataWidth/8]
    if {$byteLane == "all"} {
        set lower 0
        set upper $byteNum
    } else {
        set lower $byteLane
        set upper [expr $byteLane + 1]
    }
    set windowResult [dict create]
    for {set i $lower} {$i<$upper} {incr i} {
        setWindowCheck $i $ctrVio
        set phaserInProbeName  "dbg_pi_counter_read_val"
        set phaserOutProbeName "dbg_po_counter_read_val"
        set phaserInCenterTap  [getValues $ctrVio $phaserInProbeName]
        set phaserOutCenterTap [getValues $ctrVio $phaserOutProbeName]
#phaser in check
        set phaserInLeftTap [moveAndResume $i $ctrVio "dbg_pi_f_dec" "dbg_pi_f_inc"  $phaserInProbeName $phaserInCenterTap]
        set piLeftMargin [expr $phaserInCenterTap - $phaserInLeftTap]
        puts "byte:$i, read left window check complete, left window tap: $phaserInCenterTap - $phaserInLeftTap = $piLeftMargin."
        puts $fn "byte:$i, read left window check complete, left window tap: $phaserInCenterTap - $phaserInLeftTap = $piLeftMargin."
        set phaserInRightTap [moveAndResume $i $ctrVio "dbg_pi_f_inc" "dbg_pi_f_dec" $phaserInProbeName $phaserInCenterTap]
        set piRightMargin [expr $phaserInRightTap - $phaserInCenterTap]
        puts "byte:$i, read right window check complete, right window tap: $phaserInRightTap - $phaserInCenterTap = $piRightMargin."
        puts $fn "byte:$i, read right window check complete, right window tap: $phaserInRightTap - $phaserInCenterTap = $piRightMargin."
#phaser out check
	if  {$menClkPeriod < 2500} {
            set phaserOutLeftTap [moveAndResume $i $ctrVio "dbg_po_f_dec" "dbg_po_f_inc" $phaserOutProbeName $phaserOutCenterTap]
            set poLeftMargin [expr $phaserOutCenterTap - $phaserOutLeftTap]
            puts "byte:$i, write left window check complete, left window tap: $phaserOutCenterTap - $phaserOutLeftTap = $poLeftMargin."
            puts $fn "byte:$i, write left window check complete, left window tap: $phaserOutCenterTap - $phaserOutLeftTap = $poLeftMargin."
            set phaserOutRightTap [moveAndResume $i $ctrVio "dbg_po_f_inc" "dbg_po_f_dec" $phaserOutProbeName $phaserOutCenterTap]
            set poRightMargin [expr $phaserOutRightTap - $phaserOutCenterTap]
            puts "byte:$i, write right window check complete, right window tap: $phaserOutRightTap - $phaserOutCenterTap = $poRightMargin."
            puts $fn "byte:$i, write right window check complete, right window tap: $phaserOutRightTap - $phaserOutCenterTap = $poRightMargin."
            set tmpList [list $phaserInCenterTap $piLeftMargin $piRightMargin $phaserOutCenterTap $poLeftMargin $poRightMargin]
            dict set windowResult $i $tmpList
	} else {
            set tmpList [list $phaserInCenterTap $piLeftMargin $piRightMargin]
            dict set windowResult $i $tmpList
        }
            restoreWindowCheck $ctrVio
    }
    if  {$menClkPeriod < 2500} {    
        puts "INFO: auto read-write window check complete!"
        puts $fn "INFO: auto read-write window check complete!"
        puts                "|\tbytelane\t|\tpi-center-value\t|\trd-left-win\t|\trd-right-win\t||\tpo-center-value\t|\twr-left-win\t|\twr-right-win\t|"
        puts $fn "|\tbytelane\t|\tpi-center-value\t|\trd-left-win\t|\trd-right-win\t||\tpo-center-value\t|\twr-left-win\t|\twr-right-win\t|"
    } else {
        puts "INFO: auto read window check complete, there is no need to check the write window when the memory clock period is not less than 2500ps!"
        puts $fn "INFO: auto read window check complete, there is no need to check the write window when the memory clock period is not less than 2500ps!"
        puts     "|\tbytelane\t|\tpi-center-value\t|\trd-left-win\t|\trd-right-win\t|"
        puts $fn "|\tbytelane\t|\tpi-center-value\t|\trd-left-win\t|\trd-right-win\t|"
    }
    for {set i $lower} {$i<$upper} {incr i} {
        set result [dict get $windowResult $i]
	if  {$menClkPeriod < 2500} {
            set str [format "|\t   %s    \t|\t       %s       \t|\t     %s     \t|\t     %s     \t||\t      %s      \t|\t     %s     \t|\t      %s      \t|" $i [lindex $result 0] [lindex $result 1] [lindex $result 2] [lindex $result 3] [lindex $result 4] [lindex $result 5]]
	} else {
            set str [format "|\t   %s    \t|\t       %s       \t|\t     %s     \t|\t     %s     \t|" $i [lindex $result 0] [lindex $result 1] [lindex $result 2]]
        }
	puts $str
	puts $fn $str
    }
    close $fn
}


set vios [getTargetVio "" 0]
set ctrVio [getControlVio $vios]

