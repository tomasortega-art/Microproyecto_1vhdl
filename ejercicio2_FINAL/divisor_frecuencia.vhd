library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divisor_frecuencia is
    generic (
        FREQ_RELOJ_IN : integer := 50_000_000 -- Reloj interno de FPGA (50 MHz)
    );
    port (
        clk_fpga : in  std_logic;
        reset    : in  std_logic;
        tick_1s  : out std_logic
    );
end entity divisor_frecuencia;

architecture Comportamental of divisor_frecuencia is
    signal contador : integer range 0 to FREQ_RELOJ_IN - 1 := 0;
begin
    process(clk_fpga, reset)
    begin
        if reset = '1' then
            contador <= 0;
            tick_1s  <= '0';
        elsif rising_edge(clk_fpga) then
            if contador = FREQ_RELOJ_IN - 1 then
                contador <= 0;
                tick_1s  <= '1'; -- Genera un pulso cada 1 segundo
            else
                contador <= contador + 1;
                tick_1s  <= '0';
            end if;
        end if;
    end process;
end architecture Comportamental;