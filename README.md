# Custom CNN Accelerator




make 

make firmware \
	VERBOSE=1 \
	         NETWORK=materials/networks/network_6.json \
	 DRAM_INPUTS=materials/dataset/inps/network_6_random_inp/  \
	DRAM_WEIGHTS=materials/dataset/wgts/network_6_random_wgt/ \
	CORE=biriscv

make rtl-project

make rtl-simulate

make call-stack

