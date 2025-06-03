onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ep_690t_veiglo_xmc_opt

do {wave.do}

view wave
view structure
view signals

do {ep_690t_veiglo_xmc.udo}

run -all

quit -force
