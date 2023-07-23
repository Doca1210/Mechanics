library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcdto7seg is
	port
	(
		-- Input ports
		digit	: in  STD_LOGIC_VECTOR (3 downto 0);
		-- Output ports
		display	: out STD_LOGIC_VECTOR (6 downto 0)
	);
end bcdto7seg;

architecture arch of bcdto7seg is
begin
	process(digit) is
	begin
		case digit is
			when "0000" => display <= "1000000";
			when "0001" => display <= "1111001";
			when "0010" => display <= "0100100";
			when "0011" => display <= "0110000";
			when "0100" => display <= "0011001";
			when "0101" => display <= "0010010";
			when "0110" => display <= "0000010";
			when "0111" => display <= "1111000";
			when "1000" => display <= "0000000";
			when "1001" => display <= "0010000";
			when "1010" => display <= "0111111";
			when others => display <= "0000110";
		end case;
	end process;
end arch;