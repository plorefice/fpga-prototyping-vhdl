-- Design: Programmable square wave generator
-- Description:
--	Outputs a square wave with on and off period controlled by the m and n
--	signals.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity square_wave_gen is
	port (
		clk, rst: in std_logic;
		m, n	: in std_logic_vector(3 downto 0);
		q	: out std_logic
	) ;
end entity ; -- square_wave_gen

architecture arch of square_wave_gen is
	signal delta_reg, delta_next : unsigned(3 downto 0);
	signal out_reg, out_next : std_logic;
	signal tick : std_logic;
begin
	-- clock divider
	clk_div : entity work.mod_count
		generic map (N => 3, M => 5)
		port map (clk => clk, rst => rst, en => '1',
			  max => tick, q => open);

	-- register logic
	reg_proc : process (clk, rst)
	begin
		if (rst = '1') then
			delta_reg <= (others => '0');
			out_reg <= '0';
		elsif (clk'event and clk = '1') then
			delta_reg <= delta_next;
			out_reg <= out_next;
		end if ;
	end process ; -- reg_proc

	-- next-state logic
	next_proc : process (out_reg, delta_reg, tick, m, n)
	begin
		out_next <= out_reg;
		delta_next <= delta_reg;

		if (tick = '1') then
			if (delta_reg = 0) then
				out_next <= not out_reg;

				if (out_reg = '0') then
					delta_next <= unsigned(m);
				else
					delta_next <= unsigned(n);
				end if ;
			else
				delta_next <= delta_reg - 1;
			end if ;
		end if ;
	end process ; -- next_proc

	-- output logic
	q <= out_reg;

end architecture ; -- arch
