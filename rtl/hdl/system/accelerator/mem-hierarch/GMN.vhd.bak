library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity GMN is
	PORT(
		clk_w							:	std_logic;
		rst_w							:	std_logic;
		
		--	LMN IN Gates' Slave
		GMN_S_CS						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_done						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_wait						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_read						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_write						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_Add						:	OUT	Unc_1D_P_Addr_array		(15 DOWNTO 0);
		GMN_S_Cnt						:	OUT	Unc_1D_P_Cont_array		(15 DOWNTO 0);
		GMN_S_Dout						:	IN	Unc_1D_P_Data_array		(15 DOWNTO 0);
		GMN_S_Dout_rdy					:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_S_Din						:	OUT	Unc_1D_P_Data_array		(15 DOWNTO 0);
		GMN_S_Din_rdy					:	OUT	Unc_1D_array			(15 DOWNTO 0);
		
		--	LMN	Out Gates' Master
		GMN_M_req						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_grant						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_done						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_wait						:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_read						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_write						:	IN	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_Add						:	IN	Unc_1D_P_Addr_array		(15 DOWNTO 0);
		GMN_M_Cnt						:	IN	Unc_1D_P_Cont_array		(15 DOWNTO 0);
		GMN_M_Din						:	OUT	Unc_1D_P_Data_array		(15 DOWNTO 0);
		GMN_M_Din_rdy					:	OUT	Unc_1D_array			(15 DOWNTO 0);
		GMN_M_Dout						:	IN	Unc_1D_P_Data_array		(15 DOWNTO 0);
		GMN_M_Dout_rdy					:	IN	Unc_1D_array			(15 DOWNTO 0));
end GMN;

architecture Behavioral of GMN is
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	COMPONENT	LMN_Arbiter_Fixed_way_double_address
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
		Slave_min_add_1					:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_max_add_1					:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_min_add_2					:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_max_add_2					:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_CS						:	OUT	Unc_1D_array		(SLAVE_CNT-1	DOWNTO 0);
		Slave_SSM						:	OUT	Unc_2D_array		(SLAVE_CNT-1	DOWNTO 0,	SM_size-1	DOWNTO 0));
	END	COMPONENT;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	SIGNAL	Arb_MSM						:	Unc_2D_array(15 DOWNTO 0,	3 DOWNTO 0);
	SIGNAL	Arb_SSM						:	Unc_2D_array(15 DOWNTO 0,	3 DOWNTO 0);
	--------------------------------------------------------------------------------------
	SIGNAL	Mst_MSM						:	Unc_1D_4bit_array	(15	DOWNTO 0);
	SIGNAL	Slv_SSM						:	Unc_1D_4bit_array	(15	DOWNTO 0);
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	Arbiter								:	LMN_Arbiter_Fixed_way_double_address
	GENERIC	MAP(		
		MASTER_CNT						=>	16,
		SLAVE_CNT						=>	16,
		SM_size							=>	4,
		ways							=>	P_GMN_Number_of_ways,
		Name							=>	"GMN_Arb") 
	PORT	MAP(		
		clk								=>	clk_w,
		rst								=>	rst_w,
		Master_Address					=>	GMN_M_Add,
		Master_req						=>	GMN_M_req,
		Master_grant					=>	GMN_M_grant,
		Master_MSM						=>	Arb_MSM,
		Slave_min_add_1					=>	P_GMN_MMAP_Min_1,
		Slave_max_add_1					=>	P_GMN_MMAP_Max_1,
		Slave_min_add_2					=>	P_GMN_MMAP_Min_2,
		Slave_max_add_2					=>	P_GMN_MMAP_Max_2,
		Slave_CS						=>	GMN_S_CS,
		Slave_SSM						=>	Arb_SSM);
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	Arb_Master_Side_Gen					:	FOR	i	IN	15	DOWNTO	0	GENERATE
		Arb_MS_MSM_gen					:	FOR	j	IN	3	DOWNTO	0	GENERATE
			Mst_MSM		(i)(j)			<=	Arb_MSM			(i, j);
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------------------
	Arb_Slave_Side_Gen					:	FOR	i	IN	15	DOWNTO	0	GENERATE
		Arb_SS_SSM_gen					:	FOR	j	IN	3	DOWNTO	0	GENERATE
			Slv_SSM		(i)(j)			<=	Arb_SSM			(i, j);
		END GENERATE;
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	Master_Side_Connection				:	FOR	i	IN	15	DOWNTO	0	GENERATE
		GMN_M_done		(i)				<=	GMN_S_done		(my_to_uint(Mst_MSM(i)));
		GMN_M_wait		(i)				<=	GMN_S_wait		(my_to_uint(Mst_MSM(i)));
		GMN_M_Din		(i)				<=	GMN_S_Dout		(my_to_uint(Mst_MSM(i)));
		GMN_M_Din_rdy	(i)				<=	GMN_S_Dout_rdy	(my_to_uint(Mst_MSM(i)));
	END GENERATE;
	--------------------------------------------------------------------------------------
	Slave_Side_Connectoion				:	FOR	i	IN	15	DOWNTO	0	GENERATE
		GMN_S_read		(i)				<=	GMN_M_read		(my_to_uint(Slv_SSM(i)));
		GMN_S_write		(i)				<=	GMN_M_write		(my_to_uint(Slv_SSM(i)));
		GMN_S_Add		(i)				<=	GMN_M_Add		(my_to_uint(Slv_SSM(i)));
		GMN_S_Cnt		(i)				<=	GMN_M_Cnt		(my_to_uint(Slv_SSM(i)));
		GMN_S_Din		(i)				<=	GMN_M_Dout		(my_to_uint(Slv_SSM(i)));
		GMN_S_Din_rdy	(i)				<=	GMN_M_Dout_rdy	(my_to_uint(Slv_SSM(i)));
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Behavioral;

