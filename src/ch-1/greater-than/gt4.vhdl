-- Design: 4-bits greater-than circuit
-- Description:
--	Compares two 4-bit inputs a and b.
--	The output is asserted if a > b.

library ieee;
use ieee.std_logic_1164.all;

entity gt4 is
	port (
		a, b	: in std_logic_vector(3 downto 0);
		gt	: out std_logic
	) ;
end entity ; -- gt4

architecture struc_arch of gt4 is
	signal gt_h, gt_l, eq_h: std_logic;
begin
	-- 2-bit greater-than circuit for the high bits
	gt2_high: entity work.gt2(sop_arch)
		port map(a => a(3 downto 2), b => b(3 downto 2), gt => gt_h);

	-- 2-bit greater-than circuit for the low bits
	gt2_low: entity work.gt2(sop_arch)
		port map(a => a(1 downto 0), b => b(1 downto 0), gt => gt_l);

	-- 2-bit comparator circuit for the high bits
	cmp2_high: entity work.cmp2(struc_arch)
		port map(a => a(3 downto 2), b => b(3 downto 2), eq => eq_h);

	-- output logic
	gt <= gt_h or (eq_h and gt_l);
end architecture ; -- sop_arch
