onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.top_ep_ila xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {top_ep_ila.udo}

run -all

quit -force
