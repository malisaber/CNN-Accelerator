
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity Controller_v5 is
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		--	Config Signals
		CNF_FSM_sel						:	IN	std_logic_vector(1	DOWNTO 0);
		--	Status Signals
		start							:	IN	std_logic;
		CNT_PEs_PAUSE					:	IN	std_logic;
		Zpad_eq							:	IN	std_logic;
		Kern_eq							:	IN	std_logic;
		Colm_eq							:	IN	std_logic;
		Chan_eq							:	IN	std_logic;
		all_updated						:	IN	std_logic;
		CMD_STA_ACK						:	IN	std_logic;
		pipo_ready						:	IN	std_logic;
		--	Control Signals
		ini								:	OUT	std_logic;
		Zpad_inc						:	OUT	std_logic;
		Kern_inc						:	OUT	std_logic;
		Colm_inc						:	OUT	std_logic;
		Chan_inc						:	OUT	std_logic;
		Bank_inc						:	OUT	std_logic;
		SHR_enable						:	OUT	std_logic;
		SHR_clear						:	OUT	std_logic;
		PIPR_enable						:	OUT	std_logic;
		OBUF_set						:	OUT	std_logic;
		OBUF_clr						:	OUT	std_logic;
		inject_zero						:	OUT	std_logic;
		swap_ifm						:	OUT	std_logic;
		clr_flag						:	OUT	std_logic;
		PingPong						:	OUT	std_logic;
		SA_start						:	OUT	std_logic;
		done							:	OUT	std_logic);
end Controller_v5;

