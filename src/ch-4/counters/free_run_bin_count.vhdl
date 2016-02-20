-- Design: Free-running binary counter
-- Description:
--	Increment the internal counter at each clock cycle.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity free_run_bin_count is
	generic (
		N	: integer := 8
	) ;
	port (
		clk, rst: in std_logic;
		max	: out std_logic;
		q	: out std_logic_vector(N-1 downto 0)
	) ;
end entity ; -- free_run_bin_count

architecture arch of free_run_bin_count is
	signal r_reg, r_next : unsigned(N-1 downto 0);
begin
	-- register
	reg_proc : process (clk, rst)
	begin
		if (rst = '1') then
			r_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			r_reg <= r_next;
		end if ;
	end process ; -- reg_proc

	-- next-state logic
	r_next <= r_reg + 1;
	
	-- output logic
	q <= std_logic_vector(r_reg);
	max <= '1' when r_reg = (2**N-1) else '0';

end architecture ; -- arch
