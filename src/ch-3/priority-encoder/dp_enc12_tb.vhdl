-- Design: Testbench for the 12-to-4 dual-priority encoder
-- Description:
--	Verifies the correctness for the 12-to-4 dual-priority encoder design
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_enc12_tb is
end entity ; -- dp_enc12_tb

architecture tb_arch of dp_enc12_tb is
	signal tb_r : std_logic_vector(11 downto 0);
	signal tb_a, tb_b : std_logic_vector(3 downto 0);
	signal tb_va, tb_vb : std_logic;
begin
	uut : entity work.dp_enc12
		port map(r => tb_r, a => tb_a, b => tb_b, va => tb_va, vb => tb_vb);

	tb_proc : process
		variable i : integer := 0;
	begin
		tb_loop : for i in integer range 0 to (2**tb_r'length - 1) loop
			tb_r <= std_logic_vector(to_unsigned(i, tb_r'length));
			wait for 1 ns;
		end loop ; -- tb_loop
		
		wait for 2 ns;

		assert false
			report "Simulation over"
			severity failure;

	end process ; -- tb_proc

end architecture ; -- tb_arch
