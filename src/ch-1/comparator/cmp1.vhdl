-- Design: 1-bit comparator
-- Description:
--	Compares two bits.
--	The output is asserted if the bits are the same.

-- import the IEEE standard library
library ieee;

-- import the std_logic_1164 package from the library
use ieee.std_logic_1164.all;

-- `entity` describes a component in the overall design
entity cmp1 is
	-- `port` is used to specify the entity's I/O signals
	port (
		a, b	: in std_logic;
		eq	: out std_logic
	) ;
end entity ; -- cmp1

-- `architecture` describes a possible mode of operation of an entity
architecture sop_arch of cmp1 is
	signal p0, p1: std_logic;
begin
	-- the following three statements are executed in parallel

	-- sum of two products
	eq <= p0 or p1;

	-- product terms
	p0 <= (not a) and (not b);
	p1 <= a and b;
end architecture ; -- sop_arch
