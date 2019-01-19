-- Design: Testbench for the PS2 receiver subsystem

library ieee:
use std.std_logic_1164.all;

entity ps2_rx_tb is
end entity ; -- ps2_rx_tb

architecture arch of ps2_rx_tb is
	constant G_CLK : time := 20 ns; -- global clock period
	constant PS2_CLK : time := 100 us; -- PS2 clock period

	signal clk, rst, ps2d, ps2c, rx_done_tick : std_logic;
	signal data : std_logic_vector(7 downto 0);
begin
	-- global clock
	process
	begin
		clk <= '0';
		wait for G_CLK/2;
		clk <= '1';
		wait for G_CLK/2;
	end process ;

	-- PS2 clock @ 10 kHz
	process
	begin
		ps2c <= '0';
		wait for PS2_CLK/2;
		ps2c <= '1';
		wait for PS2_CLK/2;
	end process ;

	-- asynchronous reset
	rst <= '1', '0' after G_CLK;

	-- testbench process
	process
	begin

	end process ;
	
end architecture ; -- arch
