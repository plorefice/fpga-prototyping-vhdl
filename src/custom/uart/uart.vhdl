-- Design: UART transceiver interface

library ieee;
use ieee.std_logic_1164.all;

entity uart is
	generic (
		DBIT	: integer := 8;		-- # data bits
		DVSR	: integer := 164	-- clock divisor (50MHz / (16 * baud))
	) ;
	port (
		clk, rst, en		: in std_logic;
		rd, wr, rx		: in std_logic;
		w_data			: in std_logic_vector(DBIT-1 downto 0);
		rx_valid, tx_rdy, tx	: out std_logic;
		r_data			: out std_logic_vector(DBIT-1 downto 0)
	) ;
end entity ; -- uart

architecture arch of uart is
	signal tx_clk, rx_clk : std_logic;
	signal tx_done, rx_done : std_logic;

	signal rx_valid_reg : std_logic;
	signal tx_rdy_reg : std_logic;
begin
	-- Baud rate generator
	br_gen : entity work.uart_baud_gen
		generic map (DVSR => DVSR)
		port map (clk => clk, rst => rst, en => en,
			  tx_clk => tx_clk, rx_clk => rx_clk);

	-- UART transmitter
	uart_tx : entity work.uart_tx
		generic map (DBIT => DBIT)
		port map (clk => clk, rst => rst, tx_start => wr, txd => tx,
			  tx_clk => tx_clk, data => w_data, tx_done => tx_done);

	-- UART receiver
	uart_rx : entity work.uart_rx
		generic map (DBIT => DBIT)
		port map (clk => clk, rst => rst, rx_clk => rx_clk, rxd => rx,
			  rx_done => rx_done, data => r_data);

	-- registers update
	process (clk, rst)
	begin
		if (rst = '1') then
			rx_valid_reg <= '0';
			tx_rdy_reg <= '1';
		elsif (clk'event and clk = '1') then
			if (tx_done = '1') then
				tx_rdy_reg <= '1';
			elsif (wr = '1') then
				tx_rdy_reg <= '0';
			end if ;

			if (rx_done = '1') then
				rx_valid_reg <= '1';
			elsif (rd = '1') then
				rx_valid_reg <= '0';
			end if ;
		end if ;
	end process ;

	-- outputs
	rx_valid <= rx_valid_reg;
	tx_rdy <= tx_rdy_reg;

end architecture ; -- arch
