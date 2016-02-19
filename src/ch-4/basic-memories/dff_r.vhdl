-- Design: D-flip-flop with asynchronous reset
-- Description:
--	Basic memory element. Input is stored on the rising edge of the clock.
--	If reset is asserted, the internal storage is cleared.

library ieee;
use ieee.std_logic_1164.all;

entity dff_r is
	port (
		d	: in std_logic;
		clk	: in std_logic;
		reset	: in std_logic;
		q	: out std_logic
	) ;
end entity ; -- dff_r

architecture arch of dff_r is
begin
	-- synchronous process with asynch reset
	process( clk, reset )
	begin
		if (reset='1') then
			q <= '0';
		elsif (clk'event and clk='1') then
			q <= d;
		end if;
	end process ;

end architecture ; -- arch

