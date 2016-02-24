-- Design: Time-multiplexer with LED patterns
-- Description:
--	Time-multiplexing circuit to drive the LED display.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity disp_mux is
	port (
		clk, rst		: in std_logic;
		in0, in1, in2, in3	: in std_logic_vector(7 downto 0);
		sseg			: out std_logic_vector(7 downto 0);
		en			: out std_logic_vector(3 downto 0)
	) ;
end entity ; -- disp_mux

architecture arch of disp_mux is
	constant N : integer := 18; -- refresh rate
	signal r_reg, r_next : unsigned(N-1 downto 0);
	signal sel : std_logic_vector(1 downto 0);
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
	sel <= std_logic_vector(r_reg(N-1 downto N-2));

	with sel select
		sseg <= in0 when "00",
			in1 when "01",
			in2 when "10",
			in3 when others;

	-- decoder required for display selector
	dec : entity work.dec2
		port map (a => sel, en => '1', bcode => en);

end architecture ; -- arch


