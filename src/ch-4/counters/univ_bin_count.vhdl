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
		ctrl	: in std_logic_vector(2 downto 0);
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
	with ctrl select
		r_next <= r_reg           when "000", -- pause
		          r_reg + 1       when "001", -- up
		          r_reg - 1       when "010", -- down
		          unsigned(d)     when "011", -- load
		          (others => '0') when others; -- "1--" reset

	-- output logic
	ovfl <= '1' when r_reg = (2**N-1) else '0';
	zr <= '0' when r_reg = 0 else '0';
	q <= std_logic_vector(r_reg);

end architecture ; -- arch
