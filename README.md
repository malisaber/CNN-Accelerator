# Custom CNN Accelerator




make 

make firmware \
	VERBOSE=1 \
	         NETWORK=materials/networks/network_7.json \
	 DRAM_INPUTS=materials/dataset/inps/network_7_random_inp/  \
	DRAM_WEIGHTS=materials/dataset/wgts/network_7_random_wgt/ \
	CORE=biriscv

make rtl-project

make rtl-simulate

make call-stack

