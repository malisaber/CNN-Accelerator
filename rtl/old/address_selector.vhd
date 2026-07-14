library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.my_pack_v2.ALL;

entity address_selector is
	PORT(
		sel				:	IN	std_logic_vector(1 DOWNTO 0);
		add_in_0		:	IN	inter_GBM_com;
		add_in_1		:	IN	inter_GBM_com;
		add_in_2		:	IN	inter_GBM_com;
		add_out			:	OUT	inter_GBM_com);
end address_selector;

architecture Behavioral of address_selector is
begin
	
	PROCESS (sel, add_in_0, add_in_1, add_in_2)
	BEGIN
		CASE	sel	IS
			WHEN	"00"	=>	add_out	<=	add_in_0;
			WHEN	"01"	=>	add_out	<=	add_in_1;
			WHEN	"10"	=>	add_out	<=	add_in_2;
			WHEN	OTHERS	=>	add_out	<=	inter_GBM_com_0;
		END CASE;
	END PROCESS;
	
end Behavioral;

