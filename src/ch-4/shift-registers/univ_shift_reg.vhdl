-- Design: Universal shift register
-- Description:
--	A universal shift register can load parallel data, shift its content
--	left or right, or remain in the same state. It can perform
--	parallel-to-serial operations, or serial-to-parallel.
--	The operation is controlled by the ctrl signal.

library ieee;
use ieee.std_logic_1164.all;

entity univ_shift_reg is
	generic (
		N	: integer := 8
	) ;
	port (
		clk, rst: in std_logic;
		ctrl	: in std_logic_vector(1 downto 0);
		d	: in std_logic_vector(N-1 downto 0);
		q	: out std_logic_vector(N-1 downto 0)
	) ;
end entity ; -- univ_shift_reg

architecture arch of univ_shift_reg is
	signal r_reg : std_logic_vector(N-1 downto 0);
	signal r_next : std_logic_vector(N-1 downto 0);
begin
	-- registers
	reg_proc : process( clk, rst )
	begin
		if (rst = '1') then
			r_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			r_reg <= r_next;
		end if ;
	end process ; -- reg_proc

	-- next-state logic
	with ctrl select
		r_next <=
			r_reg                        when "00", -- no-op
			r_reg(N-2 downto 0) & d(0)   when "01", -- shift left
			d(N-1) & r_reg(N-1 downto 1) when "10", -- shift right
			d                            when others; -- "11", load

	-- output logic
	q <= r_reg;

end architecture ; -- arch