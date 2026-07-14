--generating Package for Adaptors By MATLAB

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.MY_Pack_v2.ALL;

--	to use this package add following line to your code:
--	USE WORK.Port_Adapter_Pack.ALL;

PAcKAGE Port_Adapter_Pack IS
	--------------------------------------------------------------------
	--------------------------------------------------------------------
	--------------------------------------------------------------------
	COMPONENT	Adapter_1_to_1
	GENERIC(
		Tag_size		:	INTEGER	:=	8;
		Idx_size		:	INTEGER	:=	8;
		Cnt_size		:	INTEGER	:=	8);
	PORT(
		--------------------------------------------------------------------
		--------------------------------------------------------------------
		--	PORT 0
		------	InGate
		LMN_S0_CS		:	OUT	std_logic;
		LMN_S0_done		:	IN	std_logic;
		LMN_S0_wait		:	IN	std_logic;
		LMN_S0_read		:	OUT	std_logic;
		LMN_S0_write	:	OUT	std_logic;
		LMN_S0_Tag		:	OUT	std_logic_vector(Tag_size-1 DOWNTO 0);
		LMN_S0_Idx		:	OUT	std_logic_vector(Idx_size-1 DOWNTO 0);
		LMN_S0_Cnt		:	OUT	std_logic_vector(Cnt_size-1 DOWNTO 0);
		LMN_S0_Dout		:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		LMN_S0_Dout_rdy	:	IN	std_logic;
		LMN_S0_Din		:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		LMN_S0_Din_rdy	:	OUT	std_logic;
		------	OutGate
		LMN_M0_req		:	IN	std_logic;
		LMN_M0_grant	:	OUT	std_logic;
		LMN_M0_done		:	OUT	std_logic;
		LMN_M0_wait		:	OUT	std_logic;
		LMN_M0_read		:	IN	std_logic;
		LMN_M0_write	:	IN	std_logic;
		LMN_M0_Tag		:	IN	std_logic_vector(Tag_size-1 DOWNTO 0);
		LMN_M0_Idx		:	IN	std_logic_vector(Idx_size-1 DOWNTO 0);
		LMN_M0_Cnt		:	IN	std_logic_vector(Cnt_size-1 DOWNTO 0);
		LMN_M0_Din		:	OUT	std_logic_vector(P_word_size-1 DOWNTO 0);
		LMN_M0_Din_rdy	:	OUT	std_logic;
		LMN_M0_Dout		:	IN	std_logic_vector(P_word_size-1 DOWNTO 0);
		LMN_M0_Dout_rdy	:	IN	std_logic;
		--------------------------------------------------------------------
		--------------------------------------------------------------------
		--	PORT Array
		------	InGate
		LMN_S_CS		:	IN	Unc_1D_array(0 DOWNTO 0);
		LMN_S_done		:	OUT	Unc_1D_array(0 DOWNTO 0);
		LMN_S_wait		:	OUT	Unc_1D_array(0 DOWNTO 0);
		LMN_S_read		:	IN	Unc_1D_array(0 DOWNTO 0);
		LMN_S_write		:	IN	Unc_1D_array(0 DOWNTO 0);
		LMN_S_Tag		:	IN	Unc_2D_array(0 DOWNTO 0, Tag_size-1 DOWNTO 0);
		LMN_S_Idx		:	IN	Unc_2D_array(0 DOWNTO 0, Idx_size-1 DOWNTO 0);
		LMN_S_Cnt		:	IN	Unc_2D_array(0 DOWNTO 0, Cnt_size-1 DOWNTO 0);
		LMN_S_Dout		:	OUT	Unc_2D_array(0 DOWNTO 0, P_word_size-1 DOWNTO 0);
		LMN_S_Dout_rdy	:	OUT	Unc_1D_array(0 DOWNTO 0);
		LMN_S_Din		:	IN	Unc_2D_array(0 DOWNTO 0, P_word_size-1 DOWNTO 0);
		LMN_S_Din_rdy	:	IN	Unc_1D_array(0 DOWNTO 0);
		------	OutGate
		LMN_M_req		:	OUT	Unc_1D_array(0 DOWNTO 0);
		LMN_M_grant		:	IN	Unc_1D_array(0 DOWNTO 0);
		LMN_M_done		:	IN	Unc_1D_array(0 DOWNTO 0);
		LMN_M_wait		:	IN	Unc_1D_array(0 DOWNTO 0);
		LMN_M_read		:	OUT	Unc_1D_array(0 DOWNTO 0);
		LMN_M_write		:	OUT	Unc_1D_array(0 DOWNTO 0);
		LMN_M_Tag		:	OUT	Unc_2D_array(0 DOWNTO 0, Tag_size-1 DOWNTO 0);
		LMN_M_Idx		:	OUT	Unc_2D_array(0 DOWNTO 0, Idx_size-1 DOWNTO 0);
		LMN_M_Cnt		:	OUT	Unc_2D_array(0 DOWNTO 0, Cnt_size-1 DOWNTO 0);
		LMN_M_Din		:	IN	Unc_2D_array(0 DOWNTO 0, P_word_size-1 DOWNTO 0);
		LMN_M_Din_rdy	:	IN	Unc_1D_array(0 DOWNTO 0);
		LMN_M_Dout		:	OUT	Unc_2D_array(0 DOWNTO 0, P_word_size-1 DOWNTO 0);
		LMN_M_Dout_rdy	:	OUT	Unc_1D_array(0 DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------
	--------------------------------------------------------------------
	--------------------------------------------------------------------
END Port_Adapter_Pack;

PACKAGE BODY Port_Adapter_Pack IS
END Port_Adapter_Pack;

