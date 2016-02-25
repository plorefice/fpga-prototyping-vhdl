-- Design: UART receiver subsystem

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
	generic (
		DBIT	: integer := 8 -- # data bits
	) ;
	port (
		clk, rst: in std_logic;
		rx_clk	: in std_logic;
		rxd	: in std_logic;
		rx_done	: out std_logic;
		data	: out std_logic_vector(DBIT-1 downto 0)
	) ;
end entity ; -- uart_rx

architecture arch of uart_rx is
	type state_type is (idle, start, data, stop);

	signal state_reg, state_next : state_type := idle;
	signal data_reg, data_next : std_logic_vector(DBIT-1 downto 0) := (others => '0');
	signal n_reg, n_next : unsigned(3 downto 0) := (others => '0');
	signal s_tick_reg, s_tick_next : unsigned(3 downto 0) := (others => '0');
	signal rx_done_reg, rx_done_next : std_logic := '0';
begin
	-- FSMD State & Data registers
	process (clk, rst)
	begin
		if (rst = '1') then
			state_reg <= idle;
			data_reg <= (others => '0');
			s_tick_reg <= (others => '0');
			n_reg <= (others => '0');
			rx_done_reg <= '0';
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
			data_reg <= data_next;
			s_tick_reg <= s_tick_next;
			n_reg <= n_next;
			rx_done_reg <= rx_done_next;
		end if ;
	end process ;

	-- FSMD Control & Data path
	process (state_reg, data_reg, n_reg, s_tick_reg, rx_clk, rxd)
	begin
		state_next <= state_reg;
		data_next <= data_reg;
		s_tick_next <= s_tick_reg;
		n_next <= n_reg;
		rx_done_next <= rx_done_reg;

		case state_reg is
			when idle =>
				rx_done_next <= '0';

				if (rxd = '0') then
					state_next <= start;
					s_tick_next <= (others => '0');
				end if ;

			when start =>
				if (rx_clk = '1') then
					if (s_tick_reg = "0111") then
						state_next <= data;
						n_next <= (others => '0');
						s_tick_next <= (others => '0');
					else
						s_tick_next <= s_tick_reg + 1;
					end if ;
				end if ;

			when data =>
				s_tick_next <= s_tick_reg + 1;

				if (rx_clk = '1' and s_tick_reg = "1111") then
					data_next <= rxd & data_reg(7 downto 1);
					n_next <= n_reg + 1;

					if (n_reg = to_unsigned(DBIT, 4) - 1) then
						state_next <= stop;
					end if ;
				end if ;

			when stop =>
				s_tick_next <= s_tick_reg + 1;

				if (rx_clk = '1' and s_tick_reg = "1111") then
					state_next <= idle;
					rx_done_next <= '1';
				end if ;

		end case ;

	end process ;

	-- FSMD output logic
	rx_done <= rx_done_reg;
	data <= data_reg;

end architecture ; -- arch
