-- Design: PS2 receiver subsystem

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ps2_rx is
	port (
		clk, rst	: in std_logic;
		ps2d, ps2c	: in std_logic;
		rx_en		: in std_logic;
		rx_done_tick	: out std_logic;
		dout		: out std_logic_vector(7 downto 0)
	) ;
end entity ; -- ps2_rx

architecture arch of ps2_rx is
	type state_type is (idle, data, load);

	signal state_reg, state_next : state_type := idle;

	signal filt_cnt_reg, filt_cnt_next : std_logic_vector(7 downto 0) := (others => '0');
	signal filt_clk_reg, filt_clk_next : std_logic := '0';
	signal fall_edge : std_logic := '0';

	signal n_reg, n_next : unsigned(3 downto 0) := (others => '0');
	signal rx_done_reg, rx_done_next : std_logic := '0';
	signal dout_reg, dout_next : std_logic_vector(9 downto 0) := (others => '0');
begin
	-- FSMD State registers
	process (clk, rst)
	begin
		if (rst = '1') then
			state_reg <= idle;
			filt_cnt_reg <= (others => '0');
			filt_clk_reg <= '0';
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
			filt_cnt_reg <= filt_cnt_next;
			filt_clk_reg <= filt_clk_next;
		end if ;
	end process ;

	-- Deglitching circuit
	filt_cnt_next <= ps2c & filt_cnt_reg(7 downto 1);
	filt_clk_next <= '1' when filt_cnt_reg = "11111111" else
			 '0' when filt_cnt_reg = "00000000" else
			 filt_clk_reg;
	fall_edge <= filt_clk_reg and (not filt_clk_next);

	-- FSMD Control & Data path
	process (state_reg, n_reg, rx_done_reg, dout_reg, ps2d, fall_edge, rx_en)
	begin
		state_next <= state_reg;
		n_next <= n_reg;
		rx_done_next <= rx_done_reg;
		dout_next <= dout_reg;
		
		case state_reg is
			when idle =>
				rx_done_next <= '0';
				if (rx_en = '1' and fall_edge = '1') then
					-- we can safely ignore the start bit
					state_next <= data;
					n_next <= "1001";
				end if ;

			when data =>
				if (fall_edge = '1') then
					dout_next <= ps2d & dout_reg(8 downto 1);
					n_next <= n_reg - 1;
					if (n_reg = "0000") then
						-- I've just received the stop bit
						state_next <= load;
					end if ;
				end if ;

			when load =>
				state_next <= idle;
				rx_done_next <= '1';

		end case ;

	end process ;

	-- output
	rx_done_tick <= rx_done_reg;
	dout <= dout_reg(7 downto 0); -- data bits

end architecture ; -- arch

