onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib top_ep_ila_opt

do {wave.do}

view wave
view structure
view signals

do {top_ep_ila.udo}

run -all

quit -force
