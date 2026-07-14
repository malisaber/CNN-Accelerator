library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;
USE work.my_pack_v2.ALL;

entity LMN_Arbiter_Fixed_way_double_address is
	GENERIC(
		MASTER_CNT			:	INTEGER	:=	7;
		SLAVE_CNT			:	INTEGER	:=	7;
		SM_size				:	INTEGER	:=	3;
		ways				:	INTEGER	:=	7;
		Name				:	STRING	:=	"name");
	PORT(
		clk					:	IN	std_logic;
		rst					:	IN	std_logic; 
		--	Master Port
		Master_Address		:	IN	Unc_1D_P_Addr_array	(MASTER_CNT-1	DOWNTO 0);
		Master_req			:	IN	Unc_1D_array		(MASTER_CNT-1	DOWNTO 0);
		Master_grant		:	OUT	Unc_1D_array		(MASTER_CNT-1	DOWNTO 0);
		Master_MSM			:	OUT	Unc_2D_array		(MASTER_CNT-1	DOWNTO 0,	SM_size-1	DOWNTO 0);
		--	Slave Port
		Slave_min_add_1		:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_max_add_1		:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_min_add_2		:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_max_add_2		:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_CS			:	OUT	Unc_1D_array		(SLAVE_CNT-1	DOWNTO 0);
		Slave_SSM			:	OUT	Unc_2D_array		(SLAVE_CNT-1	DOWNTO 0,	SM_size-1	DOWNTO 0));
end LMN_Arbiter_Fixed_way_double_address;

