library ieee;
use ieee.std_logic_1164.all;

entity system_core is
	port (
		clk	 	   : in std_logic;
		reset	   : in std_logic;
		next_num   : in std_logic;
		plus	   : in std_logic;
		minus	   : in std_logic;
		num		   : in std_logic_vector(7 downto 0);
		display_num: out std_logic_vector(7 downto 0);
	);
end entity system_core;

architecture Behavioral of system_core is
	component add_sub_8b is
		port(
			a	  : in std_logic_vector(7 downto 0);
			b	  : in std_logic_vector(7 downto 0);
			sel   : in std_logic;
			result: out std_logic_vector(7 downto 0)
		);
	end add_sub_8b;
	
	type State_t is (init, read_A, read_B, ADD, SUB);
	signal state_reg, next_state : State_t;
	
	signal a	 : std_logic_vector(7 downto 0);
	signal b	 : std_logic_vector(7 downto 0);
	signal sel   : std_logic;
	signal result: std_logic_vector(7 downto 0);
	
	signal timeout_cnt : integer range 0 to 10;

begin
	
	ADDER_INST: add_sub_8b port map (a, b, sel, result);
	
	STATE_TRANSITION: process(clk) is
	begin
		if(rising_edge(clk)) then
			if reset = '0' then
				state_reg <= init;
			else
				state_reg <= next_state;
		end if;	
	end process STATE_TRANSITION;
	
	NEXT_STATE_LOGIC: process(state_reg, timeout_cnt) is
	begin
		case(state_reg) is
			when init =>
				if reset = '0' then
					next_state <= init;
					display_num <= x"00";
				end if;
				if(next_num = '1') then
					next_state <= read_A;
				else
					next_state <= init;
				end if;
			when read_A =>
				if next_num = '1' then
					next_state <= read_B;
				else
					next_state <= read_A;
				end if;
			when read_B =>
				if plus = '1' then
					sel <= '1';
					next_state <= ADD;
				elsif minus = '1' then
					sel <= '0';
					next_state <= SUB;
				end if;
			when ADD =>
				if timeout_cnt = 10 then
					next_state <= init;
				else
					next_state <= ADD;
				end if;
			when SUB =>
				if timeout_cnt = 10 then
					next_state <= init;
				else
					next_state <= SUB;
				end if;
		end case;
	end process NEXT_STATE_LOGIC;
	
	LOAD: process(state_reg) is
	begin
		case state_reg is
			when read_A =>
				a <= num;
			when read_B =>
				b <= num;
		end case;	
	end process LOAD;

	TIMEOUT_PROC: process (clk) is
	begin
		if rising_edge(clk) then
			if state_reg = ADD or state_reg = SUB then
				timeout_cnt <= timeout_cnt + 1;
			else
				timeout_cnt <= 0;
			end if;
		end if;
	end process TIMEOUT_PROC;
	
	OUTPUT_LOGIC: process(state_reg) is
	begin
		 case state_reg is
			when init =>
				if reset = '0' then
					display_num <= x"00";
				end if;
			when read_A =>
				display_num <= num;
			when read_B =>
				display_num <= num;
			when ADD =>
				display_num <= result;
			when SUB =>
				display_num <= result;
		end case;
	end process OUTPUT_LOGIC;


end architecture Behavioral;