-- Design: Testbench for the 8-bit barrel shifter
-- Description:
--	Verifies the correctness for the barrel shifter design
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rotx8_tb is
end entity ; -- rotx8_tb

architecture tb_arch of rotx8_tb is
	signal tb_a, tb_lr_y, tb_rev_y : std_logic_vector(7 downto 0);
	signal tb_amt : std_logic_vector(2 downto 0);
	signal tb_lr : std_logic;
begin
	uut_lr: entity work.rotx8(struc_arch)
		port map(a => tb_a, amt => tb_amt, lr => tb_lr, y => tb_lr_y);

	uut_rev: entity work.rotx8(rev_arch)
		port map(a => tb_a, amt => tb_amt, lr => tb_lr, y => tb_rev_y);

	tb_proc : process
		variable i : integer := 0;
	begin
		amt_loop : for i in 0 to 7 loop
			tb_a <= "01101101";
			tb_amt <= std_logic_vector(to_unsigned(i, tb_amt'length));
			tb_lr <= '0';
			wait for 1 ns;
			tb_lr <= '1';
			wait for 1 ns;
		end loop ; -- amt_loop

		wait for 2 ns;

		assert false
			report "Simulation over"
			severity failure;

	end process ; -- tb_proc

end architecture ; -- tb_arch
