library ieee;
use ieee.std_logic_1164.all;

entity automat_tb is
end entity automat_tb;

architecture Test of automat_tb is
    
    component automat is
        port (
            clk, reset, n_5, n_10, n_20 : in std_logic;
            voda_out, n5_out, n10_out   : out std_logic
        );
    end component;

    constant C_CLK_PERIOD: time := 20 ns;
    
    signal clk : std_logic := '1';
    signal reset, n_5, n_10, n_20, voda_out, n5_out, n10_out: std_logic;
    
begin
    AUTOMAT_i : automat port map (clk, reset, n_5, n_10, n_20, voda_out, n5_out, n10_out);
    
    clk <= not clk after C_CLK_PERIOD/2;
    
    STIMULUS: process
    begin
        reset <= '1';
        n_5 <= '0';
        n_10 <= '0';
        n_20 <= '0';
        
        wait for 3*C_CLK_PERIOD;
        
        reset <= '0';
        wait for 1*C_CLK_PERIOD;
        
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

end architecture;