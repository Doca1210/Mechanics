library ieee;
use ieee.std_logic_1164.all;

entity add_sub_8b is
	port(
		a	  : in std_logic_vector(7 downto 0);
		b	  : in std_logic_vector(7 downto 0);
		sel   : in std_logic;
		result: out std_logic_vector(7 downto 0)
	);

end add_sub_8b;

architecture Rtl of add_sub_8b is

	component adder_8b is
		port (
			a	: in std_logic_vector(7 downto 0);
			b	: in std_logic_vector(7 downto 0);
			cin	: in std_logic;
			s	: out std_logic_vector(7 downto 0);
			cout: out std_logic
		);
	end component;
	
	signal b_not	: std_logic_vector(7 downto 0);
	signal mux_out	: std_logic_vector(7 downto 0);
	signal s_int	: std_logic_vector(7 downto 0);

begin

	ADDER_INST: adder_8b port map (a => a, b => mux_out, cin => sel, s => s_int, cout => open);
	
	b_not <= not b;

	MUX_PROC: process(sel, b, b_not) is
	begin
		if(sel = '0') then
			mux_out <= b;
		else
			mux_out <= b_not;
		end if;
	end process MUX_PROC;
	
	result <= s_int;

end architecture Rtl;