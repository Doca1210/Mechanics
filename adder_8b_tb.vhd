library ieee;
use ieee.std_logic_1164.all;

entity adder_8b_tb is
end adder_8b_tb;

architecture Test of adder_8b_tb is
	component adder_8b is
		port (
			a	  : in std_logic_vector(7 downto 0);
			b	  : in std_logic_vector(7 downto 0);
			cin	  : in std_logic;
			s	  : out std_logic_vector(7 downto 0);
			cout: out std_logic
		);
	end component;

	signal a	: std_logic_vector(7 downto 0) := "00000000";
	signal b	: std_logic_vector(7 downto 0) := x"00";
	signal cin	: std_logic := '0';
	signal s	: std_logic_vector(7 downto 0);
	signal cout : std_logic;

begin 
	ADD8B_INST : adder_8b port map(a, b, cin, s, cout);

	STIMULUS: process
	begin
		wait for 1 ns;
		a <= "00001001";

		wait for 1 ns;
		b <= "00000100";

		wait for 1 ns;
		a <= "00000111";

		wait for 1 ns;
		cin <= '1';

		wait for 1 ns;
		b <= "00001100";
		wait;
	end process STIMULUS;

end Test;