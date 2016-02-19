-- Design: Testbench for the 4-bit greater-than circuit
-- Description:
--	Verifies the correctness for the greater-than circuit design
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gt4_tb is
end entity ; -- gt4_tb

architecture tb_arch of gt4_tb is
	signal tb_in0, tb_in1: std_logic_vector(3 downto 0);
	signal tb_out: std_logic;
begin
	uut: entity work.gt4(struc_arch)
		port map(a => tb_in0, b => tb_in1, gt => tb_out);

	tb_proc : process
		-- we need to declare two variables which we will use in a while
		variable i, j: integer := 0;
	begin
		-- to generate every possible combination, we loop over
		-- each possible value for a and b
		a_loop: for i in integer range 0 to (2**tb_in0'length - 1) loop
		b_loop: for j in integer range 0 to (2**tb_in1'length - 1) loop
			tb_in0 <= std_logic_vector(to_unsigned(i, tb_in0'length));
			tb_in1 <= std_logic_vector(to_unsigned(j, tb_in1'length));
			wait for 200 ns;
		end loop b_loop;
		end loop a_loop;

		-- give us some time to check the last result
		wait for 500 ns;

		-- stop the testbench by asserting to false
		assert false
			report "Simulation completed"
			severity failure;
	end process ; -- tb_proc
end architecture ; -- sop_arch
