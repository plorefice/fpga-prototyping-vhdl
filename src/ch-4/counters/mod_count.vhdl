-- Design: Mod-m counter
-- Description:
--	Counts to 0 to m-1 and wraps around when en is asserted.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod_count is
	generic (
		N	: integer := 4; -- number of bits
		M	: integer := 10 -- modulus
	) ;
	port (
		clk, rst: in std_logic;
		en	: in std_logic;
		max	: out std_logic;
		q	: out std_logic_vector(N-1 downto 0)
	) ;
end entity ; -- mod_count

architecture arch of mod_count is
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
	r_next <= r_reg           when en = '0' else
		  (others => '0') when r_reg = (M-1) else
		  r_reg + 1;

	-- output logic
	max <= '1' when r_reg = (M-1) else '0';
	q <= std_logic_vector(r_reg);

end architecture ; -- arch
