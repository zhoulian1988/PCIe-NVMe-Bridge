onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib rp_690t_opt

do {wave.do}

view wave
view structure
view signals

do {rp_690t.udo}

run -all

quit -force
