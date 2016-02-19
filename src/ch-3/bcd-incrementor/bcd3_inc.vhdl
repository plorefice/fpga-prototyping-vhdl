-- Design: 3-digit BCD incrementor
-- Description:
--	Increments the 3-digit binary-coded by the amount specified by cin.
--	Built from three cascaded single-digit BCD incrementors.

library ieee;
use ieee.std_logic_1164.all;

entity bcd3_inc is
	port (
		bcd	: in std_logic_vector(11 downto 0);
		cin	: in std_logic;
		res	: out std_logic_vector(11 downto 0);
		cout	: out std_logic;
		valid	: out std_logic
	) ;
end entity ; -- bcd3_inc

architecture arch of bcd3_inc is
	signal v0, v1, v2 : std_logic;
	signal c0, c1 : std_logic;
	signal r0, r1, r2 : std_logic_vector(3 downto 0);
begin
	-- single-digit BCD incrementors
	bcd0 : entity work.bcd_inc
		port map(bcd => bcd(3 downto 0), cin => cin,
			res => r0, cout => c0, valid => v0);

	bcd1 : entity work.bcd_inc
		port map(bcd => bcd(7 downto 4), cin => c0,
			res => r1, cout => c1, valid => v1);

	bcd2 : entity work.bcd_inc
		port map(bcd => bcd(11 downto 8), cin => c1,
			res => r2, cout => cout, valid => v2);

	-- output signal assignment
	res <= r2 & r1 & r0;
	valid <= v0 and v1 and v2;

end architecture ; -- arch
