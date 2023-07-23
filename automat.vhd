library ieee;
use ieee.std_logic_1164.all;

entity automat is
    port (
        clk, reset, n_5, n_10, n_20 : in std_logic;
        voda_out, n5_out, n10_out   : out std_logic
    );
end automat;

architecture Behavioral of automat is
    type State_t is (racunaj, izbaci);
    signal state_reg, next_state : State_t;
    
    constant C_CENA_VODE: integer := 30;
    
    signal suma : integer range 0 to C_CENA_VODE + 15;
    signal novcic : integer range 0 to 20;
    
    constant C_MAX_CNT : integer := 5;
    signal timeout_cnt  : integer range 0 to C_MAX_CNT;
begin
    
    STATE_TRANSITION: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= racunaj;
            else
                state_reg <= next_state;
            end if;
        end if;
    end process STATE_TRANSITION;
    
    NEXT_STATE_LOGIC: process (state_reg, suma, timeout_cnt, next_state) is
    begin
        case (state_reg) is
            when racunaj =>
                if (suma >= C_CENA_VODE) then
                    next_state <= izbaci;
                else
                    next_state <= racunaj;
                end if;            
            when izbaci =>
                if timeout_cnt = C_MAX_CNT - 1 then
                    next_state <= racunaj;
                else
                    next_state <= izbaci;
                end if;
        end case;
    end process NEXT_STATE_LOGIC;
    
    TIMEOUT_PROC: process (clk) is
    begin
        if rising_edge(clk) then
            if state_reg = izbaci then
                timeout_cnt <= timeout_cnt + 1;
            else
                timeout_cnt <= 0;
            end if;
        end if;
    end process TIMEOUT_PROC;
    
    GENERISANJE_SUME: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                suma <= 0;
            else
                case (state_reg) is
                    when racunaj =>
                        suma <= suma + novcic;
                    when izbaci =>
                        if next_state = racunaj then
                            suma <= 0;
                        end if;
                end case;
            end if;
        end if;
    end process GENERISANJE_SUME;
    
    novcic <=   5   when n_5 = '1' else
                10  when n_10 = '1' else
                20  when n_20 = '1' else
                0;
                
    OUTPUT_LOGIC: process (state_reg, suma) is
        variable kusur  : integer range 0 to 15;
    begin
        case state_reg is
            when racunaj =>
                voda_out <= '0';
                n5_out <= '0';
                n10_out <= '0';
            when izbaci =>
                voda_out <= '1';
                kusur := suma - C_CENA_VODE;
                case (kusur) is
                    when 15 =>
                        n5_out <= '1';
                        n10_out <= '1';
                    when 10 =>
                        n5_out <= '0';
                        n10_out <= '1';
                    when 5 =>
                        n5_out <= '1';
                        n10_out <= '0';
                    when others =>
                        n5_out <= '0';
                        n10_out <= '0';
                end case;
        end case;
    end process OUTPUT_LOGIC;
    
    
end architecture Behavioral;