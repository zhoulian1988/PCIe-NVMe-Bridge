onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+rp_rc_to_ep_cc_fifo -L xil_defaultlib -L xpm -L fifo_generator_v13_2_2 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.rp_rc_to_ep_cc_fifo xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {rp_rc_to_ep_cc_fifo.udo}

run -all

endsim

quit -force
