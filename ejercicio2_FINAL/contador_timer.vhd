library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador_timer is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        tick_1s   : in  std_logic;
        btn_start : in  std_logic;
        btn_stop  : in  std_logic;
        min_out   : out integer range 0 to 9;
        sec_out   : out integer range 0 to 59
    );
end entity contador_timer;

architecture Comportamental of contador_timer is
    signal corriendo : std_logic := '0';
    signal minutos   : integer range 0 to 9  := 0;
    signal segundos  : integer range 0 to 59 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            corriendo <= '0';
            minutos   <= 0;
            segundos  <= 0;
        elsif rising_edge(clk) then
            -- Lógica de control de estado (Start / Stop)
            if btn_start = '1' then
                corriendo <= '1';
            elsif btn_stop = '1' then
                corriendo <= '0';
            end if;

            -- Lógica del temporizador
            if corriendo = '1' and tick_1s = '1' then
                if segundos = 59 then
                    segundos <= 0;
                    if minutos = 9 then
                        minutos <= 0; -- Reinicia al llegar a 9:59
                    else
                        minutos <= minutos + 1;
                    end if;
                else
                    segundos <= segundos + 1;
                end if;
            end if;
        end if;
    end process;

    min_out <= minutos;
    sec_out <= segundos;
end architecture Comportamental;