architecture Behavioral of LMN_Arbiter_Fixed_way_double_address is
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	COMPONENT	Connector_double_mem_map_address
	GENERIC(
		MASTER_CNT			:	INTEGER	:=	15;
		SLAVE_CNT			:	INTEGER	:=	15;
		SM_size				:	INTEGER	:=	4;
		Name				:	STRING	:=	"name");
	PORT(
		clk					:	IN	std_logic;
		rst					:	IN	std_logic;
		
		stop_in				:	IN	std_logic; 
		stop_out			:	OUT	std_logic; 
		prev_bussy			:	IN	std_logic;
		this_bussy			:	OUT	std_logic;
		this_done			:	OUT	std_logic;
		aswering			:	IN	std_logic_vector	(MASTER_CNT-1	DOWNTO 0);
		taken				:	IN	std_logic_vector	(SLAVE_CNT-1	DOWNTO 0);
		
		Master_Address		:	IN	Unc_1D_P_Addr_array	(MASTER_CNT-1	DOWNTO 0);
		Master_req			:	IN	Unc_1D_array		(MASTER_CNT-1	DOWNTO 0);
		Master_grant		:	OUT	Unc_1D_array		(MASTER_CNT-1	DOWNTO 0);
		Master_MSM			:	OUT	Unc_2D_array		(MASTER_CNT-1	DOWNTO 0,	SM_size-1	DOWNTO 0);
		
		Slave_min_add_1		:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_max_add_1		:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_min_add_2		:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_max_add_2		:	IN	Unc_1D_P_Addr_array	(SLAVE_CNT-1	DOWNTO 0);
		Slave_CS			:	OUT	Unc_1D_array		(SLAVE_CNT-1	DOWNTO 0);
		Slave_SSM			:	OUT	Unc_2D_array		(SLAVE_CNT-1	DOWNTO 0,	SM_size-1	DOWNTO 0));
	END	COMPONENT;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	TYPE	MGRT			IS	ARRAY	(ways-1	DOWNTO	0) OF Unc_1D_array(MASTER_CNT-1	DOWNTO	0);
	TYPE	SCST			IS	ARRAY	(ways-1	DOWNTO	0) OF Unc_1D_array(SLAVE_CNT-1	DOWNTO	0);
	TYPE	MSMT			IS	ARRAY	(ways-1	DOWNTO	0) OF Unc_2D_array(MASTER_CNT-1	DOWNTO	0,	SM_size-1 DOWNTO 0);
	TYPE	SSMT			IS	ARRAY	(ways-1	DOWNTO	0) OF Unc_2D_array(SLAVE_CNT-1	DOWNTO	0,	SM_size-1 DOWNTO 0);
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	SIGNAL	con_grant		:	MGRT;
	SIGNAL	con_cs			:	SCST;
	SIGNAL	con_MSM			:	MSMT;
	SIGNAL	con_SSM			:	SSMT;
	--------------------------------------------------------------------------------------
	SIGNAL	G_stop			:	std_logic; 
	SIGNAL	L_stop			:	std_logic_vector(ways-1 DOWNTO 0); 
	SIGNAL	this_bussy		:	std_logic_vector(ways	DOWNTO 0); 
	SIGNAL	bussy			:	std_logic_vector(ways	DOWNTO 0); 
	SIGNAL	this_done		:	std_logic_vector(ways	DOWNTO 0); 
	SIGNAL	aswering		:	std_logic_vector(MASTER_CNT-1 DOWNTO 0);
	SIGNAL	taken			:	std_logic_vector(SLAVE_CNT-1 DOWNTO 0);
	SIGNAL	starter			:	std_logic;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	connector_gen			:	FOR i IN 0 TO ways-1 GENERATE
		Connector_i			:	Connector_double_mem_map_address
		GENERIC	MAP(
			MASTER_CNT		=>	MASTER_CNT,
			SLAVE_CNT		=>	SLAVE_CNT,
			SM_size			=>	SM_size,
			Name			=>	Name)
		PORT	MAP(
			clk				=>	clk,
			rst				=>	rst,
			
			stop_in			=>	G_stop,
			stop_out		=>	L_stop(i),
			prev_bussy		=>	bussy(i),
			this_bussy		=>	this_bussy(i+1),
			this_done		=>	this_done(i+1),
			aswering		=>	aswering,
			taken			=>	taken,
			
			Master_Address	=>	Master_Address,
			Master_req		=>	Master_req,
			Master_grant	=>	con_grant(i),
			Master_MSM		=>	con_MSM(i),
			
			Slave_min_add_1	=>	Slave_min_add_1,
			Slave_max_add_1	=>	Slave_max_add_1,
			Slave_min_add_2	=>	Slave_min_add_2,
			Slave_max_add_2	=>	Slave_max_add_2,
			Slave_CS		=>	con_cs(i),
			Slave_SSM		=>	con_SSM(i));
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	start_mechanism_gen		:	FOR i IN 1 TO ways GENERATE
		PROCESS(clk, rst)
		BEGIN
			IF rst = '1' THEN
				bussy(i)		<=	'0';
			ELSIF clk = '1' AND clk'EVENT THEN
				IF this_bussy(i) = '1' THEN
					bussy(i)	<=	'1';
				ELSIF (bussy(i-1) = '0') AND (this_done(i) = '1') THEN
					bussy(i)	<=	'0';
				END IF;
			END IF;
			--WAIT ON clk, rst;
		END PROCESS;
	END GENERATE;
	starter		<=	'1'	WHEN	bussy(ways DOWNTO 1) = (ways DOWNTO 1 => '0') ELSE '0';
	bussy(0)	<=	bussy(ways) OR starter;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	PROCESS(con_grant, con_cs, con_MSM, con_SSM, L_stop)
		VARIABLE	tmp			:	std_logic;
	BEGIN
	--------------------------------------------------------------------------------------
		FOR 		i IN 0 TO MASTER_CNT-1	LOOP
			tmp					:=	'0';
			FOR 	j IN 0 TO ways-1		LOOP
				tmp				:=	tmp OR con_grant(j)(i);
			END LOOP;
			Master_grant(i)		<=	tmp;
			aswering(i)			<=	tmp;
		END LOOP;
	--------------------------------------------------------------------------------------
		FOR 		i IN 0 TO SLAVE_CNT-1	LOOP
			tmp					:=	'0';
			FOR 	j IN 0 TO ways-1		LOOP
				tmp				:=	tmp OR con_cs(j)(i);
			END LOOP;
			Slave_CS(i)			<=	tmp;
			taken(i)			<=	tmp;
		END LOOP;
	--------------------------------------------------------------------------------------
		FOR			i IN 0 TO MASTER_CNT-1	LOOP
			FOR		j IN 0 TO SM_size-1		LOOP
				tmp				:=	'0';
				FOR	k IN 0 TO ways-1		LOOP
					tmp			:=	tmp OR con_MSM(k)(i,j);
				END LOOP;
				Master_MSM(i,j)	<=	tmp;
			END LOOP;
		END LOOP;
	--------------------------------------------------------------------------------------
		FOR			i IN 0 TO SLAVE_CNT-1	LOOP
			FOR		j IN 0 TO SM_size-1		LOOP
				tmp				:=	'0';
				FOR	k IN 0 TO ways-1		LOOP
					tmp			:=	tmp OR con_SSM(k)(i,j);
				END LOOP;
				Slave_SSM(i,j)	<=	tmp;
			END LOOP;
		END LOOP;
	--------------------------------------------------------------------------------------
		tmp						:=	'0';
		FOR 		i IN 0 TO ways-1		LOOP
			tmp					:=	tmp OR L_stop(i);
		END LOOP;
		G_stop					<=	tmp;
	--------------------------------------------------------------------------------------
		--WAIT ON	con_grant, con_cs, con_MSM, con_SSM, L_stop;
	END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Behavioral;


