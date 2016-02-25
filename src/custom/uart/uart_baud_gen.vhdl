-- Design: Baud rate generator for a UART transceiver

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_baud_gen is
	generic (
		DIV	: integer := 5208	-- clock divider for 9600 bps
	) ;
	port (
		clk, rst: in std_logic;		-- clock and reset
		en	: in std_logic;		-- enable generator
		tx_tick	: out std_logic;	-- transmitter tick
		rx_tick : out std_logic		-- receiver tick
	) ;
end entity ; -- uart_baud_gen

architecture arch of uart_baud_gen is
	constant RX_DIV : unsigned := to_unsigned(DIV / 16, 16);

	type state_type is (idle, running);

	signal state_reg, state_next : state_type := idle;
	signal rx_cnt_reg, rx_cnt_next : unsigned(15 downto 0) := (others => '0');
	signal n_reg, n_next : unsigned(3 downto 0) := (others => '0');
	signal rx_en : std_logic;
begin
	-- register process
	process (clk, rst)
	begin
		if (rst = '1') then
			state_reg <= idle;
			rx_cnt_reg <= (others => '0');
			n_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
			rx_cnt_reg <= rx_cnt_next;
			n_reg <= n_next;
		end if ;
	end process ;

	-- FSMD
	process (state_reg, rx_cnt_reg, n_reg, en)
	begin
		state_next <= state_reg;
		rx_cnt_next <= rx_cnt_reg;
		n_next <= n_reg;

		case state_reg is
			when idle =>
				if (en = '1') then
					state_next <= running;
					rx_cnt_next <= (others => '0');
					n_next <= (others => '0');
				end if ;

			when running =>
				if (en = '0') then
					state_next <= idle;
				else
					rx_cnt_next <= rx_cnt_reg + 1;
					if (rx_en = '1') then
						rx_cnt_next <= (others => '0');
						n_next <= n_reg + 1;
					end if ;
				end if ;
		end case ;
	end process ;

	-- output logic
	rx_en <= '1' when rx_cnt_reg = (RX_DIV - 1) else '0';

	tx_tick <= '1' when (n_reg = "1111" and rx_en = '1') else '0';
	rx_tick <= rx_en;

end architecture ; -- arch

