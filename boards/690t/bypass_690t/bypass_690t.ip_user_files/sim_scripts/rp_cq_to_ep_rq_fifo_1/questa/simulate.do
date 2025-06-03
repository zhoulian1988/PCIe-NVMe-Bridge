onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib rp_cq_to_ep_rq_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {rp_cq_to_ep_rq_fifo.udo}

run -all

quit -force
