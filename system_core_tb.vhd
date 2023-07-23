library ieee;
use ieee.std_logic_1164.all;

entity system_core_tb is
end entity system_core_tb;

architecture Test of system_core_tb is
	component system_core is
		port (
		clk	 	   : in std_logic;
		reset	   : in std_logic;
		next_num   : in std_logic;
		plus	   : in std_logic;
		minus	   : in std_logic;
		num		   : in std_logic_vector(7 downto 0);
		display_num: out std_logic_vector(7 downto 0);
	);
	end component;
	
	constant C_CLK_PERIOD: time := 20 ns;
	
	signal clk : std_logic := '1';
	signal reset, next_num, plus, minus, num, display_num: std_logic;

begin

	AUTOMAT_i: automat port map (clk, reset, n_5, n_10, n_20, n5_out, n10_out, voda_out);
	
	clk <= not clk after C_CLK_PERIOD/2;
	
	STIMULUS: process 
	begin
		reset <= '1';
		n_5 <= '0';
		n_10 <= '0';
		n_20 <= '0';
		
		wait for 3*C_CLK_PERIOD;
		
		reset <= '0';
	
		wait for C_CLK_PERIOD;
		n_5 <= '1';
		wait for C_CLK_PERIOD;
		n_5 <= '0';
		wait for 2*C_CLK_PERIOD;
		n_20 <= '1';
		wait for C_CLK_PERIOD;
		n_20 <= '0';
		wait for 4*C_CLK_PERIOD;
		n_10 <= '1';
		wait for C_CLK_PERIOD;
		n_10 <= '0';
		
		wait;
	end process STIMULUS;

end architecture Test;