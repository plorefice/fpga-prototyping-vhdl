-- Design: D-flip-flop
-- Description:
--	Basic memory element. Input is stored on the rising edge of the clock.

library ieee;
use ieee.std_logic_1164.all;

entity dff is
	port (
		d	: in std_logic;
		clk	: in std_logic;
		q	: out std_logic
	) ;
end entity ; -- dff

architecture arch of dff is
begin
	-- synchronous process
	process( clk )
	begin
		if (clk'event and clk='1') then
			q <= d;
		end if;
	end process ;

end architecture ; -- arch

