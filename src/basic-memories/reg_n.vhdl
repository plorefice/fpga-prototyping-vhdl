-- Design: N-bit register
-- Description:
--	Generic memory element. Behaves like N D-flip-flop in parallel.

library ieee;
use ieee.std_logic_1164.all;

entity reg_n is
	generic (
		N 	: integer := 8
	) ;
	port (
		d	: in std_logic_vector(N-1 downto 0);
		clk	: in std_logic;
		reset	: in std_logic;
		q	: out std_logic_vector(N-1 downto 0)
	) ;
end entity ; -- reg_n

architecture arch of reg_n is
begin
	process( clk, reset )
	begin
		if (reset='1') then
			q <= (others => '0');
		elsif (clk'event and clk='1') then
			q <= d;
		end if;
	end process ;

end architecture ; -- arch
