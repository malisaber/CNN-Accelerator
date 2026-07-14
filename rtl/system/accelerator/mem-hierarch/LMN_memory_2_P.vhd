library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;
USE IEEE.math_real.ALL;

entity LMN_memory_2_P is
	GENERIC(
		depth				:	INTEGER	:=	1024;
		size				:	INTEGER	:=	16);
	PORT(	
		clk					:	IN	std_logic;
			
		MEM_1_Add			:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_1_wen			:	IN	std_logic;
		MEM_1_Dout			:	OUT	std_logic_vector(size-1 DOWNTO 0);
		MEM_1_Din			:	IN	std_logic_vector(size-1 DOWNTO 0);
			
		MEM_2_Add			:	IN	std_logic_vector(integer(ceil(log2(real(depth))))-1 DOWNTO 0);
		MEM_2_wen			:	IN	std_logic;
		MEM_2_Dout			:	OUT	std_logic_vector(size-1 DOWNTO 0);
		MEM_2_Din			:	IN	std_logic_vector(size-1 DOWNTO 0));
end LMN_memory_2_P;

architecture Behavioral of LMN_memory_2_P is
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	TYPE	mem_type		IS ARRAY(depth-1	DOWNTO 0) OF std_logic_vector(size-1 DOWNTO 0);
	TYPE	Mvc_type		IS ARRAY(7			DOWNTO 0) OF std_logic_vector(size-1 DOWNTO 0);
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	COMPONENT	sram_16X16_freepdk45_2rw
	PORT(
		-- Port 0: RW
		clk0				:	IN	std_logic;		
		csb0				:	IN	std_logic;		
		web0				:	IN	std_logic;		
		addr0				:	IN	std_logic_vector(3	DOWNTO 0);
		din0				:	IN	std_logic_vector(15	DOWNTO 0);
		dout0				:	OUT	std_logic_vector(15	DOWNTO 0);
		-- Port 1: RW	
		clk1				:	IN	std_logic;		
		csb1				:	IN	std_logic;		
		web1				:	IN	std_logic;		
		addr1				:	IN	std_logic_vector(3	DOWNTO 0);
		din1				:	IN	std_logic_vector(15	DOWNTO 0);
		dout1				:	OUT	std_logic_vector(15	DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	COMPONENT	sram_16X8_freepdk45_2rw
	PORT(
		-- Port 0: RW
		clk0				:	IN	std_logic;		
		csb0				:	IN	std_logic;		
		web0				:	IN	std_logic;		
		addr0				:	IN	std_logic_vector(3	DOWNTO 0);
		din0				:	IN	std_logic_vector(7	DOWNTO 0);
		dout0				:	OUT	std_logic_vector(7	DOWNTO 0);
		-- Port 1: RW	
		clk1				:	IN	std_logic;		
		csb1				:	IN	std_logic;		
		web1				:	IN	std_logic;		
		addr1				:	IN	std_logic_vector(3	DOWNTO 0);
		din1				:	IN	std_logic_vector(7	DOWNTO 0);
		dout1				:	OUT	std_logic_vector(7	DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	COMPONENT	sram_256X16_freepdk45_2rw
	PORT(
		-- Port 0: RW
		clk0				:	IN	std_logic;		
		csb0				:	IN	std_logic;		
		web0				:	IN	std_logic;		
		addr0				:	IN	std_logic_vector(7	DOWNTO 0);
		din0				:	IN	std_logic_vector(15	DOWNTO 0);
		dout0				:	OUT	std_logic_vector(15	DOWNTO 0);
		-- Port 1: RW	
		clk1				:	IN	std_logic;		
		csb1				:	IN	std_logic;		
		web1				:	IN	std_logic;		
		addr1				:	IN	std_logic_vector(7	DOWNTO 0);
		din1				:	IN	std_logic_vector(15	DOWNTO 0);
		dout1				:	OUT	std_logic_vector(15	DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	COMPONENT	sram_16X12_freepdk45_2rw
	PORT(
		-- Port 0: RW
		clk0				:	IN	std_logic;		
		csb0				:	IN	std_logic;		
		web0				:	IN	std_logic;		
		addr0				:	IN	std_logic_vector(3	DOWNTO 0);
		din0				:	IN	std_logic_vector(11	DOWNTO 0);
		dout0				:	OUT	std_logic_vector(11	DOWNTO 0);
		-- Port 1: RW	
		clk1				:	IN	std_logic;		
		csb1				:	IN	std_logic;		
		web1				:	IN	std_logic;		
		addr1				:	IN	std_logic_vector(3	DOWNTO 0);
		din1				:	IN	std_logic_vector(11	DOWNTO 0);
		dout1				:	OUT	std_logic_vector(11	DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	COMPONENT	sram_1024X16_freepdk45_2rw
	PORT(
		-- Port 0: RW
		clk0				:	IN	std_logic;		
		csb0				:	IN	std_logic;		
		web0				:	IN	std_logic;		
		addr0				:	IN	std_logic_vector(9	DOWNTO 0);
		din0				:	IN	std_logic_vector(15	DOWNTO 0);
		dout0				:	OUT	std_logic_vector(15	DOWNTO 0);
		-- Port 1: RW	
		clk1				:	IN	std_logic;		
		csb1				:	IN	std_logic;		
		web1				:	IN	std_logic;		
		addr1				:	IN	std_logic_vector(9	DOWNTO 0);
		din1				:	IN	std_logic_vector(15	DOWNTO 0);
		dout1				:	OUT	std_logic_vector(15	DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	COMPONENT	sram_4096X16_freepdk45_2rw
	PORT(
		-- Port 0: RW
		clk0				:	IN	std_logic;		
		csb0				:	IN	std_logic;		
		web0				:	IN	std_logic;		
		addr0				:	IN	std_logic_vector(11	DOWNTO 0);
		din0				:	IN	std_logic_vector(15	DOWNTO 0);
		dout0				:	OUT	std_logic_vector(15	DOWNTO 0);
		-- Port 1: RW	
		clk1				:	IN	std_logic;		
		csb1				:	IN	std_logic;		
		web1				:	IN	std_logic;		
		addr1				:	IN	std_logic_vector(11	DOWNTO 0);
		din1				:	IN	std_logic_vector(15	DOWNTO 0);
		dout1				:	OUT	std_logic_vector(15	DOWNTO 0));
	END COMPONENT;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--FUNCTION init(name	:	string) RETURN mem_type IS
	--	VARIABLE	mem_val	:	mem_type;
	--	VARIABLE	cntr	:	INTEGER	:=	0;
	--BEGIN
	--	FOR i IN depth-1 DOWNTO 0 LOOP
	--		mem_val(i) :=	std_logic_vector(to_unsigned(i, size));
	--	END LOOP;
	--	RETURN mem_val;
	--END FUNCTION;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	SIGNAL	mem				:	mem_type;	--	:=	init("dummy");
	SIGNAL	wen1_b			:	std_logic;
	SIGNAL	wen2_b			:	std_logic;
	--------------------------------------------------------------------------------------
	SIGNAL	add1			:	integer;
	SIGNAL	Vwen1_b			:	std_logic_vector(7 DOWNTO 0);
	SIGNAL	Vdout1			:	Mvc_type;
	SIGNAL	add2			:	integer;
	SIGNAL	Vwen2_b			:	std_logic_vector(7 DOWNTO 0);
	SIGNAL	Vdout2			:	Mvc_type;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
begin
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	wen1_b					<=	NOT	MEM_1_wen;
	wen2_b					<=	NOT	MEM_2_wen;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	bank_gen_16X8			:	IF	((depth = 16)		AND	(size = 8))	GENERATE
		sram_16X8			:	sram_16X8_freepdk45_2rw
		PORT	MAP(
			-- Port 0: RW
			clk0			=>	clk,
			csb0			=>	'0',
			web0			=>	wen1_b,
			addr0			=>	MEM_1_Add,
			din0			=>	MEM_1_Din,
			dout0			=>	MEM_1_Dout,
			-- Port 1: RW
			clk1			=>	clk,
			csb1			=>	'0',
			web1			=>	wen2_b,
			addr1			=>	MEM_2_Add,
			din1			=>	MEM_2_Din,
			dout1			=>	MEM_2_Dout);
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	bank_gen_16X16			:	IF	((depth = 16)		AND	(size = 16))	GENERATE
		sram_16X16			:	sram_16X16_freepdk45_2rw
		PORT	MAP(
			-- Port 0: RW
			clk0			=>	clk,
			csb0			=>	'0',
			web0			=>	wen1_b,
			addr0			=>	MEM_1_Add,
			din0			=>	MEM_1_Din,
			dout0			=>	MEM_1_Dout,
			-- Port 1: RW
			clk1			=>	clk,
			csb1			=>	'0',
			web1			=>	wen2_b,
			addr1			=>	MEM_2_Add,
			din1			=>	MEM_2_Din,
			dout1			=>	MEM_2_Dout);
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	bank_gen_16X32			:	IF	((depth = 16)		AND	(size = 32))	GENERATE
		sram_16X16_HIGH		:	sram_16X16_freepdk45_2rw
		PORT	MAP(
			-- Port 0: RW
			clk0			=>	clk,
			csb0			=>	'0',
			web0			=>	wen1_b,
			addr0			=>	MEM_1_Add,
			din0			=>	MEM_1_Din(31	DOWNTO	16),
			dout0			=>	MEM_1_Dout(31	DOWNTO	16),
			-- Port 1: RW
			clk1			=>	clk,
			csb1			=>	'0',
			web1			=>	wen2_b,
			addr1			=>	MEM_2_Add,
			din1			=>	MEM_2_Din(31	DOWNTO	16),
			dout1			=>	MEM_2_Dout(31	DOWNTO	16));
	--------------------------------------------------------------------------------------
		sram_16X16_LOW		:	sram_16X16_freepdk45_2rw
		PORT	MAP(
			-- Port 0: RW
			clk0			=>	clk,
			csb0			=>	'0',
			web0			=>	wen1_b,
			addr0			=>	MEM_1_Add,
			din0			=>	MEM_1_Din(15	DOWNTO	0),
			dout0			=>	MEM_1_Dout(15	DOWNTO	0),
			-- Port 1: RW
			clk1			=>	clk,
			csb1			=>	'0',
			web1			=>	wen2_b,
			addr1			=>	MEM_2_Add,
			din1			=>	MEM_2_Din(15	DOWNTO	0),
			dout1			=>	MEM_2_Dout(15	DOWNTO	0));
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	bank_gen_256X16			:	IF	((depth = 256)		AND	(size = 16))	GENERATE
		sram_256X16			:	sram_256X16_freepdk45_2rw
		PORT	MAP(
			-- Port 0: RW
			clk0			=>	clk,
			csb0			=>	'0',
			web0			=>	wen1_b,
			addr0			=>	MEM_1_Add,
			din0			=>	MEM_1_Din,
			dout0			=>	MEM_1_Dout,
			-- Port 1: RW
			clk1			=>	clk,
			csb1			=>	'0',
			web1			=>	wen2_b,
			addr1			=>	MEM_2_Add,
			din1			=>	MEM_2_Din,
			dout1			=>	MEM_2_Dout);
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	bank_gen_1024X16		:	IF	((depth = 1024)		AND	(size = 16))	GENERATE
		sram_1024X16		:	sram_1024X16_freepdk45_2rw
		PORT	MAP(
			-- Port 0: RW
			clk0			=>	clk,
			csb0			=>	'0',
			web0			=>	wen1_b,
			addr0			=>	MEM_1_Add,
			din0			=>	MEM_1_Din,
			dout0			=>	MEM_1_Dout,
			-- Port 1: RW
			clk1			=>	clk,
			csb1			=>	'0',
			web1			=>	wen2_b,
			addr1			=>	MEM_2_Add,
			din1			=>	MEM_2_Din,
			dout1			=>	MEM_2_Dout);
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	bank_gen_4096X16		:	IF	((depth = 4096)		AND	(size = 16))	GENERATE
		sram_4096X16		:	sram_4096X16_freepdk45_2rw
		PORT	MAP(
			-- Port 0: RW
			clk0			=>	clk,
			csb0			=>	'0',
			web0			=>	wen1_b,
			addr0			=>	MEM_1_Add,
			din0			=>	MEM_1_Din,
			dout0			=>	MEM_1_Dout,
			-- Port 1: RW
			clk1			=>	clk,
			csb1			=>	'0',
			web1			=>	wen2_b,
			addr1			=>	MEM_2_Add,
			din1			=>	MEM_2_Din,
			dout1			=>	MEM_2_Dout);
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	bank_gen_16X12			:	IF	((depth = 16)		AND	(size = 12))	GENERATE
		sram_16X12			:	sram_16X12_freepdk45_2rw
		PORT	MAP(
			-- Port 0: RW
			clk0			=>	clk,
			csb0			=>	'0',
			web0			=>	wen1_b,
			addr0			=>	MEM_1_Add,
			din0			=>	MEM_1_Din,
			dout0			=>	MEM_1_Dout,
			-- Port 1: RW
			clk1			=>	clk,
			csb1			=>	'0',
			web1			=>	wen2_b,
			addr1			=>	MEM_2_Add,
			din1			=>	MEM_2_Din,
			dout1			=>	MEM_2_Dout);
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	bank_gen_32768X16		:	IF	((depth = 32768)	AND	(size = 16))	GENERATE
		add1				<=	my_to_uint(MEM_1_Add(14 DOWNTO 12));
		add2				<=	my_to_uint(MEM_2_Add(14 DOWNTO 12));
		PROCESS					(MEM_1_wen,	add1)
		BEGIN
			CASE	add1	IS
				WHEN	0		=>	Vwen1_b	<=	NOT	("00000001"	AND	(7 DOWNTO 0 => MEM_1_wen));
				WHEN	1		=>	Vwen1_b	<=	NOT	("00000010"	AND	(7 DOWNTO 0 => MEM_1_wen));
				WHEN	2		=>	Vwen1_b	<=	NOT	("00000100"	AND	(7 DOWNTO 0 => MEM_1_wen));
				WHEN	3		=>	Vwen1_b	<=	NOT	("00001000"	AND	(7 DOWNTO 0 => MEM_1_wen));
				WHEN	4		=>	Vwen1_b	<=	NOT	("00010000"	AND	(7 DOWNTO 0 => MEM_1_wen));
				WHEN	5		=>	Vwen1_b	<=	NOT	("00100000"	AND	(7 DOWNTO 0 => MEM_1_wen));
				WHEN	6		=>	Vwen1_b	<=	NOT	("01000000"	AND	(7 DOWNTO 0 => MEM_1_wen));
				WHEN	7		=>	Vwen1_b	<=	NOT	("10000000"	AND	(7 DOWNTO 0 => MEM_1_wen));
				WHEN	OTHERS	=>	Vwen1_b	<=	NOT	("00000000"	AND	(7 DOWNTO 0 => MEM_1_wen));
			END CASE;
		END PROCESS;
		PROCESS					(MEM_2_wen,	add2)
		BEGIN
			CASE	add2	IS
				WHEN	0		=>	Vwen2_b	<=	NOT	("00000001"	AND	(7 DOWNTO 0 => MEM_2_wen));
				WHEN	1		=>	Vwen2_b	<=	NOT	("00000010"	AND	(7 DOWNTO 0 => MEM_2_wen));
				WHEN	2		=>	Vwen2_b	<=	NOT	("00000100"	AND	(7 DOWNTO 0 => MEM_2_wen));
				WHEN	3		=>	Vwen2_b	<=	NOT	("00001000"	AND	(7 DOWNTO 0 => MEM_2_wen));
				WHEN	4		=>	Vwen2_b	<=	NOT	("00010000"	AND	(7 DOWNTO 0 => MEM_2_wen));
				WHEN	5		=>	Vwen2_b	<=	NOT	("00100000"	AND	(7 DOWNTO 0 => MEM_2_wen));
				WHEN	6		=>	Vwen2_b	<=	NOT	("01000000"	AND	(7 DOWNTO 0 => MEM_2_wen));
				WHEN	7		=>	Vwen2_b	<=	NOT	("10000000"	AND	(7 DOWNTO 0 => MEM_2_wen));
				WHEN	OTHERS	=>	Vwen2_b	<=	NOT	("00000000"	AND	(7 DOWNTO 0 => MEM_2_wen));
			END CASE;
		END PROCESS;
		Bank_Gen			:	FOR	i	IN	0	TO	7	GENERATE
			sram_32768X16	:	sram_4096X16_freepdk45_2rw
			PORT	MAP(
				-- Port 0: RW
				clk0		=>	clk,
				csb0		=>	'0',
				web0		=>	Vwen1_b(i),
				addr0		=>	MEM_1_Add(11	DOWNTO 0),
				din0		=>	MEM_1_Din,
				dout0		=>	Vdout1(i),
				-- Port 1: RW
				clk1		=>	clk,
				csb1		=>	'0',
				web1		=>	Vwen2_b(i),
				addr1		=>	MEM_2_Add(11	DOWNTO 0),
				din1		=>	MEM_2_Din,
				dout1		=>	Vdout2(i));
		END GENERATE;
		MEM_1_Dout			<=	Vdout1(add1);
		MEM_2_Dout			<=	Vdout2(add2);
	END GENERATE;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--PROCESS (clk)
	--	VARIABLE	add_1	:	INTEGER;
	--	VARIABLE	add_2	:	INTEGER;
	--BEGIN
	--	IF clk = '1' AND clk'EVENT THEN
	--		add_1			:=	my_to_uint(UNSIGNED(MEM_1_Add));
	--		add_2			:=	my_to_uint(UNSIGNED(MEM_2_Add));
	--		
	--		IF MEM_1_wen = '1' THEN
	--			mem(add_1)	<=	MEM_1_Din;
	--		END IF;
	--		MEM_1_Dout	<=	mem(add_1);
	--		
	--		IF MEM_2_wen = '1' THEN
	--			mem(add_2)	<=	MEM_2_Din;
	--		END IF;
	--		MEM_2_Dout	<=	mem(add_2);
	--		
	--	END IF;
	--END PROCESS;
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------
end Behavioral;

