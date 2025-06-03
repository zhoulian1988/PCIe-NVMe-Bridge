package provide jfmKit 0.1

namespace eval ::jfmKit {
#    namespace export \
#    namespace ensemble create
proc getTime {} {
    set curtime [clock format [clock seconds] -format {%Y/%m/%d %H:%M:%S}]
    return $curtime
}

}
