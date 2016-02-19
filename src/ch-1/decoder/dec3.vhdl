-- Design: 3-to-8 decoder w/ enable
-- Description:
--	One of 2^n output is asserted according to
--	the input signal and the enable bit.
--
-- Truth table:
--
--	en a2 a1 a0   bcode
--	0  -  -  -    00000000
--	1  0  0  0    00000001
--	1  0  0  1    00000010
--	1  0  1  0    00000100
--	1  0  1  1    00001000
--	1  1  0  0    00010000
--	1  1  0  1    00100000
--	1  1  1  0    01000000
--	1  1  1  1    10000000

library ieee;
use ieee.std_logic_1164.all;

entity dec3 is
  port (
	a     : in std_logic_vector(2 downto 0);
	en    : in std_logic;
	bcode : out std_logic_vector(7 downto 0)
  ) ;
end entity ; -- dec3

architecture struc_arch of dec3 is
	signal bcode_l, bcode_h: std_logic_vector(3 downto 0);
	signal a1_0: std_logic_vector(1 downto 0);
	signal en_l, en_h: std_logic;
begin
	-- 2-to-4 decoders in parallel
	dec2_low: entity work.dec2
		port map(a => a1_0, en => en_l, bcode => bcode_l);

	dec2_high: entity work.dec2
		port map(a => a1_0, en => en_h, bcode => bcode_h);

	-- input signals
	a1_0 <= a(1 downto 0);
	en_l <= en and not a(2);
	en_h <= en and a(2);

	-- output signal
	bcode <= bcode_h & bcode_l;
end architecture ; -- sop_arch
