-- Design: Testebench for the universal binary counter
-- Description:
--	Verifies the correctness for the universal binary counter
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity univ_bin_count_tb is
end entity ; -- univ_bin_count_tb

architecture arch of univ_bin_count_tb is
	constant BITS : integer := 3;
	constant T : time := 20 ns; -- clk period

	signal clk, rst, max, min : std_logic;
	signal ctrl : std_logic_vector(2 downto 0);
	signal d, q : std_logic_vector(BITS-1 downto 0);
begin
	-- Instantiate components
	uut : entity work.univ_bin_count
		generic map (N => BITS)
		port map (
			clk => clk, rst => rst,
			max => max, min => min,
			ctrl => ctrl,
			d => d, q => q
		);

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
		-- initial inputs
		ctrl <= "000"; -- no-op
		d <= (others => '0');
		wait until falling_edge(clk);
		wait until falling_edge(clk);

		-- test load
		ctrl <= "011"; --load
		d <= "011";
		wait until falling_edge(clk);
		ctrl <= "000";

		-- pause 2 clocks
		wait until falling_edge(clk);
		wait until falling_edge(clk);

		-- test synchronous clear
		ctrl <= "100";
		wait until falling_edge(clk);
		ctrl <= "000";

		-- test up counter
		ctrl <= "001";
		for i in 1 to 10 loop
			wait until falling_edge(clk);
		end loop ;

		-- test pause
		ctrl <= "000";
		wait until falling_edge(clk);
		wait until falling_edge(clk);

		-- test resume
		ctrl <= "001";
		wait until falling_edge(clk);
		wait until falling_edge(clk);

		-- test down counter
		ctrl <= "010";
		for i in 1 to 10 loop
			wait until falling_edge(clk);
		end loop ;

		-- other test conditions
		wait until q = "010";
		wait until falling_edge(clk);

		-- continue until min changes value
		ctrl <= "001";
		wait on min;
		wait until falling_edge(clk);

		-- wait for 80 ns
		ctrl <= "010";
		wait for 4 * T;
		ctrl <= "000";
		wait for 4 * T;

		-- simulation over
		assert false
			report "Simulation over"
			severity failure;

	end process ; -- tb_proc

end architecture ; -- arch

