-- Design: Testbench for the 2-bit comparator
-- Description:
--	Verifies the correctness for the comparator design
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;

entity cmp2_testbench is
end entity ; -- cmp2_testbench

-- testbench architecture
architecture tb_arch of cmp2_testbench is
	signal tb_in0, tb_in1: std_logic_vector(1 downto 0);
	signal tb_out: std_logic;
begin
	-- instantiate the unit-under-test (uut)
	uut: entity work.cmp2(struc_arch)
		port map(a => tb_in0, b => tb_in1, eq => tb_out);

	-- generate the test vectors and check the output
	-- inside a `process` every statement is executed sequentially
	tb_proc : process
	begin
		-- test vector 1
		tb_in0 <= "00";
		tb_in1 <= "00";
		wait for 200 ns;

		-- test vector 2
		tb_in0 <= "01";
		tb_in1 <= "00";
		wait for 200 ns;

		-- test vector 3
		tb_in0 <= "01";
		tb_in1 <= "11";
		wait for 200 ns;

		-- test vector 4
		tb_in0 <= "10";
		tb_in1 <= "10";
		wait for 200 ns;

		-- test vector 5
		tb_in0 <= "10";
		tb_in1 <= "00";
		wait for 200 ns;

		-- test vector 6
		tb_in0 <= "11";
		tb_in1 <= "11";
		wait for 200 ns;

		-- test vector 7
		tb_in0 <= "11";
		tb_in1 <= "01";
		wait for 200 ns;

		-- stop the testbench by asserting to false
		assert false
			report "Simulation completed"
			severity failure;
	end process ; -- tb_proc
end architecture ; -- sop_arch
