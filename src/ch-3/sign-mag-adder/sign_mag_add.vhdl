-- Design: Sign-magnitude adder
-- Description:
--	Sum two numbers in sign-magnitude form.
--	A number in sign-magnitude form has its MSB representing
--	the sign, while the remaining bits represent the magnitude.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_mag_add is
	generic (N: integer := 4); -- default: 4 bits
	port (
		a, b	: in std_logic_vector(N-1 downto 0);
		sum	: out std_logic_vector(N-1 downto 0)
	) ;
end entity ; -- sign_mag_add

architecture arch of sign_mag_add is
	signal sign_a, sign_b, sign_sum : std_logic;
	signal mag_a, mag_b, mag_sum : unsigned(N-2 downto 0);
	signal max, min : unsigned(N-2 downto 0);
begin
	sign_a <= a(N-1);
	sign_b <= b(N-1);
	mag_a <= unsigned(a(N-2 downto 0));
	mag_b <= unsigned(b(N-2 downto 0));

	-- sort according to sign and magnitude
	sort : process( sign_a, sign_b, mag_a, mag_b )
	begin
		if mag_a > mag_b then
			max <= mag_a;
			min <= mag_b;
			sign_sum <= sign_a;
		else
			max <= mag_b;
			min <= mag_a;
			sign_sum <= sign_b;
		end if;
	end process ; -- sort

	-- perform sum
	mag_sum <= max + min when sign_a = sign_b else
	           max - min;

	-- put result together
	sum <= std_logic_vector(sign_sum & mag_sum);

end architecture ; -- arch
