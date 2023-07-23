library ieee;
use ieee.std_logic_1164.all;

entity full_adder_tb is
end entity full_adder_tb;

architecture Behavioral of full_adder_tb is
	component full_adder is
		port (
			a	: in std_logic;
			b	: in std_logic;
			cin	: in std_logic;
			s	: out std_logic;
			cout: out std_logic
		);
	end component full_adder;
	
	signal a	: std_logic := '0';
	signal b	: std_logic := '0';
	signal cin	: std_logic := '0';
	signal s	: std_logic;
	signal cout	: std_logic;
	
begin

	FA_INST: full_adder port map (a, b, cin, s, cout);
	
	STIMULUS: process
	begin
	wait for 1 ns;
		a <= '1';
		
		wait for 1 ns;
		b <= '1';

		wait for 1 ns;
		a <= '0';

		wait for 1 ns;
		cin <= '1';

		wait for 1 ns;
		a <= '1';
		
		wait;	
	end process STIMULUS;



end architecture Behavioral;