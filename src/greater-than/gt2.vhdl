-- Design: 2-bits greater-than circuit
-- Description:
--	Compares two 2-bit inputs a and b.
--	The output is asserted if a > b.
--
-- Truth table:
--
--	a1 a0   b1 b0   gt
--	0  0    0  0    0
--	0  0    0  1    0
--	0  0    1  0    0
--	0  0    1  1    0
--	0  1    0  0    1
--	0  1    0  1    0
--	0  1    1  0    0
--	0  1    1  1    0
--	1  0    0  0    1
--	1  0    0  1    1
--	1  0    1  0    0
--	1  0    1  1    0
--	1  1    0  0    1
--	1  1    0  1    1
--	1  1    1  0    1
--	1  1    1  1    0

library ieee;
use ieee.std_logic_1164.all;

entity gt2 is
	port (
		a, b	: in std_logic_vector(1 downto 0);
		gt	: out std_logic
	) ;
end entity ; -- gt2

architecture sop_arch of gt2 is
	signal p0, p1, p2: std_logic;
begin
	-- sum of products
	gt <= p0 or p1 or p2;

	-- product terms
	p0 <= (not a(1)) and a(0) and (not b(1)) and (not b(0));
	p1 <= a(1) and (not a(0)) and (not b(1));
	p2 <= a(1) and a(0) and (not (b(1) and b(0)));
end architecture ; -- sop_arch
