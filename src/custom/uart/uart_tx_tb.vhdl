-- Design: Testbench for the UART transmitter

library ieee;
use ieee.std_logic_1164.all;

entity uart_tx_tb is
end entity ; -- uart_tx_tb

architecture arch of uart_tx_tb is
	constant T : time := 20 ns; -- clock period

	signal clk, rst, tx_tick, rx_tick : std_logic;
	signal tx_start, tx_done, dout : std_logic;
	signal din : std_logic_vector(7 downto 0);
begin
	-- unit under test
	uut : entity work.uart_tx
		port map (clk => clk, rst => rst, tx_start => tx_start,
			  tx_tick => tx_tick, din => din, tx_done => tx_done,
			  dout => dout);

	brg : entity work.uart_baud_gen
		port map (clk => clk, rst => rst, en => tx_start,
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
		tx_start <= '0';

		wait for 10 ms;
		wait until falling_edge(clk);

		din <= "01010101";
		tx_start <= '1';

		wait until tx_done = '1';
		tx_start <= '0';
		wait for 1 ms;

		wait until falling_edge(clk);
		din <= "10011001";
		tx_start <= '1';

		wait until tx_done = '1';
		tx_start <= '0';

		wait for 1 ms;

		assert false
			report "Simulation over"
			severity failure;
	end process ;

end architecture ; -- arch

