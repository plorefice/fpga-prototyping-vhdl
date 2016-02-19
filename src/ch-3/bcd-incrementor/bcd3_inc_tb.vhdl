-- Design: Testbench for the 3-digit BCD incrementor
-- Description:
--	Verifies the correctness for the 3-digit BCD incrementor design
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd3_inc_tb is
end entity ; -- bcd3_inc_tb

architecture arch of bcd3_inc_tb is
	signal tb_bcd, tb_res : std_logic_vector(11 downto 0);
	signal tb_cin, tb_cout, tb_val : std_logic;
begin
	uut : entity work.bcd3_inc
		port map(bcd => tb_bcd, cin => tb_cin,
			res => tb_res, cout => tb_cout, valid => tb_val);

	tb_proc : process
		variable i : integer := 0;
	begin
		tb_loop : for i in integer range 0 to (2**tb_bcd'length - 1) loop
			tb_bcd <= std_logic_vector(to_unsigned(i, tb_bcd'length));
			tb_cin <= '0';
			wait for 1 ns;
			tb_cin <= '1';
			wait for 1 ns;
		end loop ; -- tb_loop

		wait for 2 ns;

		assert false
			report "Simulation over"
			severity failure;

	end process ; -- tb_proc

end architecture ; -- arch
