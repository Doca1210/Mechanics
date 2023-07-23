library ieee;
use ieee.std_logic_1164.all;

entity add_sub_8b_tb is
end add_sub_8b_tb;

architecture Test of add_sub_8b_tb is
	component add_sub_8b is
		port (
			a	  : in std_logic_vector(7 downto 0);
			b     : in std_logic_vector(7 downto 0);
			sel	  : in std_logic;
			result: out std_logic_vector(7 downto 0)
		);
	end component;

	signal a	: std_logic_vector(7 downto 0) := "00000000";
	signal b	: std_logic_vector(7 downto 0) := x"00";
	signal sel	: std_logic := '0';
	signal s	: std_logic_vector(7 downto 0);
begin 
	ADD8B_INST : add_sub_8b port map(a, b, sel, s);

	STIMULUS: process
	begin
		wait for 1 ns;
		a <= "01001001";

		wait for 1 ns;
		b <= "10000100";

		wait for 1 ns;
		a <= "00000011";

		wait for 1 ns;
		sel <= '1';

		wait for 1 ns;
		b <= "00001100";
		wait;
	end process STIMULUS;

end Test;