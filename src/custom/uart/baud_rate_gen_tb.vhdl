-- Design: Testbench for the baud rate generator

library ieee;
use ieee.std_logic_1164.all;

entity baud_rate_gen_tb is
end entity ; -- baud_rate_gen_tb

architecture arch of baud_rate_gen_tb is
	constant T : time := 20 ns; -- clock period

	signal clk, rst, en, tx_tick, rx_tick : std_logic;
begin
	-- unit under test
	uut : entity work.baud_rate_gen
		port map (clk => clk, rst => rst, en => en,
			  tx_tick => tx_tick, rx_tick => rx_tick);

	-- clock process
	process
	begin
		clk <= '0';
		wait for T / 2;
		clk <= '1';
		wait for T / 2;
	end process ;

	-- initial reset
	rst <= '1', '0' after T / 2;

	-- test process
	process
	begin
		-- initial state
		en <= '0';
		wait for 4 * T;
		wait until falling_edge(clk);
		en <= '1';

		for i in 0 to 15 loop
			for j in 0 to 15 loop
				wait until rx_tick = '1';
			end loop ;
		end loop;

		assert false
			report "Simulation over"
			severity failure;
	end process ;

end architecture ; -- arch
