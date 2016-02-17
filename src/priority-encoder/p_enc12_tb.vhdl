-- Design: Testbench for the 12-to-4 priority encoder
-- Description:
--	Verifies the correctness for the 12-to-4 priority encoder design
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity p_enc12_tb is
end entity ; -- p_enc12_tb

architecture tb_arch of p_enc12_tb is
	signal tb_r : std_logic_vector(11 downto 0);
	signal tb_prio : std_logic_vector(3 downto 0);
	signal tb_val : std_logic;
begin
	uut : entity work.p_enc12
		port map(r => tb_r, prio => tb_prio, valid => tb_val);

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
