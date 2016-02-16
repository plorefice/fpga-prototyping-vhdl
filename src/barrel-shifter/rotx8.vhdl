-- Design: 8-bit barrel shifter
-- Description:
--	Rotate 8-bit input N times to the left/right depending on lr.

library ieee;
use ieee.std_logic_1164.all;
use work.common_p.all;

entity rotx8 is
	port (
		a	: in std_logic_vector(7 downto 0);
		amt	: in std_logic_vector(2 downto 0);
		lr	: in std_logic;
		y	: out std_logic_vector(7 downto 0)
	) ;
end entity ; -- rotx8

architecture struc_arch of rotx8 is
	signal yl, yr : std_logic_vector(7 downto 0);
begin
	rotl: entity work.rotl8
		port map(a => a, amt => amt, y => yl);

	rotr: entity work.rotr8
		port map(a => a, amt => amt, y => yr);

	with lr select
		y <= yl when '0',
		     yr when others; -- '1'

end architecture ; -- struc_arch

-- reverse-input architecture
architecture rev_arch of rotx8 is
	signal a_r, y_r : std_logic_vector(7 downto 0);
begin
	rotr: entity work.rotr8
		port map(a => a_r, amt => amt, y => y_r);

	-- input-reverse circuitry
	with lr select
		a_r <= reverse(a) when '0',
		       a          when others; -- '1'

	-- output-reverse circuitry
	with lr select
		y <= reverse(y_r) when '0',
		     y_r          when others; -- '1'

end architecture ; -- rev_arch