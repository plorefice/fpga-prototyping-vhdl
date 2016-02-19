-- Design: 12-to-4 dual-prioriy encoder
-- Description:
--	Returns the binary codes of both the most- and the second-most-
--	significant asserted bit, each with their valid output bit.
--	This design is built from a 12-to-4 priority encoder to detect
--	the highest priority request, then a 4-to-16 decoder to remove it
--	and finally another 12-to-4 priority encoder to detect the second
--	(now first) highest priority request.

library ieee;
use ieee.std_logic_1164.all;

entity dp_enc12 is
	port (
		r	: in std_logic_vector(11 downto 0);
		a, b	: out std_logic_vector(3 downto 0);
		va, vb	: out std_logic
	) ;
end entity ; -- dp_enc12

architecture arch of dp_enc12 is
	signal a_i, b_i : std_logic_vector(3 downto 0);
	signal bcode_o : std_logic_vector(15 downto 0);
	signal r_i : std_logic_vector(11 downto 0);
begin
	-- first priority encoder to obtain the highest priority
	p_enc12_a : entity work.p_enc12
		port map(r => r, prio => a_i, valid => va);

	-- decoder to expand the highest priority code
	dec4 : entity work.dec4
		port map(a => a_i, en => '1', bcode => bcode_o);

	-- zero-out the highest priority request
	r_i <= not bcode_o(11 downto 0) and r;

	-- second priority encoder
	p_enc12_b : entity work.p_enc12
		port map(r => r_i, prio => b_i, valid => vb);

	-- output priorities assignments
	a <= a_i;
	b <= b_i;

end architecture ; -- arch