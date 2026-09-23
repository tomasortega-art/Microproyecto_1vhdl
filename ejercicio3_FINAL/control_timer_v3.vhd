library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_timer_v3 is
    port (
        clk          : in  std_logic;
        reset_global : in  std_logic;
        tick_1s      : in  std_logic;
        btn_in       : in  std_logic; -- Botón activo en '1' (tras adaptación)
        min_out      : out integer range 0 to 9;
        sec_out      : out integer range 0 to 59
    );
end entity control_timer_v3;

architecture Comportamental of control_timer_v3 is

    type estado_btn_type is (IDLE, PRESIONADO, ESPERA_SOLTAR);
    signal estado_btn : estado_btn_type := IDLE;

    signal contador_2s : integer range 0 to 2 := 0;
    signal corriendo   : std_logic := '0';
    signal minutos     : integer range 0 to 9  := 0;
    signal segundos    : integer range 0 to 59 := 0;

    signal req_toggle  : std_logic := '0';
    signal req_reset   : std_logic := '0';

begin

    -- Proceso 1: Detección de duración de pulsación (Corta < 2s / Larga >= 2s)
    process(clk, reset_global)
    begin
        if reset_global = '1' then
            estado_btn  <= IDLE;
            contador_2s <= 0;
            req_toggle  <= '0';
            req_reset   <= '0';
        elsif rising_edge(clk) then
            req_toggle <= '0';
            req_reset  <= '0';

            case estado_btn is
                when IDLE =>
                    contador_2s <= 0;
                    if btn_in = '1' then
                        estado_btn <= PRESIONADO;
                    end if;

                when PRESIONADO =>
                    if btn_in = '1' then
                        if tick_1s = '1' then
                            if contador_2s < 2 then
                                contador_2s <= contador_2s + 1;
                            else
                                -- Cumplió los 2 segundos presionado
                                req_reset  <= '1';
                                estado_btn <= ESPERA_SOLTAR;
                            end if;
                        end if;
                    else
                        -- Se soltó antes de 2s -> Pulsación corta (Start/Stop)
                        req_toggle <= '1';
                        estado_btn <= IDLE;
                    end if;

                when ESPERA_SOLTAR =>
                    if btn_in = '0' then
                        estado_btn <= IDLE;
                    end if;
            end case;
        end if;
    end process;

    -- Proceso 2: Conteo y control del temporizador
    process(clk, reset_global)
    begin
        if reset_global = '1' then
            corriendo <= '0';
            minutos   <= 0;
            segundos  <= 0;
        elsif rising_edge(clk) then
            if req_reset = '1' then
                corriendo <= '0';
                minutos   <= 0;
                segundos  <= 0;
            elsif req_toggle = '1' then
                corriendo <= not corriendo; -- Alterna Arranque / Parada
            end if;

            if corriendo = '1' and tick_1s = '1' and req_reset = '0' then
                if segundos = 59 then
                    segundos <= 0;
                    if minutos = 9 then
                        minutos <= 0;
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