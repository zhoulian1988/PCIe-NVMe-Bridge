onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ep_cq_to_rp_rq_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {ep_cq_to_rp_rq_fifo.udo}

run -all

quit -force
