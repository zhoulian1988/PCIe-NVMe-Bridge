source [file join $::env(JFM_PATH) src pkgIndex.tcl]
package require jfmKit 0.1
#package require jfmDesign::VivadoInterface 0.1
package require jfmDevice::VivadoInterface 0.1

set time [jfmKit::getTime]
#puts $time
#::jfmDevice::VivadoInterface::writeTileInfo -p xc7k325t-ffg900 -f 123
#::jfmDevice::VivadoInterface::writeTileInfoByList -f part.list
::jfmDevice::VivadoInterface::writePartInfo -f part.list
