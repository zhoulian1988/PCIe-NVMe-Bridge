onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib rp_rc_to_ep_cc_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {rp_rc_to_ep_cc_fifo.udo}

run -all

quit -force
