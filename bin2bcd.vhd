library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin2bcd is
	port (
		clk, reset: in STD_LOGIC;
		bin_in: in STD_LOGIC_VECTOR (7 downto 0);
		bcd_out: out STD_LOGIC_VECTOR (11 downto 0)
	);
end entity;

architecture bin2bcd_arch of bin2bcd is

	type state_type is ( Idle, Shift, Add );
	signal state_reg, next_state: state_type;
	
	signal shift_reg: std_logic_vector (19 downto 0);
	
	
	signal shift_cnt: integer range 0 to 7;
	signal bin_int: std_logic_vector (7 downto 0);
	
begin
	state_transition: process (clk, reset)
	begin
		if (reset = '0') then
			state_reg <= Idle;
		elsif rising_edge(clk) then
			state_reg <= next_state;
		end if;
	end process;

	next_state_logic: process (bin_in, bin_int, shift_cnt)
	begin
		case state_reg is
		
			when Idle =>
				if (bin_in /= bin_int) then
					next_state <= Shift;
				else
					next_state <= Idle;
				end if;
			
			when Shift => 
				if (shift_cnt = 0) then
					next_state <= Idle;
				else
					next_state <= Add;
				end if;
			
			when Add =>
				next_state <= Shift;

		end case;	
	end process;
	
	shift_and_output_process: process (clk, reset)
		variable correction: std_logic_vector (19 downto 0);
	begin
		if (reset = '0') then
			shift_reg <= x"00000";
			bcd_out <= x"000";
		elsif (rising_edge(clk)) then
			case (state_reg) is
			
				when Idle =>
					if (next_state = Shift) then
						shift_reg(19 downto 8) <= x"000";
						shift_reg(7 downto 0) <= bin_in;
					end if;
					shift_cnt <= 7;
					bcd_out <= shift_reg(19 downto 8);
				when Shift => 
					shift_reg(19 downto 1) <= shift_reg(18 downto 0);
					shift_reg(0) <= '0';
					shift_cnt <= shift_cnt - 1;
				when Add =>
					correction := x"00000";
					if ( unsigned(shift_reg(19 downto 16)) > 4) then
						correction(19 downto 16) := x"3";
					end if;	
					if ( unsigned(shift_reg(15 downto 12)) > 4) then
						correction(15 downto 12) := x"3";
					end if;
					if ( unsigned(shift_reg(11 downto 8)) > 4) then
						correction(11 downto 8) := x"3";
					end if;
					shift_reg <= std_logic_vector( unsigned(shift_reg) + unsigned(correction) );

			end case;
		end if;
	end process;
	

end bin2bcd_arch;




