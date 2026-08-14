# Custom CNN Accelerator




make 

make firmware \
	VERBOSE=1 \
	         NETWORK=materials/networks/network_3.json \
	 DRAM_INPUTS=materials/dataset/inps/network_3_random_inp/  \
	DRAM_WEIGHTS=materials/dataset/wgts/network_3_random_wgt/ \
	CORE=biriscv

make rtl-project

make rtl-simulate

make call-stack

