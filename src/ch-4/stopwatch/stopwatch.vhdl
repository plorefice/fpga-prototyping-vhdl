-- Design: Stopwatch
-- Description:
--	Counts from 00.0 to 99.9 seconds and wraps around. The output is
--	represented in BCD form. Additional inputs are a synchronous clear
--	signal clr, and a go signal to start and stop the counting.

library ieee;
use ieee.std_logic_1164.all;

entity stopwatch is
	port (
		clk, rst	: in std_logic;
		clr, go		: in std_logic;
		d2, d1, d0	: out std_logic_vector(3 downto 0)
	) ;
end entity ; -- stopwatch

architecture arch of stopwatch is
	constant DVDR : integer := 4; -- clock divider
	signal tick, enable : std_logic;
	signal d2_reg, d1_reg, d0_reg : std_logic_vector(3 downto 0);
	signal d2_next, d1_next, d0_next : std_logic_vector(3 downto 0);
	signal bcd_reg, bcd_next : std_logic_vector(11 downto 0);
begin
	-- clock divider circuitry (mod-m counter)
	clk_div : entity work.mod_count
		generic map (N => 23, M => DVDR)
		port map (clk => clk, rst => rst, en => go,
			  max => tick, q => open);

	-- register logic
	reg_proc : process (clk, rst)
	begin
		if (rst = '1') then
			d2_reg <= (others => '0');
			d1_reg <= (others => '0');
			d0_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			d2_reg <= d2_next;
			d1_reg <= d1_next;
			d0_reg <= d0_next;
		end if ;
	end process ; -- reg_proc

	-- next-state logic
	d2_next <= bcd_next(11 downto 8) when clr = '0' else (others => '0');
	d1_next <= bcd_next(7 downto 4) when clr = '0' else (others => '0');
	d0_next <= bcd_next(3 downto 0) when clr = '0' else (others => '0');

	-- cascaded BCD incrementors
	bcd_reg <= d2_reg & d1_reg & d0_reg;
	enable <= go and tick;

	bcd_inc : entity work.bcd3_inc
		port map (bcd => bcd_reg, cin => enable, res => bcd_next,
			cout => open, valid => open);

	-- output logic
	d2 <= d2_reg;
	d1 <= d1_reg;
	d0 <= d0_reg;

end architecture ; -- arch

