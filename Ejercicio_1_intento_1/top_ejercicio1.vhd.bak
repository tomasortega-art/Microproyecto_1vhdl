library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_ejercicio1 is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        persona_in  : in  STD_LOGIC; -- '1' indica espacio ocupado
        alarma_led  : out STD_LOGIC; -- LED de cobro/exceso de tiempo
        seg_decenas : out STD_LOGIC_VECTOR (6 downto 0);
        seg_unidades: out STD_LOGIC_VECTOR (6 downto 0)
    );
end top_ejercicio1;

architecture Estructural of top_ejercicio1 is

    -- Declaración de Componentes
    component divisor_1Hz is
        Port ( clk_in, reset : in STD_LOGIC; clk_out : out STD_LOGIC );
    end component;

    component decodificador_ssd is
        Port ( bcd_in : in STD_LOGIC_VECTOR(3 downto 0); seg_out : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;

    -- Señales internas
    signal clk_1Hz : STD_LOGIC;
    signal segundos : integer range 0 to 99 := 0;
    type estado_type is (ESPERA, CONTEO_35S, TIEMPO_EXTRA);
    signal estado_actual : estado_type := ESPERA;
    
    signal bcd_decenas  : STD_LOGIC_VECTOR(3 downto 0);
    signal bcd_unidades : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Instancia del Divisor de Reloj
    U1: divisor_1Hz port map ( clk_in => clk, reset => reset, clk_out => clk_1Hz );

    -- Máquina de Estados (FSM)
    process(clk_1Hz, reset)
    begin
        if reset = '1' then
            estado_actual <= ESPERA;
            segundos <= 0;
            alarma_led <= '0';
        elsif rising_edge(clk_1Hz) then
            case estado_actual is
                when ESPERA =>
                    segundos <= 0;
                    alarma_led <= '0';
                    if persona_in = '1' then
                        estado_actual <= CONTEO_35S;
                    end if;

                when CONTEO_35S =>
                    if persona_in = '0' then
                        estado_actual <= ESPERA; -- Persona salió a tiempo
                    elsif segundos = 35 then
                        estado_actual <= TIEMPO_EXTRA;
                        segundos <= 0; -- Inicia contador de tiempo extra
                        alarma_led <= '1';
                    else
                        segundos <= segundos + 1;
                    end if;

                when TIEMPO_EXTRA =>
                    if persona_in = '0' then
                        estado_actual <= ESPERA; -- Persona se retira
                    else
                        segundos <= segundos + 1;
                    end if;
            end case;
        end if;
    end process;

    -- Conversión BCD
    bcd_decenas  <= std_logic_vector(to_unsigned(segundos / 10, 4));
    bcd_unidades <= std_logic_vector(to_unsigned(segundos rem 10, 4));

    -- Instancias de Decodificadores SSD
    U2: decodificador_ssd port map ( bcd_in => bcd_decenas, seg_out => seg_decenas );
    U3: decodificador_ssd port map ( bcd_in => bcd_unidades, seg_out => seg_unidades );

end Estructural;