-- Design: Testbench for the stopwatch
-- Description:
--	Verifies the correctness for the stopwatch
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;

entity stopwatch_tb is
end entity ; -- stopwatch_tb

architecture arch of stopwatch_tb is
	constant T : time := 20 ns; -- clk period

	signal clk, rst, clr, go : std_logic;
	signal d2, d1, d0 : std_logic_vector(3 downto 0);
begin
	-- Instantiate components
	uut : entity work.stopwatch
		port map (clk => clk, rst => rst, clr => clr, go => go,
			d2 => d2, d1 => d1, d0 => d0);

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
		-- initialization
		clr <= '0'; go <= '0';
		wait until falling_edge(clk);
		wait until falling_edge(clk);

		-- start the stopwatch and wait until the seconds digit is 2
		go <= '1';
		wait until d1 = "0010";
		wait until falling_edge(clk);
		wait until falling_edge(clk);

		-- stop for a while
		go <= '0';
		wait for 20 * T;
		
		-- verify that we are waiting the correct amount of clk ticks
		go <= '1';
		wait for 20 * T;
		wait until falling_edge(clk);

		-- clear the stopwatch
		go <= '0'; clr <= '1';
		wait for 20 * T;
		wait until falling_edge(clk);
		clr <= '0';
		wait until falling_edge(clk);

		-- wait until wrapping
		go <= '1';
		wait until d0 = "0001";
		wait until (d2 = "0000" and d1 = "0000" and d0 = "0000");
		wait until falling_edge(clk);
		wait until falling_edge(clk);

		-- simulation over
		assert false
			report "Simulation over"
			severity failure;

	end process ; -- tb_proc

end architecture ; -- arch

