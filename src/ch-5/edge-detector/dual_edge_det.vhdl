-- Design: Dual-edge detector
-- Description:
--	The output is asserted when the input sequence 0 - 1 - 0 is detected.

library ieee;
use ieee.std_logic_1164.all;

entity dual_edge_det is
	port (
		clk, rst: in std_logic;
		level	: in std_logic;
		tick	: out std_logic
	) ;
end entity ; -- dual_edge_det

architecture moore_arch of dual_edge_det is
	type state_type is (zero, one, edge);
	signal state_reg, state_next : state_type;
begin
	-- state register
	state_proc : process (clk, rst)
	begin
		if (rst = '1') then
			state_reg <= zero;
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
		end if ;
	end process ; -- state_proc

	-- next-state / output logic
	nso_proc : process (state_reg, level)
	begin
		state_next <= state_reg; -- default next state
		tick <= '0'; -- default output

		case state_reg is
			when zero =>
				if (level = '1') then
					state_next <= one;
				end if ;
			when one =>
				if (level = '0') then
					state_next <= edge;
				end if ;
			when edge =>
				tick <= '1'; -- assert output

				if (level = '1') then
					state_next <= one;
				else
					state_next <= zero;
				end if ;
		end case ;

	end process ; -- nso_proc

end architecture ; -- moore_arch
