-- Design: 8-bit barrel shifter
-- Description:
--	Rotate 8-bit input N times to the left/right depending on lr.

library ieee;
use ieee.std_logic_1164.all;

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
