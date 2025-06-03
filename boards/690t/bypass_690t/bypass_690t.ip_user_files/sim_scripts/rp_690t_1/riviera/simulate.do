onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+rp_690t -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.rp_690t xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {rp_690t.udo}

run -all

endsim

quit -force
