library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_ejercicio2 is
    Port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC; -- Botón de reinicio
        start        : in  STD_LOGIC; -- Botón de arranque
        stop         : in  STD_LOGIC; -- Botón de parada
        seg_min      : out STD_LOGIC_VECTOR (6 downto 0); -- Display minutos
        seg_sec_dec  : out STD_LOGIC_VECTOR (6 downto 0); -- Display decenas de segundo
        seg_sec_uni  : out STD_LOGIC_VECTOR (6 downto 0)  -- Display unidades de segundo
    );
end top_ejercicio2;

architecture Funcional_Estructural of top_ejercicio2 is

    -- Declaración de los componentes copiados
    component divisor_1Hz is
        Port ( clk_in, reset : in STD_LOGIC; clk_out : out STD_LOGIC );
    end component;

    component decodificador_ssd is
        Port ( bcd_in : in STD_LOGIC_VECTOR(3 downto 0); seg_out : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;

    -- Señales internas
    signal clk_1Hz : STD_LOGIC;
    signal en_ejecucion : boolean := false;
    
    -- Contadores independientes para simplificar la conversión BCD
    signal min_count     : integer range 0 to 9 := 0;
    signal sec_dec_count : integer range 0 to 5 := 0;
    signal sec_uni_count : integer range 0 to 9 := 0;

    -- Señales para BCD
    signal bcd_min     : STD_LOGIC_VECTOR(3 downto 0);
    signal bcd_sec_dec : STD_LOGIC_VECTOR(3 downto 0);
    signal bcd_sec_uni : STD_LOGIC_VECTOR(3 downto 0);

begin
    -- Instancia del reloj de 1 Hz
    U1: divisor_1Hz port map (clk_in => clk, reset => reset, clk_out => clk_1Hz);

    -- Proceso de Control y Conteo
    process(clk_1Hz, reset)
    begin
        if reset = '1' then
            en_ejecucion <= false;
            min_count <= 0;
            sec_dec_count <= 0;
            sec_uni_count <= 0;
        elsif rising_edge(clk_1Hz) then
            
            -- Lógica de botones
            if stop = '1' then
                en_ejecucion <= false;
            elsif start = '1' then
                en_ejecucion <= true;
            end if;

            -- Lógica de conteo en cascada
            if en_ejecucion then
                if sec_uni_count = 9 then
                    sec_uni_count <= 0;
                    
                    if sec_dec_count = 5 then
                        sec_dec_count <= 0;
                        
                        if min_count = 9 then
                            en_ejecucion <= false; -- Tope máximo (9:59), se detiene
                        else
                            min_count <= min_count + 1;
                        end if;
                    else
                        sec_dec_count <= sec_dec_count + 1;
                    end if;
                else
                    sec_uni_count <= sec_uni_count + 1;
                end if;
            end if;
            
        end if;
    end process;

    -- Conversión a binario para los decodificadores
    bcd_min     <= std_logic_vector(to_unsigned(min_count, 4));
    bcd_sec_dec <= std_logic_vector(to_unsigned(sec_dec_count, 4));
    bcd_sec_uni <= std_logic_vector(to_unsigned(sec_uni_count, 4));

    -- Instancias de los decodificadores para los 3 Displays SSD
    U2: decodificador_ssd port map (bcd_in => bcd_min, seg_out => seg_min);
    U3: decodificador_ssd port map (bcd_in => bcd_sec_dec, seg_out => seg_sec_dec);
    U4: decodificador_ssd port map (bcd_in => bcd_sec_uni, seg_out => seg_sec_uni);

end Funcional_Estructural;                          