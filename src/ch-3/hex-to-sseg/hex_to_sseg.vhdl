-- Design: Hexadecimal digit to seven-segment LED decoder
-- Description:
--	Displays a 4-bit hexadecimal digit on a seven-segment
--	LED digit display with decimal separator.
--	The display has eight LEDs, one for each segment plus
--	the dot, which are lit when the corresponding input is '0'.
--
--	 --a--
--	|     |
--	f     b
--	 --g--
--	e     c
--	|     |
--	 --d--    o dp

library ieee;
use ieee.std_logic_1164.all;

entity hex_to_sseg is
	port (
		hex	: in std_logic_vector(3 downto 0);
		dp	: in std_logic;
		sseg	: out std_logic_vector(7 downto 0)
	) ;
end entity ; -- hex_to_sseg

architecture arch of hex_to_sseg is
begin
	with hex select
		sseg(6 downto 0) <=
			"0000001" when "0000",
			"1001111" when "0001",
			"0010010" when "0010",
			"0000110" when "0011",
			"1001100" when "0100",
			"0100100" when "0101",
			"0100000" when "0110",
			"0001111" when "0111",
			"0000000" when "1000",
			"0000100" when "1001",
			"0000010" when "1010",
			"1100000" when "1011",
			"0110001" when "1100",
			"1000010" when "1101",
			"0110000" when "1110",
			"0111000" when others;

	sseg(7) <= not dp;

end architecture ; -- arch
