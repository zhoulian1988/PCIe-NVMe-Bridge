set current_prj_path1 [get_property DIRECTORY [current_project]]
set jfmScriptDir1 [file join $current_prj_path1 ip_patch edif_transform]

set pkgIndexFile [file join $jfmScriptDir1 src pkgIndex.tcl]

source $pkgIndexFile

package require jfmDesign::VivadoInterface 0.1
package require jfmDevice::VivadoInterface 0.1
puts "Load Package successfully!"
