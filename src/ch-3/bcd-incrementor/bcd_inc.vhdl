-- Design: Single-digit BCD incrementor
-- Description:
--	Increments the input by cin, and outputs the result and the carry.
--	Both the input and the output are interpreted as a
--	binary-coded-decimal digit.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_inc is
	port (
		bcd	: in std_logic_vector(3 downto 0);
		cin	: in std_logic;
		res	: out std_logic_vector(3 downto 0);
		cout	: out std_logic;
		valid	: out std_logic
	) ;
end entity ; -- bcd_inc

architecture arch of bcd_inc is
	signal dgt_u : unsigned(3 downto 0);
	signal cin_u : unsigned(3 downto 0);

	signal add_i : std_logic_vector(3 downto 0);
begin
	-- convert to unsigned and expand for easier operations
	dgt_u <= unsigned(bcd);
	cin_u <= (0 => cin, others => '0');

	-- increment the input
	add_i <= std_logic_vector(dgt_u + cin_u);

	-- outputs
	res <= "0000" when add_i = "1010" else
	       add_i;

	-- compute the carry
	cout <= add_i(3) and (add_i(2) or add_i(1));

	-- input validity bit
	valid <= not (bcd(3) and (bcd(2) or bcd(1)));

end architecture ; -- arch
