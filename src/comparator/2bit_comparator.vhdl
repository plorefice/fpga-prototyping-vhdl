-- Design: 2-bits comparator
-- Description:
--	Compares two pairs of bits.
--	The output is asserted if the pairs are the same.

library ieee;
use ieee.std_logic_1164.all;

entity cmp2 is
	port (
		-- now a and b are 2 bits wide each
		a, b	: in std_logic_vector(1 downto 0);
		eq	: out std_logic
	) ;
end entity ; -- cmp2

-- as before, a sum-of-products implementation
architecture sop_arch of cmp2 is
	signal p0, p1, p2, p3: std_logic;
begin
	-- sum of two products
	eq <= p0 or p1 or p2 or p3;

	-- product terms
	p0 <= ((not a(1)) and (not b(1))) and
	      ((not a(0)) and (not b(0)));
	p1 <= ((not a(1)) and (not b(1))) and (a(0) and b(0));
	p2 <= (a(1) and b(1)) and ((not a(0)) and (not b(0)));
	p3 <= (a(1) and b(1)) and (a(0) and b(0));
end architecture ; -- sop_arch

-- we can also take a structural approach, using the 1-bit comparators
architecture struc_arch of cmp2 is
	signal e0, e1: std_logic;
begin
	-- instantiation of two 1-bit comparators
	eq_bit0_unit: entity work.cmp1(sop_arch)
		port map(a => a(0), b => b(0), eq => e0);
	eq_bit1_unit: entity work.cmp1(sop_arch)
		port map(a => a(1), b => b(1), eq => e1);
	
	-- now eq == e0 and e1
	eq <= e0 and e1;
end architecture ; -- struc_arch
