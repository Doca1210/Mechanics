library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity diff is
	port (
		clk : in std_logic;
		reset : in std_logic;
		btn : in std_logic;
		req : out std_logic
	);
end diff;

architecture behav of diff is
	type state is (s0, s1, s2, s3, s4);
	signal state_reg, next_state : state;
	signal count: integer range 0 to 1001;

begin

	process (clk, reset)
	begin
		if (reset = '0') then
			state_reg <= s0;
		elsif rising_edge(clk) then
			state_reg <= next_state;
		end if;
	end process;

	process (state_reg, btn, count)
	begin
		case state_reg is
			when s0 =>
				if btn = '0' then
					next_state <= s1;
				else
					next_state <= s0;
				end if;
			when s1 => 
				if ((count = 1000)) then
					next_state <= s2;
				else
					next_state <= s1;
				end if;
			when s2 =>
				if (btn = '0') then
					next_state <= s3;
				else 
					next_state <= s0;
				end if;
			when s3 =>
				next_state <= s4;
			when s4 =>
				if (btn = '1') then
					next_state <= s0;
				else
					next_state <= s4;
				end if;
		end case;
	end process;

	count_process: process (clk, reset)
	begin
		if (reset = '0') then
			count <= 0;
		elsif rising_edge(clk) then
				if (state_reg = s1) then
					count <= count + 1;
				else 
					count <= 0;
				end if;
		end if;
	end process;

	req <= '1' when state_reg = s3 else
			 '0';

end behav;