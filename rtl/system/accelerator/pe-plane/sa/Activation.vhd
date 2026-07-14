library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pack_v2.ALL;

entity Activation is
	PORT(
		enable			:	IN	std_logic;
		mode			:	IN	std_logic;
		
		Din				:	IN	std_logic_vector(P_word_size-1		DOWNTO 0);
		Dout			:	OUT	std_logic_vector(P_word_size-1		DOWNTO 0));
end Activation;

architecture Behavioral of Activation is
	SIGNAL	act_out_L	:	std_logic_vector(P_word_size/2-1 DOWNTO 0);
	SIGNAL	act_out_H	:	std_logic_vector(P_word_size/2-1 DOWNTO 0);
begin
	
	PROCESS (mode, Din, enable)
	BEGIN
		IF enable = '1' THEN 
			IF mode = '0' THEN
				IF Din(P_word_size-1) = '1' THEN
					act_out_H	<=	(OTHERS => '0');
				ELSE
					act_out_H	<=	Din(P_word_size-1 DOWNTO P_word_size/2);
				END IF;
				IF Din((P_word_size/2)-1) = '1' THEN
					act_out_L	<=	(OTHERS => '0');
				ELSE
					act_out_L	<=	Din((P_word_size/2)-1 DOWNTO 0);
				END IF;
			ELSE
				IF Din(P_word_size-1) = '1' THEN
					act_out_H	<=	(OTHERS => '0');
					act_out_L	<=	(OTHERS => '0');
				ELSE
					act_out_H	<=	Din(P_word_size-1 DOWNTO P_word_size/2);
					act_out_L	<=	Din((P_word_size/2)-1 DOWNTO 0);
				END IF;
			END IF;
		ELSE
			act_out_H			<=	Din(P_word_size-1 DOWNTO P_word_size/2);
			act_out_L			<=	Din((P_word_size/2)-1 DOWNTO 0);
		END IF;
	END PROCESS;
	
	Dout						<=	act_out_H & act_out_L;
	
end Behavioral;

