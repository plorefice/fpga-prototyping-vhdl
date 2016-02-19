-- Design: 4-to-2 prioriy encoder
-- Description:
--	Returns the binary code of the most-significant asserted bit.
--	The valid output is asserted if at least one bit in the request is.
--
-- Truth table:
--
--	r3 r2 r1 r0 |  prio  valid
--	1  -  -  -  |  11    1
--	0  1  -  -  |  10    1
--	0  0  1  -  |  01    1
--	0  0  0  1  |  00    1
--	0  0  0  0  |  00    0

library ieee;
use ieee.std_logic_1164.all;

entity p_enc4 is
	port (
		r	: in std_logic_vector(3 downto 0);
		prio	: out std_logic_vector(1 downto 0);
		valid	: out std_logic
	) ;
end entity ; -- p_enc4

architecture arch of p_enc4 is

begin
	-- exhaustive listing of all possible inputs
	with r select
		prio <= "11" when "1000" | "1001" | "1010" | "1011" |
		                  "1100" | "1101" | "1110" | "1111",
		        "10" when "0100" | "0101" | "0110" | "0111",
		        "01" when "0010" | "0011",
		        "00" when others;

	-- valid = 0 <=> r = "0000"
	valid <= r(3) or r(2) or r(1) or r(0);

end architecture ; -- arch
