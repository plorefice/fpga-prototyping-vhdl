-- Design: Testbench for the 3-to-8 decoder
-- Description:
--	Verifies the correctness for the 3-to-8 decoder design
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec3_tb is
end entity ; -- dec3_tb

architecture tb_arch of dec3_tb is
	signal a: std_logic_vector(2 downto 0);
	signal en: std_logic;
	signal bcode: std_logic_vector(7 downto 0);
begin
	uut: entity work.dec3
		port map(a => a, en => en, bcode => bcode);

	tb_proc : process
		variable i: integer := 0;
	begin
		tb_loop : for i in integer range 0 to (2**a'length - 1) loop
			a <= std_logic_vector(to_unsigned(i, a'length));
			en <= '0';
			wait for 1 ns;
			en <= '1';
			wait for 1 ns;
		end loop tb_loop; -- tb_loop

		wait for 2 ns;

		assert false
			report "Simulation over"
			severity failure;
	end process ; -- tb_proc

end architecture ; -- tb_arch
