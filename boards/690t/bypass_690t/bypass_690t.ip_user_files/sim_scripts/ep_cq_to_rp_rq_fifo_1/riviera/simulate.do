onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+ep_cq_to_rp_rq_fifo -L xil_defaultlib -L xpm -L fifo_generator_v13_2_2 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ep_cq_to_rp_rq_fifo xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {ep_cq_to_rp_rq_fifo.udo}

run -all

endsim

quit -force
