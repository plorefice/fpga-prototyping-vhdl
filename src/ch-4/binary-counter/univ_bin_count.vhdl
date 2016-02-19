-- Design: Universal binary counter
-- Description:
--	Versatile binary counter that can count up or down, be paused, loaded
--	and reset synchronously.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity univ_bin_count is
	generic (
		N	: integer := 8
	) ;
	port (
		clk, rst: in std_logic;
		sync_rst: in std_logic;
		ctrl	: in std_logic_vector(1 downto 0);
		d	: in std_logic_vector(N-1 downto 0);
		ovfl, zr: out std_logic;
		q	: out std_logic_vector(N-1 downto 0)
	) ;
end entity ; -- univ_bin_count

architecture arch of univ_bin_count is
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


end architecture ; -- arch
