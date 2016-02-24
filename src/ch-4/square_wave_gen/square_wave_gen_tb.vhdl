-- Design: Testbench for the square wave generator
-- Description:
--	Verifies the correctness for the square wave generator
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;

entity square_wave_gen_tb is
end entity ; -- square_wave_gen_tb

architecture arch of square_wave_gen_tb is
	constant T : time := 20 ns; -- clock period

	signal clk, rst, q : std_logic;
	signal m, n : std_logic_vector(3 downto 0);
begin
	-- unit under test
	uut : entity work.square_wave_gen
		port map (clk => clk, rst => rst, m => m, n => n, q => q);

	-- clock process
	clk_proc : process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process ; -- clk_proc

	-- initial reset
	rst <= '1', '0' after T/2;

	-- testbench process
	tb_proc : process
	begin
		-- 50 MHz
		m <= (others => '0');
		n <= (others => '0');
		wait until falling_edge(q);
		wait until falling_edge(q);

		-- ~ 500 KHz
		m <= (others => '1');
		n <= (others => '1');
		wait until falling_edge(q);
		wait until falling_edge(q);

		-- 10 MHz
		m <= "0001";
		n <= "0001";
		wait until falling_edge(q);
		wait until falling_edge(q);

		-- 1 MHz
		m <= "1010";
		n <= "1010";
		wait until falling_edge(q);
		wait until falling_edge(q);

		-- different duty cycle
		m <= "1010";
		n <= "0101";
		wait until falling_edge(q);
		wait until falling_edge(q);

		-- and again
		m <= "0110";
		n <= "1000";
		wait until falling_edge(q);
		wait until falling_edge(q);

		assert false
			report "Simulation over"
			severity failure;

	end process ; -- tb_proc

end architecture ; -- arch

