-- Design: 12-to-4 prioriy encoder
-- Description:
--	Returns the binary code of the most-significant asserted bit.
--	The valid output is asserted if at least one bit in the request is.
--	This design is built for three 4-to-2 priority encoder, using the
--	VALID bits to both drive a multiplexer to select the lower two bits and
--	derive the higher two bits.

library ieee;
use ieee.std_logic_1164.all;

entity p_enc12 is
	port (
		r	: in std_logic_vector(11 downto 0);
		prio	: out std_logic_vector(3 downto 0);
		valid	: out std_logic
	) ;
end entity ; -- p_enc12

architecture arch of p_enc12 is
	signal prio_h, prio_m, prio_l : std_logic_vector(1 downto 0);
	signal val_h, val_m, val_l : std_logic;
	signal val_sel : std_logic_vector(1 downto 0);
begin
	-- instantiate the three 4-to-2 priority encoder
	p_enc4_h : entity work.p_enc4
		port map(r => r(11 downto 8), prio => prio_h, valid => val_h);

	p_enc4_m : entity work.p_enc4
		port map(r => r(7 downto 4), prio => prio_m, valid => val_m);

	p_enc4_l : entity work.p_enc4
		port map(r => r(3 downto 0), prio => prio_l, valid => val_l);

	-- low output selection logic
	val_sel <= val_h & val_m;
	with val_sel select
		prio(1 downto 0) <= prio_h when "10" | "11",
		                    prio_m when "01",
		                    prio_l when others;

	-- high output combinatorial logic
	prio(3) <= val_h;
	prio(2) <= not val_h and val_m;

	-- valid output logic
	valid <= val_h or val_m or val_l;

end architecture ; -- arch
