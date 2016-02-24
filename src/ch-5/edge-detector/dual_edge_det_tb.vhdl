-- Design: Testbench for the dual-edge detector
-- Description:
--	Verifies the correctness for the dual-edge detector
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;

entity dual_edge_det_tb is
end entity ; -- dual_edge_det_tb

architecture arch of dual_edge_det_tb is
	constant T : time := 20 ns; -- clk period

	signal clk, rst, level, tick : std_logic;
begin
	-- Instantiate components
	uut : entity work.dual_edge_det
		port map (clk => clk, rst => rst, level => level, tick => tick);

	-- clock process running forever
	clk_proc : process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process ; -- clk_proc

	-- initial reset
	rst <= '1', '0' after T/2;

	-- other stimuli
	tb_proc : process
	begin
		-- initial state
		level <= '0';
		wait for 4 * T;
		wait until falling_edge(clk);

		assert tick = '0'
			report "Error after initial state"
			severity failure;

		-- change level with some delay
		level <= '1';
		wait for  5 * T;
		level <= '0';
		wait for T;
		wait until falling_edge(clk);

		assert tick = '1'
			report "Error in delayed detection"
			severity failure;

		-- very fast level changes
		wait for 4 * T;

		for i in 0 to 5 loop
			level <= '0';
			wait until falling_edge(clk);
			level <= '1';
			wait until falling_edge(clk);
			level <= '0';
			wait until falling_edge(clk);

			assert tick = '1'
				report "Error in fast detection"
				severity failure;

		end loop ;

		-- simulation over
		assert false
			report "Simulation over"
			severity failure;

	end process ; -- tb_proc

end architecture ; -- arch

