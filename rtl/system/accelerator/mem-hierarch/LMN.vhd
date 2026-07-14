library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity LMN is
	GENERIC(
		LMN_ROW_POS						:	INTEGER		:=	0;
		LMN_COL_POS						:	INTEGER		:=	0);
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
	
		--	PE's	Update	Agent	Native Side
		NAT_UPA_ready					:	OUT	Plane_std_logic;
		NAT_UPA_wait					:	OUT	Plane_std_logic;
		NAT_UPA_push					:	IN	Plane_std_logic;
		NAT_UPA_ack						:	OUT	Plane_std_logic;
		NAT_UPA_read					:	IN	Plane_std_logic;
		NAT_UPA_write					:	IN	Plane_std_logic;
		NAT_UPA_Add						:	IN	Plane_std_logic_vector_Addr;
		NAT_UPA_Cnt						:	IN	Plane_std_logic_vector_Cont;
		NAT_UPA_data_out				:	OUT	Plane_std_logic_vector_Data;
		NAT_UPA_data_rdy				:	OUT	Plane_std_logic;
		NAT_UPA_data_in					:	IN	Plane_std_logic_vector_Data;
		NAT_UPA_data_wen				:	IN	Plane_std_logic;
		--	PE's	Store	Agent	Native Side
		NAT_STA_ready					:	OUT	Plane_std_logic;
		NAT_STA_wait					:	OUT	Plane_std_logic;
		NAT_STA_push					:	IN	Plane_std_logic;
		NAT_STA_ack						:	OUT	Plane_std_logic;
		NAT_STA_read					:	IN	Plane_std_logic;
		NAT_STA_write					:	IN	Plane_std_logic;
		NAT_STA_Add						:	IN	Plane_std_logic_vector_Addr;
		NAT_STA_Cnt						:	IN	Plane_std_logic_vector_Cont;
		NAT_STA_data_out				:	OUT	Plane_std_logic_vector_Data;
		NAT_STA_data_rdy				:	OUT	Plane_std_logic;
		NAT_STA_data_in					:	IN	Plane_std_logic_vector_Data;
		NAT_STA_data_wen				:	IN	Plane_std_logic;
		--	MPE		Native Side
		NAT_MPEU_ready					:	OUT	std_logic;
		NAT_MPEU_wait					:	OUT	std_logic;
		NAT_MPEU_push					:	IN	std_logic;
		NAT_MPEU_ack					:	OUT	std_logic;
		NAT_MPEU_read					:	IN	std_logic;
		NAT_MPEU_write					:	IN	std_logic;
		NAT_MPEU_Add					:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		NAT_MPEU_Cnt					:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		NAT_MPEU_data_out				:	OUT	std_logic_vector(P_word_size-1   DOWNTO 0);
		NAT_MPEU_data_rdy				:	OUT	std_logic;
		NAT_MPEU_data_in				:	IN	std_logic_vector(P_word_size-1   DOWNTO 0);
		NAT_MPEU_data_wen				:	IN	std_logic;
	
		--	OUT GATE	To	VC	(Master IN top Level)
		OGM_2VCU_req					:	OUT	std_logic;
		OGM_2VCU_grant					:	IN	std_logic;
		OGM_2VCU_done					:	IN	std_logic;
		OGM_2VCU_wait					:	IN	std_logic;
		OGM_2VCU_read					:	OUT	std_logic;
		OGM_2VCU_write					:	OUT	std_logic;
		OGM_2VCU_Add					:	OUT	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		OGM_2VCU_Cnt					:	OUT	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		OGM_2VCU_MD_in					:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2VCU_MD_in_rdy				:	IN	std_logic;
		OGM_2VCU_MD_out					:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2VCU_MD_out_rdy				:	OUT	std_logic;
		--	OUT GATE	To	GMN	(Master IN top Level)
		OGM_2GMN_req					:	OUT	std_logic;
		OGM_2GMN_grant					:	IN	std_logic;
		OGM_2GMN_done					:	IN	std_logic;
		OGM_2GMN_wait					:	IN	std_logic;
		OGM_2GMN_read					:	OUT	std_logic;
		OGM_2GMN_write					:	OUT	std_logic;
		OGM_2GMN_Add					:	OUT	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		OGM_2GMN_Cnt					:	OUT	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		OGM_2GMN_MD_in					:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2GMN_MD_in_rdy				:	IN	std_logic;
		OGM_2GMN_MD_out					:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		OGM_2GMN_MD_out_rdy				:	OUT	std_logic;
		--	IN GATE		TO	GMN	(Slave IN top Level)
		IGM_2GMN_CS						:	IN	std_logic;
		IGM_2GMN_done					:	OUT	std_logic;
		IGM_2GMN_wait					:	OUT	std_logic;
		IGM_2GMN_read					:	IN	std_logic;
		IGM_2GMN_write					:	IN	std_logic;
		IGM_2GMN_Add					:	IN	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		IGM_2GMN_Cnt					:	IN	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		IGM_2GMN_SD_out					:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		IGM_2GMN_SD_out_rdy				:	OUT	std_logic;
		IGM_2GMN_SD_in					:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		IGM_2GMN_SD_in_rdy				:	IN	std_logic;
		--	DMA	Transaction Port
		TR_start						:	IN	std_logic;
		TR_ready						:	OUT	std_logic;
		TR_R_Add						:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		TR_R_Cnt						:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		TR_W_Add						:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		TR_W_Cnt						:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0));
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
END LMN;

