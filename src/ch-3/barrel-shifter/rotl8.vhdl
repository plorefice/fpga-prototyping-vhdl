-- Design: 8-bit barrel shifter
-- Description:
--	Rotate 8-bit input N times to the left.

library ieee;
use ieee.std_logic_1164.all;

entity rotl8 is
	port (
		a	: in std_logic_vector(7 downto 0);
		amt	: in std_logic_vector(2 downto 0);
		y	: out std_logic_vector(7 downto 0)
	) ;
end entity ; -- rotl8

-- exhaustive select architecture
architecture sel_arch of rotl8 is
begin
	with amt select
		y <= a                             when "000",
		     a(6 downto 0) & a(7)          when "001",
		     a(5 downto 0) & a(7 downto 6) when "010",
		     a(4 downto 0) & a(7 downto 5) when "011",
		     a(3 downto 0) & a(7 downto 4) when "100",
		     a(2 downto 0) & a(7 downto 3) when "101",
		     a(1 downto 0) & a(7 downto 2) when "110",
		     a(0)          & a(7 downto 1) when others; -- "111"

end architecture ; -- sel_arch

-- multi-stage architecture
architecture ms_arch of rotl8 is
	signal y0, y1 : std_logic_vector(7 downto 0);
begin
	-- stage 0, shift 0 or 1 bit
	y0 <= a(6 downto 0) & a(7) when amt(0) = '1' else
	      a;

	-- stage 1, shift 0 or 2 bits
	y1 <= y0(5 downto 0) & y0(7 downto 6) when amt(1) = '1' else
	      y0;

	-- stage 2, shift 0 or 4 bits
	y <= y1(3 downto 0) & y1(7 downto 4) when amt(2) = '1' else
	     y1;

end architecture ; -- ms_arch
