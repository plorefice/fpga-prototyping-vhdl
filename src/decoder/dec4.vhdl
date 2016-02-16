-- Design: 4-to-16 decoder w/ enable
-- Description:
--	One of 2^n output is asserted according to
--	the input signal and the enable bit.

library ieee;
use ieee.std_logic_1164.all;

entity dec4 is
  port (
	a     : in std_logic_vector(3 downto 0);
	en    : in std_logic;
	bcode : out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- dec4

architecture struc_arch of dec4 is
	signal i_en : std_logic_vector(3 downto 0);
begin
	-- Four 2-to-4 decoders for the output
	dec2_0: entity work.dec2
		port map(a => a(1 downto 0), en => i_en(0), bcode => bcode(3 downto 0));

	dec2_1: entity work.dec2
		port map(a => a(1 downto 0), en => i_en(1), bcode => bcode(7 downto 4));

	dec2_2: entity work.dec2
		port map(a => a(1 downto 0), en => i_en(2), bcode => bcode(11 downto 8));

	dec2_3: entity work.dec2
		port map(a => a(1 downto 0), en => i_en(3), bcode => bcode(15 downto 12));

	-- A single 2-to-4 decoder to derive the enable signals
	dec2_en: entity work.dec2
		port map(a => a(3 downto 2), en => en, bcode => i_en);

end architecture ; -- sop_arch