architecture Behavioral of Controller_v5 is
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		COMPONENTS
	--------------------------------------------------------------------------
	COMPONENT	CNT_FSM_0
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		Enable							:	IN	std_logic;
		--	Status Signals
		start							:	IN	std_logic;
		CNT_PEs_PAUSE					:	IN	std_logic;
		Zpad_eq							:	IN	std_logic;
		Kern_eq							:	IN	std_logic;
		Colm_eq							:	IN	std_logic;
		Chan_eq							:	IN	std_logic;
		Rows_eq							:	IN	std_logic;
		Cntr_eq							:	IN	std_logic;
		GBMs_eq							:	IN	std_logic;
		all_updated						:	IN	std_logic;
		CMD_STA_ACK						:	IN	std_logic;
		pipo_ready						:	IN	std_logic;
		--	Control Signals
		ini								:	OUT	std_logic;
		Zpad_inc						:	OUT	std_logic;
		Kern_inc						:	OUT	std_logic;
		Colm_inc						:	OUT	std_logic;
		Chan_inc						:	OUT	std_logic;
		Rows_inc						:	OUT	std_logic;
		Cntr_inc						:	OUT	std_logic;
		Bank_inc						:	OUT	std_logic;
		GBMs_inc						:	OUT	std_logic;
		SHR_enable						:	OUT	std_logic;
		SHR_clear						:	OUT	std_logic;
		PIPR_enable						:	OUT	std_logic;
		OBUF_set						:	OUT	std_logic;
		OBUF_clr						:	OUT	std_logic;
		inject_zero						:	OUT	std_logic;
		swap_ifm						:	OUT	std_logic;
		clr_flag						:	OUT	std_logic;
		PingPong						:	OUT	std_logic;
		SA_start						:	OUT	std_logic;
		done							:	OUT	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	COMPONENT	CNT_FSM_1
	PORT(
		clk								:	IN	std_logic;
		rst								:	IN	std_logic;
		Enable							:	IN	std_logic;
		--	Status Signals
		start							:	IN	std_logic;
		CNT_PEs_PAUSE					:	IN	std_logic;
		Zpad_eq							:	IN	std_logic;
		Kern_eq							:	IN	std_logic;
		Colm_eq							:	IN	std_logic;
		Chan_eq							:	IN	std_logic;
		Rows_eq							:	IN	std_logic;
		Cntr_eq							:	IN	std_logic;
		GBMs_eq							:	IN	std_logic;
		all_updated						:	IN	std_logic;
		CMD_STA_ACK						:	IN	std_logic;
		pipo_ready						:	IN	std_logic;
		--	Control Signals
		ini								:	OUT	std_logic;
		Zpad_inc						:	OUT	std_logic;
		Kern_inc						:	OUT	std_logic;
		Colm_inc						:	OUT	std_logic;
		Chan_inc						:	OUT	std_logic;
		Rows_inc						:	OUT	std_logic;
		Cntr_inc						:	OUT	std_logic;
		Bank_inc						:	OUT	std_logic;
		GBMs_inc						:	OUT	std_logic;
		SHR_enable						:	OUT	std_logic;
		SHR_clear						:	OUT	std_logic;
		PIPR_enable						:	OUT	std_logic;
		OBUF_set						:	OUT	std_logic;
		OBUF_clr						:	OUT	std_logic;
		inject_zero						:	OUT	std_logic;
		swap_ifm						:	OUT	std_logic;
		clr_flag						:	OUT	std_logic;
		PingPong						:	OUT	std_logic;
		SA_start						:	OUT	std_logic;
		done							:	OUT	std_logic);
	END	COMPONENT;
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		SIGNALS
	--------------------------------------------------------------------------
	--	Control Signals
	SIGNAL	Enable						:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_ini						:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_Zpad_inc				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_Kern_inc				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_Colm_inc				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_Chan_inc				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_Bank_inc				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_SHR_enable				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_SHR_clear				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_PIPR_enable				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_OBUF_set				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_OBUF_clr				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_inject_zero				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_swap_ifm				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_clr_flag				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_PingPong				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_SA_start				:	std_logic_vector(3	DOWNTO	0);
	SIGNAL	FSM_done					:	std_logic_vector(3	DOWNTO	0);
	--------------------------------------------------------------------------
	SIGNAL	Rows_Eq						:	std_logic	:=	'1';
	SIGNAL	Cntr_Eq						:	std_logic	:=	'1';
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
	--		INSTANCES
	--------------------------------------------------------------------------
	FSM_NUM_0							:	CNT_FSM_0
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		Enable							=>	Enable			(0),
		--	Status Signals
		start							=>	start,
		CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE,
		Zpad_eq							=>	Zpad_eq,
		Kern_eq							=>	Kern_eq,
		Colm_eq							=>	Colm_eq,
		Chan_eq							=>	Chan_eq,
		Rows_eq							=>	'1',					--Rows_eq,
		Cntr_eq							=>	'0',					--Cntr_eq,
		GBMs_eq							=>	'0',					--GBMs_eq,
		all_updated						=>	all_updated,
		CMD_STA_ACK						=>	CMD_STA_ACK,
		pipo_ready						=>	pipo_ready,
		--	Control Signals
		ini								=>	FSM_ini			(0),
		Zpad_inc						=>	FSM_Zpad_inc	(0),
		Kern_inc						=>	FSM_Kern_inc	(0),
		Colm_inc						=>	FSM_Colm_inc	(0),
		Chan_inc						=>	FSM_Chan_inc	(0),
		Rows_inc						=>	OPEN,					--FSM_Rows_inc	(0),
		Cntr_inc						=>	OPEN,					--SM_Cntr_inc	(0),
		Bank_inc						=>	FSM_Bank_inc	(0),
		GBMs_inc						=>	OPEN,					--FSM_GBMs_inc	(0),
		SHR_enable						=>	FSM_SHR_enable	(0),
		SHR_clear						=>	FSM_SHR_clear	(0),
		PIPR_enable						=>	FSM_PIPR_enable	(0),
		OBUF_set						=>	FSM_OBUF_set	(0),
		OBUF_clr						=>	FSM_OBUF_clr	(0),
		inject_zero						=>	FSM_inject_zero	(0),
		swap_ifm						=>	FSM_swap_ifm	(0),
		clr_flag						=>	FSM_clr_flag	(0),
		PingPong						=>	FSM_PingPong	(0),
		SA_start						=>	FSM_SA_start	(0),
		done							=>	FSM_done		(0));
	--------------------------------------------------------------------------
	FSM_NUM_1							:	CNT_FSM_1
	PORT	MAP(
		clk								=>	clk,
		rst								=>	rst,
		Enable							=>	Enable			(1),
		--	Status Signals
		start							=>	start,
		CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE,
		Zpad_eq							=>	Zpad_eq,
		Kern_eq							=>	Kern_eq,
		Colm_eq							=>	Colm_eq,
		Chan_eq							=>	Chan_eq,
		Rows_eq							=>	'1',					--Rows_eq,
		Cntr_eq							=>	'0',					--Cntr_eq,
		GBMs_eq							=>	'0',					--GBMs_eq,
		all_updated						=>	all_updated,
		CMD_STA_ACK						=>	CMD_STA_ACK,
		pipo_ready						=>	pipo_ready,
		--	Control Signals
		ini								=>	FSM_ini			(1),
		Zpad_inc						=>	FSM_Zpad_inc	(1),
		Kern_inc						=>	FSM_Kern_inc	(1),
		Colm_inc						=>	FSM_Colm_inc	(1),
		Chan_inc						=>	FSM_Chan_inc	(1),
		Rows_inc						=>	OPEN,					--FSM_Rows_inc	(1),
		Cntr_inc						=>	OPEN,					--FSM_Cntr_inc	(1),
		Bank_inc						=>	FSM_Bank_inc	(1),
		GBMs_inc						=>	OPEN,					--FSM_GBMs_inc	(1),
		SHR_enable						=>	FSM_SHR_enable	(1),
		SHR_clear						=>	FSM_SHR_clear	(1),
		PIPR_enable						=>	FSM_PIPR_enable	(1),
		OBUF_set						=>	FSM_OBUF_set	(1),
		OBUF_clr						=>	FSM_OBUF_clr	(1),
		inject_zero						=>	FSM_inject_zero	(1),
		swap_ifm						=>	FSM_swap_ifm	(1),
		clr_flag						=>	FSM_clr_flag	(1),
		PingPong						=>	FSM_PingPong	(1),
		SA_start						=>	FSM_SA_start	(1),
		done							=>	FSM_done		(1));
	--------------------------------------------------------------------------
	--FSM_NUM_2							:	CNT_FSM_2
	--PORT	MAP(
	--	clk								=>	clk,
	--	rst								=>	rst,
	--	Enable							=>	Enable			(2),
	--	--	Status Signals
	--	start							=>	start,
	--	CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE,
	--	Zpad_eq							=>	Zpad_eq,
	--	Kern_eq							=>	Kern_eq,
	--	Colm_eq							=>	Colm_eq,
	--	Chan_eq							=>	Chan_eq,
	--	Rows_eq							=>	Rows_eq,
	--	Cntr_eq							=>	Cntr_eq,
	--	GBMs_eq							=>	GBMs_eq,
	--	all_updated						=>	all_updated,
	--	CMD_STA_ACK						=>	CMD_STA_ACK,
	--	pipo_ready						=>	pipo_ready,
	--	--	Control Signals
	--	ini								=>	FSM_ini			(2),
	--	Zpad_inc						=>	FSM_Zpad_inc	(2),
	--	Kern_inc						=>	FSM_Kern_inc	(2),
	--	Colm_inc						=>	FSM_Colm_inc	(2),
	--	Chan_inc						=>	FSM_Chan_inc	(2),
	--	Rows_inc						=>	FSM_Rows_inc	(2),
	--	Cntr_inc						=>	FSM_Cntr_inc	(2),
	--	Bank_inc						=>	FSM_Bank_inc	(2),
	--	GBMs_inc						=>	FSM_GBMs_inc	(2),
	--	SHR_enable						=>	FSM_SHR_enable	(2),
	--	SHR_clear						=>	FSM_SHR_clear	(2),
	--	PIPR_enable						=>	FSM_PIPR_enable	(2),
	--	OBUF_set						=>	FSM_OBUF_set	(2),
	--	OBUF_clr						=>	FSM_OBUF_clr	(2),
	--	inject_zero						=>	FSM_inject_zero	(2),
	--	swap_ifm						=>	FSM_swap_ifm	(2),
	--	clr_flag						=>	FSM_clr_flag	(2),
	--	PingPong						=>	FSM_PingPong	(2),
	--	SA_start						=>	FSM_SA_start	(2),
	--	done							=>	FSM_done		(2));
	FSM_ini			(2)					<=	'0';
	FSM_Zpad_inc	(2)					<=	'0';
	FSM_Kern_inc	(2)					<=	'0';
	FSM_Colm_inc	(2)					<=	'0';
	FSM_Chan_inc	(2)					<=	'0';
	FSM_Bank_inc	(2)					<=	'0';
	FSM_SHR_enable	(2)					<=	'0';
	FSM_SHR_clear	(2)					<=	'0';
	FSM_PIPR_enable	(2)					<=	'0';
	FSM_OBUF_set	(2)					<=	'0';
	FSM_OBUF_clr	(2)					<=	'0';
	FSM_inject_zero	(2)					<=	'0';
	FSM_swap_ifm	(2)					<=	'0';
	FSM_clr_flag	(2)					<=	'0';
	FSM_PingPong	(2)					<=	'0';
	FSM_SA_start	(2)					<=	'0';
	FSM_done		(2)					<=	'0';
	--------------------------------------------------------------------------
	--FSM_NUM_3							:	CNT_FSM_3
	--PORT	MAP(
	--	clk								=>	clk,
	--	rst								=>	rst,
	--	Enable							=>	Enable			(3),
	--	--	Status Signals
	--	start							=>	start,
	--	CNT_PEs_PAUSE					=>	CNT_PEs_PAUSE,
	--	Zpad_eq							=>	Zpad_eq,
	--	Kern_eq							=>	Kern_eq,
	--	Colm_eq							=>	Colm_eq,
	--	Chan_eq							=>	Chan_eq,
	--	Rows_eq							=>	Rows_eq,
	--	Cntr_eq							=>	Cntr_eq,
	--	GBMs_eq							=>	GBMs_eq,
	--	all_updated						=>	all_updated,
	--	CMD_STA_ACK						=>	CMD_STA_ACK,
	--	pipo_ready						=>	pipo_ready,
	--	--	Control Signals
	--	ini								=>	FSM_ini			(3),
	--	Zpad_inc						=>	FSM_Zpad_inc	(3),
	--	Kern_inc						=>	FSM_Kern_inc	(3),
	--	Colm_inc						=>	FSM_Colm_inc	(3),
	--	Chan_inc						=>	FSM_Chan_inc	(3),
	--	Rows_inc						=>	FSM_Rows_inc	(3),
	--	Cntr_inc						=>	FSM_Cntr_inc	(3),
	--	Bank_inc						=>	FSM_Bank_inc	(3),
	--	GBMs_inc						=>	FSM_GBMs_inc	(3),
	--	SHR_enable						=>	FSM_SHR_enable	(3),
	--	SHR_clear						=>	FSM_SHR_clear	(3),
	--	PIPR_enable						=>	FSM_PIPR_enable	(3),
	--	OBUF_set						=>	FSM_OBUF_set	(3),
	--	OBUF_clr						=>	FSM_OBUF_clr	(3),
	--	inject_zero						=>	FSM_inject_zero	(3),
	--	swap_ifm						=>	FSM_swap_ifm	(3),
	--	clr_flag						=>	FSM_clr_flag	(3),
	--	PingPong						=>	FSM_PingPong	(3),
	--	SA_start						=>	FSM_SA_start	(3),
	--	done							=>	FSM_done		(3));
	FSM_ini			(3)					<=	'0';
	FSM_Zpad_inc	(3)					<=	'0';
	FSM_Kern_inc	(3)					<=	'0';
	FSM_Colm_inc	(3)					<=	'0';
	FSM_Chan_inc	(3)					<=	'0';
	FSM_Bank_inc	(3)					<=	'0';
	FSM_SHR_enable	(3)					<=	'0';
	FSM_SHR_clear	(3)					<=	'0';
	FSM_PIPR_enable	(3)					<=	'0';
	FSM_OBUF_set	(3)					<=	'0';
	FSM_OBUF_clr	(3)					<=	'0';
	FSM_inject_zero	(3)					<=	'0';
	FSM_swap_ifm	(3)					<=	'0';
	FSM_clr_flag	(3)					<=	'0';
	FSM_PingPong	(3)					<=	'0';
	FSM_SA_start	(3)					<=	'0';
	FSM_done		(3)					<=	'0';
	--------------------------------------------------------------------------
	Enable(0)							<=	'1'						WHEN	CNF_FSM_sel = "00"	ELSE	'0';
	Enable(1)							<=	'1'						WHEN	CNF_FSM_sel = "01"	ELSE	'0';
	Enable(2)							<=	'1'						WHEN	CNF_FSM_sel = "10"	ELSE	'0';
	Enable(3)							<=	'1'						WHEN	CNF_FSM_sel = "11"	ELSE	'0';
	ini									<=	FSM_ini			(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_ini			(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_ini			(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_ini			(3);
	Zpad_inc							<=	FSM_Zpad_inc	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_Zpad_inc	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_Zpad_inc	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_Zpad_inc	(3);
	Kern_inc							<=	FSM_Kern_inc	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_Kern_inc	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_Kern_inc	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_Kern_inc	(3);
	Colm_inc							<=	FSM_Colm_inc	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_Colm_inc	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_Colm_inc	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_Colm_inc	(3);
	Chan_inc							<=	FSM_Chan_inc	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_Chan_inc	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_Chan_inc	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_Chan_inc	(3);
	Bank_inc							<=	FSM_Bank_inc	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_Bank_inc	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_Bank_inc	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_Bank_inc	(3);
	SHR_enable							<=	FSM_SHR_enable	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_SHR_enable	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_SHR_enable	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_SHR_enable	(3);
	SHR_clear							<=	FSM_SHR_clear	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_SHR_clear	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_SHR_clear	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_SHR_clear	(3);
	PIPR_enable							<=	FSM_PIPR_enable	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_PIPR_enable	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_PIPR_enable	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_PIPR_enable	(3);
	OBUF_set							<=	FSM_OBUF_set	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_OBUF_set	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_OBUF_set	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_OBUF_set	(3);
	OBUF_clr							<=	FSM_OBUF_clr	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_OBUF_clr	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_OBUF_clr	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_OBUF_clr	(3);
	inject_zero							<=	FSM_inject_zero	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_inject_zero	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_inject_zero	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_inject_zero	(3);
	swap_ifm							<=	FSM_swap_ifm	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_swap_ifm	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_swap_ifm	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_swap_ifm	(3);
	clr_flag							<=	FSM_clr_flag	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_clr_flag	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_clr_flag	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_clr_flag	(3);
	PingPong							<=	FSM_PingPong	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_PingPong	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_PingPong	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_PingPong	(3);
	SA_start							<=	FSM_SA_start	(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_SA_start	(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_SA_start	(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_SA_start	(3);
	done								<=	FSM_done		(0)		WHEN	CNF_FSM_sel = "00"	ELSE	FSM_done		(1)		WHEN	CNF_FSM_sel = "01"	ELSE	FSM_done		(2)		WHEN	CNF_FSM_sel = "10"	ELSE	FSM_done		(3);
	--------------------------------------------------------------------------
	--------------------------------------------------------------------------
end Behavioral;

