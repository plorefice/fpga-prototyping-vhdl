-- Design: UART transmitter subsystem

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
	generic (
		DBIT	: integer := 8 -- # data bits
	) ;
	port (
		clk, rst: in std_logic;
		tx_start: in std_logic;
		tx_clk	: in std_logic;
		data	: in std_logic_vector(7 downto 0);
		tx_done	: out std_logic;
		txd	: out std_logic
	) ;
end entity ; -- uart_tx

architecture arch of uart_tx is
	type state_type is (idle, start, char, stop);

	signal state_reg, state_next : state_type := idle;
	signal data_reg, data_next : std_logic_vector(7 downto 0) := (others => '0');
	signal txd_reg, txd_next : std_logic := '1';
	signal n_reg, n_next : unsigned(3 downto 0) := (others => '0');
	signal tx_done_reg, tx_done_next : std_logic := '0';
begin
	-- FSMD State & Data registers
	process (clk, rst)
	begin
		if (rst = '1') then
			state_reg <= idle;
			data_reg <= (others => '0');
			txd_reg <= '1';
			n_reg <= (others => '0');
			tx_done_reg <= '0';
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
			data_reg <= data_next;
			txd_reg <= txd_next;
			n_reg <= n_next;
			tx_done_reg <= tx_done_next;
		end if ;
	end process ;

	-- FSMD Control & Data path
	process (state_reg, data_reg, n_reg, tx_start, tx_clk, data)
	begin
		state_next <= state_reg;
		data_next <= data_reg;
		txd_next <= txd_reg;
		n_next <= n_reg;
		tx_done_next <= tx_done_reg;

		case state_reg is
			when idle =>
				tx_done_next <= '0';

				if (tx_start = '1') then
					state_next <= start;
					data_next <= data;
				end if ;

			when start =>
				txd_next <= '0';

				if (tx_clk = '1') then
					state_next <= char;
					n_next <= (others => '0');
				end if ;

			when char =>
				txd_next <= data_reg(0);

				if (tx_clk = '1') then
					data_next <= '0' & data_reg(7 downto 1);

					if (n_reg = to_unsigned(DBIT, 4) - 1) then
						state_next <= stop;
					else
						n_next <= n_reg + 1;
					end if ;
				end if ;

			when stop =>
				txd_next <= '1';

				if (tx_clk = '1') then
					state_next <= idle;
					tx_done_next <= '1';
				end if ;

		end case ;

	end process ;

	-- FSMD output logic
	tx_done <= tx_done_reg;
	txd <= txd_reg;

end architecture ; -- arch

