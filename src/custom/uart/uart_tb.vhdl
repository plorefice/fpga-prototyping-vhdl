-- Design: Testbench for the UART transceiver interface

library ieee;
use ieee.std_logic_1164.all;

entity uart_tb is
end entity ; -- uart_tb

architecture arch of uart_tb is
	constant T : time := 20 ns; -- clock period

	signal clk, rst, en, rd, wr, tx, rx, rx_valid, tx_rdy : std_logic;
	signal r_data, w_data : std_logic_vector(7 downto 0);
begin
	-- unit under test
	uut : entity work.uart
		port map (clk => clk, rst => rst, en => en, rx => rx, tx => tx,
			  rd => rd, wr => wr, r_data => r_data, w_data => w_data,
			  tx_rdy => tx_rdy, rx_valid => rx_valid);

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
		wait for 100 us;
		en <= '1';
		wait until falling_edge(clk);

		w_data <= "10011001";
		wr <= '1';
		wait until falling_edge(clk);
		wr <= '0';

		wait until tx_rdy = '1';

		assert false
			report "Simulation over"
			severity failure;
	end process ;

end architecture ; -- arch


