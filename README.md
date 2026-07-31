# Custom CNN Accelerator




make 

make firmware \
	NETWORK=materials/networks/network_5.json \
	DRAM_INPUTS=materials/dataset/inps/  \
	DRAM_WEIGHTS=materials/dataset/wgts/ \
	CORE=biriscv

make rtl-project

make rtl-simulate

make call-stack

