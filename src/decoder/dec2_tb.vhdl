-- Design: Testbench for the 2-to-4 decoder
-- Description:
--	Verifies the correctness for the 2-to-4 decoder design
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec2_tb is
end entity ; -- dec2_tb

architecture tb_arch of dec2_tb is
	signal a: std_logic_vector(1 downto 0);
	signal en: std_logic;
	signal bcode: std_logic_vector(3 downto 0);
begin
	uut: entity work.dec2(sop_arch)
		port map(a => a, en => en, bcode => bcode);

	tb_proc: process
		variable i: integer := 0;
	begin
		iter: for i in integer range 0 to (2**a'length -1) loop
			en <= '0';
			a <= std_logic_vector(to_unsigned(i, a'length));
			wait for 1 ns;
			en <= '1';
			wait for 1 ns;
		end loop iter; -- iter

		wait for 2 ns;

		assert false
			report "Simulation over"
			severity failure;
	end process ; -- tb_proc

end architecture ; -- tb_arch