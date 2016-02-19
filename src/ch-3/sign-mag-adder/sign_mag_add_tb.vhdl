-- Design: Testbench for the sign-magnitude adder
-- Description:
--	Verifies the correctness for the sign-magnitude adder design
--	by cross-checking the design outputs with validation cases.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_mag_add_tb is
end entity ; -- sign_mag_add_tb

architecture tb_arch of sign_mag_add_tb is
	constant N : integer := 4; -- size of the operands (sign AND modulus)
	signal tb_a, tb_b, tb_sum : std_logic_vector(N-1 downto 0);
begin
	uut: entity work.sign_mag_add
		generic map(N => N)
		port map(a => tb_a, b => tb_b, sum => tb_sum);

	tb_proc : process
		variable i, j : integer := 0;
	begin
		outer : for i in integer range 0 to (2**N - 1) loop
		inner : for j in integer range 0 to (2**N - 1) loop
			tb_a <= std_logic_vector(to_unsigned(i, N));
			tb_b <= std_logic_vector(to_unsigned(j, N));
			wait for 1 ns;
		end loop ; -- inner
		end loop ; -- outer

		wait for 2 ns;

		assert false
			report "Simulation over"
			severity failure;

	end process ; -- tb_proc

end architecture ; -- tb_arch