library ieee;
use ieee.std_logic_1164.all;

entity adder_8b is
	port (
		a	  : in std_logic_vector(7 downto 0);
		b	  : in std_logic_vector(7 downto 0);
		cin	  : in std_logic;
		s	  :	out std_logic_vector(7 downto 0);
		cout  : out std_logic
	);
end entity adder_8b;

architecture Structural of adder_8b is

	component full_adder is
		port (
			a	: in std_logic;
			b	: in std_logic;
			cin	: in std_logic;
			s	: out std_logic;
			cout: out std_logic
		);
	end component full_adder;

	signal carries : std_logic_vector(8 downto 0);
begin
	
	FAs: for i in 0 to 7 generate
		FAi: full_adder port map (a(i), b(i), carries(i), s(i), carries(i+1));
	end generate;

	carries(0) <= cin;

	cout <= carries(8);
	
end architecture Structural;