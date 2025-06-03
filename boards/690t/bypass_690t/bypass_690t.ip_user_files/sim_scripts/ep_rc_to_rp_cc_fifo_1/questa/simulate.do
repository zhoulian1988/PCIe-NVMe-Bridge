onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ep_rc_to_rp_cc_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {ep_rc_to_rp_cc_fifo.udo}

run -all

quit -force
