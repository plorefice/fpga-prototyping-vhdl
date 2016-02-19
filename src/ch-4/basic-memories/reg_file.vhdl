-- Design: Register file
-- Description:
--	Generic memory element. Behaves like 2^W B-bit registers.
--	Registers are addressed using their index, and accessed using
--	a read port and a write port.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
	generic (
		B	: integer := 8; -- number of bits
		W	: integer := 2  -- number of address bits
	);
	port (
		clk	: in std_logic;
		reset	: in std_logic;
		wr_en	: in std_logic;
		wr_addr	: in std_logic_vector(W-1 downto 0);
		wr_data	: in std_logic_vector(B-1 downto 0);
		rd_addr	: in std_logic_vector(W-1 downto 0);
		rd_data	: out std_logic_vector(B-1 downto 0)
	) ;
end entity ; -- reg_file

architecture arch of reg_file is
	-- compound type (bidimensional array)
	type reg_file_type is array (integer range 2**W-1 downto 0) of
		std_logic_vector(B-1 downto 0);

	-- internal storage
	signal array_reg : reg_file_type;
begin
	-- synchronous process with asynch reset
	process( clk, reset )
	begin
		if (reset='1') then
			-- asynchronous reset
			array_reg <= (others => (others => '0'));
		elsif (clk'event and clk='1') then
			-- synchronous write
			if (wr_en='1') then
				array_reg(to_integer(unsigned(wr_addr))) <= wr_data; 
			end if;
		end if;
	end process ;

	-- asynchronous read
	rd_data <= array_reg(to_integer(unsigned(rd_addr)));

end architecture ; -- arch
