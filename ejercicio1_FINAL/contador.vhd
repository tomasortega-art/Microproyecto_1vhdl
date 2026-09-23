library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        tick_1s      : in  std_logic;
        ena_contador : in  std_logic;
        rst_contador : in  std_logic;
        fin_35s      : out std_logic;
        cuenta_out   : out integer range 0 to 99
    );
end entity contador;

architecture Comportamental of contador is
    signal cuenta : integer range 0 to 99 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            cuenta  <= 0;
        elsif rising_edge(clk) then
            if rst_contador = '1' then
                cuenta  <= 0;
            elsif ena_contador = '1' and tick_1s = '1' then
                if cuenta < 99 then
                    cuenta <= cuenta + 1;
                end if;
            end if;
        end if;
    end process;

    cuenta_out <= cuenta;
    -- Señal puramente combinacional: es '1' en cuanto llega a 35
    fin_35s <= '1' when cuenta >= 35 else '0'; 

end architecture Comportamental;