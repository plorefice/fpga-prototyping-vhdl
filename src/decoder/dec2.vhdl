-- Design: 2-to-4 decoder w/ enable
-- Description:
--	One of 2^n output is asserted according to
--	the input signal and the enable bit.
--
-- Truth table:
--
--	en a1 a0   bcode
--	0  -  -    0000
--	1  0  0    0001
--	1  0  1    0010
--	1  1  0    0100
--	1  1  1    1000

library ieee;
use ieee.std_logic_1164.all;

entity dec2 is
  port (
	a     : in std_logic_vector(1 downto 0);
	en    : in std_logic;
	bcode : out std_logic_vector(3 downto 0)
  ) ;
end entity ; -- dec2

architecture sop_arch of dec2 is
begin
	-- addressing the single bits of bcode
	bcode(3) <= en and a(1) and a(0);
	bcode(2) <= en and a(1) and not a(0);
	bcode(1) <= en and not a(1) and a(0);
	bcode(0) <= en and not a(1) and not a(0);
end architecture ; -- sop_arch