architecture Behavioral of LMN is
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	COMPONENT	LMN_Master
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	BUS Side		
		BUS_req							:	OUT	std_logic;
		BUS_grant						:	IN	std_logic;
		BUS_done						:	IN	std_logic;
		BUS_wait						:	IN	std_logic;
		BUS_read						:	OUT	std_logic;
		BUS_write						:	OUT	std_logic;
		BUS_Add							:	OUT	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		BUS_Cnt							:	OUT	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		BUS_MD_in						:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		BUS_MD_in_rdy					:	IN	std_logic;
		BUS_MD_out						:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		BUS_MD_out_rdy					:	OUT	std_logic;
		--	Native side		
		NAT_ready						:	OUT	std_logic;
		NAT_wait						:	OUT	std_logic;
		NAT_push						:	IN	std_logic;
		NAT_ack							:	OUT	std_logic;
		NAT_read						:	IN	std_logic;
		NAT_write						:	IN	std_logic;
		NAT_Add							:	IN	std_logic_vector(P_Phy_Add_size-1	DOWNTO 0);
		NAT_Cnt							:	IN	std_logic_vector(P_Phy_Cnt_size-1	DOWNTO 0);
		NAT_data_out					:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0);
		NAT_data_rdy					:	OUT	std_logic;
		NAT_data_in						:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		NAT_data_wen					:	IN	std_logic);
	END COMPONENT;
	--------------------------------------------------------------------------------------
	COMPONENT	LMN_Mem_IF
	GENERIC(
		mem_depth						:	INTEGER	:=	1024);
	PORT(		
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		BUS_CS							:	IN	std_logic;
		BUS_done						:	OUT	std_logic;
		BUS_wait						:	OUT	std_logic;
		BUS_read						:	IN	std_logic;
		BUS_write						:	IN	std_logic;
		BUS_Add							:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		BUS_Cnt							:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		BUS_SD_in						:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		BUS_SD_in_rdy					:	IN	std_logic;
		BUS_SD_out						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		BUS_SD_out_rdy					:	OUT	std_logic;
		MEM_Add							:	OUT	std_logic_vector(integer(ceil(log2(real(mem_depth))))-1 DOWNTO 0);
		MEM_wen							:	OUT	std_logic;
		MEM_Din							:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		MEM_Dout						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	COMPONENT	LMN_memory_2_P
	GENERIC(
		depth							:	INTEGER	:=	1024;
		size							:	INTEGER	:=	P_word_size);
	PORT(		
		clk								:	IN	std_logic;
		MEM_1_Add						:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_1_wen						:	IN	std_logic;
		MEM_1_Dout						:	OUT	std_logic_vector(size-1 DOWNTO 0);
		MEM_1_Din						:	IN	std_logic_vector(size-1 DOWNTO 0);
		MEM_2_Add						:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_2_wen						:	IN	std_logic;
		MEM_2_Dout						:	OUT	std_logic_vector(size-1 DOWNTO 0);
		MEM_2_Din						:	IN	std_logic_vector(size-1 DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	COMPONENT	LMN_Gate
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	Slave BUS Side  (local)
		SBUS_CS							:	IN	std_logic;
		SBUS_done						:	OUT	std_logic;
		SBUS_wait						:	OUT	std_logic;
		SBUS_read						:	IN	std_logic;
		SBUS_write						:	IN	std_logic;
		SBUS_Add						:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		SBUS_Cnt						:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		SBUS_SD_out						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		SBUS_SD_out_rdy					:	OUT	std_logic;
		SBUS_SD_in						:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		SBUS_SD_in_rdy					:	IN	std_logic;
		--	Master BUS Side	(global)
		MBUS_req						:	OUT	std_logic;
		MBUS_grant						:	IN	std_logic;
		MBUS_done						:	IN	std_logic;
		MBUS_wait						:	IN	std_logic;
		MBUS_read						:	OUT	std_logic;
		MBUS_write						:	OUT	std_logic;
		MBUS_Add						:	OUT	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		MBUS_Cnt						:	OUT	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		MBUS_MD_in						:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		MBUS_MD_in_rdy					:	IN	std_logic;
		MBUS_MD_out						:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		MBUS_MD_out_rdy					:	OUT	std_logic);
	END COMPONENT;
	--------------------------------------------------------------------------------------
	COMPONENT	LMN_Arbiter_Fixed_way_complete
	GENERIC(
		MASTER_CNT						:	INTEGER	:=	7;
		SLAVE_CNT						:	INTEGER	:=	7;
		SM_size							:	INTEGER	:=	3;
		ways							:	INTEGER	:=	7;
		Name							:	STRING	:=	"name");
	PORT(	
		clk								:	IN	std_logic;
		rst								:	IN	std_logic; 
		--	Master Port	
		Master_Address					:	IN	Unc_1D_P_Addr_array	(MASTER_CNT-1	DOWNTO 0);
		Master_req						:	IN	Unc_1D_array		(MASTER_CNT-1	DOWNTO 0);
		Master_grant					:	OUT	Unc_1D_array		(MASTER_CNT-1	DOWNTO 0);
		Master_MSM						:	OUT	Unc_2D_array		(MASTER_CNT-1	DOWNTO 0,	SM_size-1	DOWNTO 0);
		--	Slave Port	
		Slave_min_add					:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-2	DOWNTO 0);
		Slave_max_add					:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-2	DOWNTO 0);
		Slave_CS						:	OUT	Unc_1D_array		(SLAVE_CNT-1	DOWNTO 0);
		Slave_SSM						:	OUT	Unc_2D_array		(SLAVE_CNT-1	DOWNTO 0,	SM_size-1	DOWNTO 0));
	END	COMPONENT;
	--------------------------------------------------------------------------------------
	COMPONENT	GMN_pass_DAM
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	Master Port (read)
		MR_req							:	OUT	std_logic;
		MR_grant						:	IN	std_logic;
		MR_done							:	IN	std_logic;
		MR_wait							:	IN	std_logic;
		MR_read							:	OUT	std_logic;
		MR_write						:	OUT	std_logic;
		MR_Add							:	OUT	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		MR_Cnt							:	OUT	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		MR_Din							:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		MR_Din_rdy						:	IN	std_logic;
		MR_Dout							:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		MR_Dout_rdy						:	OUT	std_logic;
		--	Master Port (write)
		MW_req							:	OUT	std_logic;
		MW_grant						:	IN	std_logic;
		MW_done							:	IN	std_logic;
		MW_wait							:	IN	std_logic;
		MW_read							:	OUT	std_logic;
		MW_write						:	OUT	std_logic;
		MW_Add							:	OUT	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		MW_Cnt							:	OUT	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		MW_Din							:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		MW_Din_rdy						:	IN	std_logic;
		MW_Dout							:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		MW_Dout_rdy						:	OUT	std_logic;
		--	Transaction	req
		TR_start						:	IN	std_logic;
		TR_ready						:	OUT	std_logic;
		TR_R_Add						:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		TR_R_Cnt						:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0);
		TR_W_Add						:	IN	std_logic_vector(P_Phy_Add_size-1 DOWNTO 0);
		TR_W_Cnt						:	IN	std_logic_vector(P_Phy_Cnt_size-1 DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	CONSTANT	NOM						:	INTEGER	:=	(2*P_Number_of_Planes)+4;
	CONSTANT	NOS						:	INTEGER	:=	4;
	CONSTANT	SM_size					:	INTEGER	:= integer(ceil(log2(real(max(NOM, NOS)))));
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	SIGNAL	MSB_req						:	Unc_1D_array		(NOM-1	DOWNTO	0);
	SIGNAL	MSB_grant					:	Unc_1D_array		(NOM-1	DOWNTO	0);
	SIGNAL	MSB_done					:	Unc_1D_array		(NOM-1	DOWNTO	0);
	SIGNAL	MSB_wait					:	Unc_1D_array		(NOM-1	DOWNTO	0);
	SIGNAL	MSB_read					:	Unc_1D_array		(NOM-1	DOWNTO	0);
	SIGNAL	MSB_write					:	Unc_1D_array		(NOM-1	DOWNTO	0);
	SIGNAL	MSB_Add						:	Unc_1D_P_Addr_array	(NOM-1	DOWNTO	0);
	SIGNAL	MSB_Cnt						:	Unc_1D_P_Cont_array	(NOM-1	DOWNTO	0);
	SIGNAL	MSB_Din						:	Unc_1D_P_Data_array	(NOM-1	DOWNTO	0);
	SIGNAL	MSB_Din_rdy					:	Unc_1D_array		(NOM-1	DOWNTO	0);
	SIGNAL	MSB_Dout					:	Unc_1D_P_Data_array	(NOM-1	DOWNTO	0);
	SIGNAL	MSB_Dout_rdy				:	Unc_1D_array		(NOM-1	DOWNTO	0);
	--------------------------------------------------------------------------------------
	SIGNAL	SSB_CS						:	Unc_1D_array		(NOS-1	DOWNTO	0);
	SIGNAL	SSB_done					:	Unc_1D_array		(NOS-1	DOWNTO	0);
	SIGNAL	SSB_wait					:	Unc_1D_array		(NOS-1	DOWNTO	0);
	SIGNAL	SSB_read					:	Unc_1D_array		(NOS-1	DOWNTO	0);
	SIGNAL	SSB_write					:	Unc_1D_array		(NOS-1	DOWNTO	0);
	SIGNAL	SSB_Add						:	Unc_1D_P_Addr_array	(NOS-1	DOWNTO	0);
	SIGNAL	SSB_Cnt						:	Unc_1D_P_Cont_array	(NOS-1	DOWNTO	0);
	SIGNAL	SSB_Din						:	Unc_1D_P_Data_array	(NOS-1	DOWNTO	0);
	SIGNAL	SSB_Din_rdy					:	Unc_1D_array		(NOS-1	DOWNTO	0);
	SIGNAL	SSB_Dout					:	Unc_1D_P_Data_array	(NOS-1	DOWNTO	0);
	SIGNAL	SSB_Dout_rdy				:	Unc_1D_array		(NOS-1	DOWNTO	0);
	--------------------------------------------------------------------------------------
	SIGNAL	MEM_P0_Add					:	std_logic_vector	(P_LMN_Mem_Add_width-1			DOWNTO 0);
	SIGNAL	MEM_P0_wen					:	std_logic;		
	SIGNAL	MEM_P0_Din					:	std_logic_vector	(P_word_size-1					DOWNTO 0);
	SIGNAL	MEM_P0_Dout					:	std_logic_vector	(P_word_size-1					DOWNTO 0);
	SIGNAL	MEM_P1_Add					:	std_logic_vector	(P_LMN_Mem_Add_width-1			DOWNTO 0);
	SIGNAL	MEM_P1_wen					:	std_logic;	
	SIGNAL	MEM_P1_Din					:	std_logic_vector	(P_word_size-1					DOWNTO 0);
	SIGNAL	MEM_P1_Dout					:	std_logic_vector	(P_word_size-1					DOWNTO 0);
	--------------------------------------------------------------------------------------
	SIGNAL	Arb_M_MSM					:	Unc_2D_array		(NOM-1	DOWNTO 0,	SM_size-1	DOWNTO 0);
	SIGNAL	Arb_S_SSM					:	Unc_2D_array		(NOS-1	DOWNTO 0,	SM_size-1	DOWNTO 0);
	SIGNAL	MSB_MSM						:	Unc_1D_3bit_array	(NOM-1	DOWNTO 0);
	SIGNAL	SSB_SSM						:	Unc_1D_3bit_array	(NOS-1	DOWNTO 0);
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	NATIVE_UPA_PLANE_GEN				:	FOR	p	IN	P_Number_of_Planes-1	DOWNTO	0	GENERATE
		NAT_UPA_Master					:	LMN_Master
		PORT	MAP(
			clk							=>	clk,
			rst							=>	rst,
			--	BUS Side
			BUS_req						=>	MSB_req					(2*P),
			BUS_grant					=>	MSB_grant				(2*P),
			BUS_done					=>	MSB_done				(2*P),
			BUS_wait					=>	MSB_wait				(2*P),
			BUS_read					=>	MSB_read				(2*P),
			BUS_write					=>	MSB_write				(2*P),
			BUS_Add						=>	MSB_Add					(2*P),
			BUS_Cnt						=>	MSB_Cnt					(2*P),
			BUS_MD_in					=>	MSB_Din					(2*P),
			BUS_MD_in_rdy				=>	MSB_Din_rdy				(2*P),
			BUS_MD_out					=>	MSB_Dout				(2*P),
			BUS_MD_out_rdy				=>	MSB_Dout_rdy			(2*P),
			--	Native side		
			NAT_ready					=>	NAT_UPA_ready			(p),
			NAT_wait					=>	NAT_UPA_wait			(p),
			NAT_push					=>	NAT_UPA_push			(p),
			NAT_ack						=>	NAT_UPA_ack				(p),
			NAT_read					=>	NAT_UPA_read			(p),
			NAT_write					=>	NAT_UPA_write			(p),
			NAT_Add						=>	NAT_UPA_Add				(p),
			NAT_Cnt						=>	NAT_UPA_Cnt				(p),
			NAT_data_out				=>	NAT_UPA_data_out		(p),
			NAT_data_rdy				=>	NAT_UPA_data_rdy		(p),
			NAT_data_in					=>	NAT_UPA_data_in			(p),
			NAT_data_wen				=>	NAT_UPA_data_wen		(p));
		--------------------------------------------------------------------------------------
		NAT_STA_Master					:	LMN_Master
		PORT	MAP(
			clk							=>	clk,
			rst							=>	rst,
			--	BUS Side
			BUS_req						=>	MSB_req					(2*P+1),
			BUS_grant					=>	MSB_grant				(2*P+1),
			BUS_done					=>	MSB_done				(2*P+1),
			BUS_wait					=>	MSB_wait				(2*P+1),
			BUS_read					=>	MSB_read				(2*P+1),
			BUS_write					=>	MSB_write				(2*P+1),
			BUS_Add						=>	MSB_Add					(2*P+1),
			BUS_Cnt						=>	MSB_Cnt					(2*P+1),
			BUS_MD_in					=>	MSB_Din					(2*P+1),
			BUS_MD_in_rdy				=>	MSB_Din_rdy				(2*P+1),
			BUS_MD_out					=>	MSB_Dout				(2*P+1),
			BUS_MD_out_rdy				=>	MSB_Dout_rdy			(2*P+1),
			--	Native side		
			NAT_ready					=>	NAT_STA_ready			(p),
			NAT_wait					=>	NAT_STA_wait			(p),
			NAT_push					=>	NAT_STA_push			(p),
			NAT_ack						=>	NAT_STA_ack				(p),
			NAT_read					=>	NAT_STA_read			(p),
			NAT_write					=>	NAT_STA_write			(p),
			NAT_Add						=>	NAT_STA_Add				(p),
			NAT_Cnt						=>	NAT_STA_Cnt				(p),
			NAT_data_out				=>	NAT_STA_data_out		(p),
			NAT_data_rdy				=>	NAT_STA_data_rdy		(p),
			NAT_data_in					=>	NAT_STA_data_in			(p),
			NAT_data_wen				=>	NAT_STA_data_wen		(p));
	END	GENERATE;
	--------------------------------------------------------------------------------------
	NAT_MPE_Master						:	LMN_Master
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	BUS Side
		BUS_req							=>	MSB_req					(2*P_Number_of_Planes),
		BUS_grant						=>	MSB_grant				(2*P_Number_of_Planes),
		BUS_done						=>	MSB_done				(2*P_Number_of_Planes),
		BUS_wait						=>	MSB_wait				(2*P_Number_of_Planes),
		BUS_read						=>	MSB_read				(2*P_Number_of_Planes),
		BUS_write						=>	MSB_write				(2*P_Number_of_Planes),
		BUS_Add							=>	MSB_Add					(2*P_Number_of_Planes),
		BUS_Cnt							=>	MSB_Cnt					(2*P_Number_of_Planes),
		BUS_MD_in						=>	MSB_Din					(2*P_Number_of_Planes),
		BUS_MD_in_rdy					=>	MSB_Din_rdy				(2*P_Number_of_Planes),
		BUS_MD_out						=>	MSB_Dout				(2*P_Number_of_Planes),
		BUS_MD_out_rdy					=>	MSB_Dout_rdy			(2*P_Number_of_Planes),
		--	Native side
		NAT_ready						=>	NAT_MPEU_ready,
		NAT_wait						=>	NAT_MPEU_wait,
		NAT_push						=>	NAT_MPEU_push,
		NAT_ack							=>	NAT_MPEU_ack,
		NAT_read						=>	NAT_MPEU_read,
		NAT_write						=>	NAT_MPEU_write,
		NAT_Add							=>	NAT_MPEU_Add,
		NAT_Cnt							=>	NAT_MPEU_Cnt,
		NAT_data_out					=>	NAT_MPEU_data_out,
		NAT_data_rdy					=>	NAT_MPEU_data_rdy,
		NAT_data_in						=>	NAT_MPEU_data_in	,
		NAT_data_wen					=>	NAT_MPEU_data_wen);
	--------------------------------------------------------------------------------------
	OGM_2VCU							:	LMN_Gate
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Slave BUS Side  (local)
		SBUS_CS							=>	SSB_CS			(2),
		SBUS_done						=>	SSB_done		(2),
		SBUS_wait						=>	SSB_wait		(2),
		SBUS_read						=>	SSB_read		(2),
		SBUS_write						=>	SSB_write		(2),
		SBUS_Add						=>	SSB_Add			(2),
		SBUS_Cnt						=>	SSB_Cnt			(2),
		SBUS_SD_out						=>	SSB_Dout		(2),
		SBUS_SD_out_rdy					=>	SSB_Dout_rdy	(2),
		SBUS_SD_in						=>	SSB_Din			(2),
		SBUS_SD_in_rdy					=>	SSB_Din_rdy		(2),
		--	Master BUS Side	(global)
		MBUS_req						=>	OGM_2VCU_req,
		MBUS_grant						=>	OGM_2VCU_grant,
		MBUS_done						=>	OGM_2VCU_done,
		MBUS_wait						=>	OGM_2VCU_wait,
		MBUS_read						=>	OGM_2VCU_read,
		MBUS_write						=>	OGM_2VCU_write,
		MBUS_Add						=>	OGM_2VCU_Add,
		MBUS_Cnt						=>	OGM_2VCU_Cnt,
		MBUS_MD_in						=>	OGM_2VCU_MD_in,
		MBUS_MD_in_rdy					=>	OGM_2VCU_MD_in_rdy,
		MBUS_MD_out						=>	OGM_2VCU_MD_out,
		MBUS_MD_out_rdy					=>	OGM_2VCU_MD_out_rdy);
	--------------------------------------------------------------------------------------
	OGM_2GMN							:	LMN_Gate
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Slave BUS Side  (local)
		SBUS_CS							=>	SSB_CS			(3),
		SBUS_done						=>	SSB_done		(3),
		SBUS_wait						=>	SSB_wait		(3),
		SBUS_read						=>	SSB_read		(3),
		SBUS_write						=>	SSB_write		(3),
		SBUS_Add						=>	SSB_Add			(3),
		SBUS_Cnt						=>	SSB_Cnt			(3),
		SBUS_SD_out						=>	SSB_Dout		(3),
		SBUS_SD_out_rdy					=>	SSB_Dout_rdy	(3),
		SBUS_SD_in						=>	SSB_Din			(3),
		SBUS_SD_in_rdy					=>	SSB_Din_rdy		(3),
		--	Master BUS Side	(global)
		MBUS_req						=>	OGM_2GMN_req,
		MBUS_grant						=>	OGM_2GMN_grant,
		MBUS_done						=>	OGM_2GMN_done,
		MBUS_wait						=>	OGM_2GMN_wait,
		MBUS_read						=>	OGM_2GMN_read,
		MBUS_write						=>	OGM_2GMN_write,
		MBUS_Add						=>	OGM_2GMN_Add,
		MBUS_Cnt						=>	OGM_2GMN_Cnt,
		MBUS_MD_in						=>	OGM_2GMN_MD_in,
		MBUS_MD_in_rdy					=>	OGM_2GMN_MD_in_rdy,
		MBUS_MD_out						=>	OGM_2GMN_MD_out,
		MBUS_MD_out_rdy					=>	OGM_2GMN_MD_out_rdy);
	--------------------------------------------------------------------------------------
	IGM_2GMN							:	LMN_Gate
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Slave BUS Side  (local)
		SBUS_CS							=>	IGM_2GMN_CS,
		SBUS_done						=>	IGM_2GMN_done,
		SBUS_wait						=>	IGM_2GMN_wait,
		SBUS_read						=>	IGM_2GMN_read,
		SBUS_write						=>	IGM_2GMN_write,
		SBUS_Add						=>	IGM_2GMN_Add,
		SBUS_Cnt						=>	IGM_2GMN_Cnt,
		SBUS_SD_out						=>	IGM_2GMN_SD_out,
		SBUS_SD_out_rdy					=>	IGM_2GMN_SD_out_rdy,
		SBUS_SD_in						=>	IGM_2GMN_SD_in,
		SBUS_SD_in_rdy					=>	IGM_2GMN_SD_in_rdy,
		--	Master BUS Side	(global)
		MBUS_req						=>	MSB_req			(2*P_Number_of_Planes+3),
		MBUS_grant						=>	MSB_grant		(2*P_Number_of_Planes+3),
		MBUS_done						=>	MSB_done		(2*P_Number_of_Planes+3),
		MBUS_wait						=>	MSB_wait		(2*P_Number_of_Planes+3),
		MBUS_read						=>	MSB_read		(2*P_Number_of_Planes+3),
		MBUS_write						=>	MSB_write		(2*P_Number_of_Planes+3),
		MBUS_Add						=>	MSB_Add			(2*P_Number_of_Planes+3),
		MBUS_Cnt						=>	MSB_Cnt			(2*P_Number_of_Planes+3),
		MBUS_MD_in						=>	MSB_Din			(2*P_Number_of_Planes+3),
		MBUS_MD_in_rdy					=>	MSB_Din_rdy		(2*P_Number_of_Planes+3),
		MBUS_MD_out						=>	MSB_Dout		(2*P_Number_of_Planes+3),
		MBUS_MD_out_rdy					=>	MSB_Dout_rdy	(2*P_Number_of_Planes+3));
	--------------------------------------------------------------------------------------
	DMA									:	GMN_pass_DAM
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Master Port (read)
		MR_req							=>	MSB_req			(2*P_Number_of_Planes+1),
		MR_grant						=>	MSB_grant		(2*P_Number_of_Planes+1),
		MR_done							=>	MSB_done		(2*P_Number_of_Planes+1),
		MR_wait							=>	MSB_wait		(2*P_Number_of_Planes+1),
		MR_read							=>	MSB_read		(2*P_Number_of_Planes+1),
		MR_write						=>	MSB_write		(2*P_Number_of_Planes+1),
		MR_Add							=>	MSB_Add			(2*P_Number_of_Planes+1),
		MR_Cnt							=>	MSB_Cnt			(2*P_Number_of_Planes+1),
		MR_Din							=>	MSB_Din			(2*P_Number_of_Planes+1),
		MR_Din_rdy						=>	MSB_Din_rdy		(2*P_Number_of_Planes+1),
		MR_Dout							=>	MSB_Dout		(2*P_Number_of_Planes+1),
		MR_Dout_rdy						=>	MSB_Dout_rdy	(2*P_Number_of_Planes+1),
		--	Master Port (write)
		MW_req							=>	MSB_req			(2*P_Number_of_Planes+2),
		MW_grant						=>	MSB_grant		(2*P_Number_of_Planes+2),
		MW_done							=>	MSB_done		(2*P_Number_of_Planes+2),
		MW_wait							=>	MSB_wait		(2*P_Number_of_Planes+2),
		MW_read							=>	MSB_read		(2*P_Number_of_Planes+2),
		MW_write						=>	MSB_write		(2*P_Number_of_Planes+2),
		MW_Add							=>	MSB_Add			(2*P_Number_of_Planes+2),
		MW_Cnt							=>	MSB_Cnt			(2*P_Number_of_Planes+2),
		MW_Din							=>	MSB_Din			(2*P_Number_of_Planes+2),
		MW_Din_rdy						=>	MSB_Din_rdy		(2*P_Number_of_Planes+2),
		MW_Dout							=>	MSB_Dout		(2*P_Number_of_Planes+2),
		MW_Dout_rdy						=>	MSB_Dout_rdy	(2*P_Number_of_Planes+2),
		--	Transaction	req
		TR_start						=>	TR_start,
		TR_ready						=>	TR_ready,
		TR_R_Add						=>	TR_R_Add,
		TR_R_Cnt						=>	TR_R_Cnt,
		TR_W_Add						=>	TR_W_Add,
		TR_W_Cnt						=>	TR_W_Cnt);
	--------------------------------------------------------------------------------------
	Mem_Port_0_IF						:	LMN_Mem_IF
	GENERIC	MAP(
		mem_depth						=>	2**P_LMN_Mem_Add_width)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	BUS
		BUS_CS							=>	SSB_CS			(0),
		BUS_done						=>	SSB_done		(0),
		BUS_wait						=>	SSB_wait		(0),
		BUS_read						=>	SSB_read		(0),
		BUS_write						=>	SSB_write		(0),
		BUS_Add							=>	SSB_Add			(0),
		BUS_Cnt							=>	SSB_Cnt			(0),
		BUS_SD_in						=>	SSB_Din			(0),
		BUS_SD_in_rdy					=>	SSB_Din_rdy		(0),
		BUS_SD_out						=>	SSB_Dout		(0),
		BUS_SD_out_rdy					=>	SSB_Dout_rdy	(0),
		--	MEM
		MEM_Add							=>	MEM_P0_Add,
		MEM_wen							=>	MEM_P0_wen,
		MEM_Din							=>	MEM_P0_Din,
		MEM_Dout						=>	MEM_P0_Dout);
	--------------------------------------------------------------------------------------
	Mem_Port_1_IF						:	LMN_Mem_IF
	GENERIC	MAP(
		mem_depth						=>	2**P_LMN_Mem_Add_width)
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	BUS
		BUS_CS							=>	SSB_CS			(1),
		BUS_done						=>	SSB_done		(1),
		BUS_wait						=>	SSB_wait		(1),
		BUS_read						=>	SSB_read		(1),
		BUS_write						=>	SSB_write		(1),
		BUS_Add							=>	SSB_Add			(1),
		BUS_Cnt							=>	SSB_Cnt			(1),
		BUS_SD_in						=>	SSB_Din			(1),
		BUS_SD_in_rdy					=>	SSB_Din_rdy		(1),
		BUS_SD_out						=>	SSB_Dout		(1),
		BUS_SD_out_rdy					=>	SSB_Dout_rdy	(1),
		--	MEM
		MEM_Add							=>	MEM_P1_Add,
		MEM_wen							=>	MEM_P1_wen,
		MEM_Din							=>	MEM_P1_Din,
		MEM_Dout						=>	MEM_P1_Dout);
	--------------------------------------------------------------------------------------
	MEMORY								:	LMN_memory_2_P
	GENERIC	MAP(
		depth							=>	2**P_LMN_Mem_Add_width,
		size							=>	P_word_size)
	PORT	MAP(	
		clk								=>	clk,
		MEM_1_Add						=>	MEM_P0_Add,
		MEM_1_wen						=>	MEM_P0_wen,
		MEM_1_Dout						=>	MEM_P0_Din,
		MEM_1_Din						=>	MEM_P0_Dout,
		MEM_2_Add						=>	MEM_P1_Add,
		MEM_2_wen						=>	MEM_P1_wen,
		MEM_2_Dout						=>	MEM_P1_Din,
		MEM_2_Din						=>	MEM_P1_Dout);
	--------------------------------------------------------------------------------------
	Arbiter								:	LMN_Arbiter_Fixed_way_complete
	GENERIC	MAP(
		MASTER_CNT						=>	NOM,
		SLAVE_CNT						=>	NOS,
		SM_size							=>	SM_size,
		ways							=>	P_LMN_Number_of_ways,
		Name							=>	"LMN_Arb")
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		--	Master Port
		Master_Address					=>	MSB_Add,
		Master_req						=>	MSB_req,
		Master_grant					=>	MSB_grant,
		Master_MSM						=>	Arb_M_MSM,
		--	Slave Port
		Slave_min_add					=>	P_LMN_MMAP(LMN_ROW_POS,	LMN_COL_POS, 0),
		Slave_max_add					=>	P_LMN_MMAP(LMN_ROW_POS,	LMN_COL_POS, 1),
		Slave_CS						=>	SSB_CS,
		Slave_SSM						=>	Arb_S_SSM);
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	Arb_master_encode					:	FOR i IN NOM-1		DOWNTO 0 GENERATE
		Arb_MSM_encode					:	FOR j IN SM_size-1	DOWNTO 0 GENERATE
			MSB_MSM(i)(j)				<=	Arb_M_MSM(i,j);
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------------------
	Arb_slave_encode					:	FOR i IN NOS-1		DOWNTO 0 GENERATE
		Arb_SSM_encode					:	FOR j IN SM_size-1	DOWNTO 0 GENERATE
			SSB_SSM(i)(j)				<=	Arb_S_SSM(i,j);
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------------------
	PROCESS (	MSB_MSM,	SSB_SSM,	MSB_read,	MSB_write,		MSB_Add,	SSB_Dout,
				MSB_Cnt,	MSB_Dout,	MSB_Dout_rdy,	SSB_done,	SSB_wait,	SSB_Dout_rdy)
	BEGIN
		----------------------------------------------------------------------------------
		FOR	i	IN NOM-1	DOWNTO	0	LOOP
			MSB_done	(i)				<=	SSB_done	(my_to_uint(MSB_MSM(i)));
			MSB_wait	(i)				<=	SSB_wait	(my_to_uint(MSB_MSM(i)));
			MSB_Din		(i)				<=	SSB_Dout	(my_to_uint(MSB_MSM(i)));
			MSB_Din_rdy	(i)				<=	SSB_Dout_rdy(my_to_uint(MSB_MSM(i)));
		END LOOP;
		----------------------------------------------------------------------------------
		FOR	i	IN NOS-1	DOWNTO	0	LOOP
			SSB_read	(i)				<=	MSB_read	(my_to_uint(SSB_SSM(i)));
			SSB_write	(i)				<=	MSB_write	(my_to_uint(SSB_SSM(i)));
			SSB_Add		(i)				<=	MSB_Add		(my_to_uint(SSB_SSM(i)));
			SSB_Cnt		(i)				<=	MSB_Cnt		(my_to_uint(SSB_SSM(i)));
			SSB_Din		(i)				<=	MSB_Dout	(my_to_uint(SSB_SSM(i)));
			SSB_Din_rdy	(i)				<=	MSB_Dout_rdy(my_to_uint(SSB_SSM(i)));
		END LOOP;
		----------------------------------------------------------------------------------
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
END Behavioral;
	
	
	
	
	
	
