library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_ejercicio3 is
    Port (
        clk         : in  STD_LOGIC; -- Reloj principal (Ej. 50 MHz)
        btn_unico   : in  STD_LOGIC; -- Botón único multifunción
        seg_min     : out STD_LOGIC_VECTOR (6 downto 0);
        seg_sec_dec : out STD_LOGIC_VECTOR (6 downto 0);
        seg_sec_uni : out STD_LOGIC_VECTOR (6 downto 0)
    );
end top_ejercicio3;

architecture Funcional of top_ejercicio3 is

    component divisor_1Hz is
        Port ( clk_in, reset : in STD_LOGIC; clk_out : out STD_LOGIC );
    end component;

    component decodificador_ssd is
        Port ( bcd_in : in STD_LOGIC_VECTOR(3 downto 0); seg_out : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;

    signal clk_1Hz : STD_LOGIC;
    
    -- Parámetros para la lectura del botón (asumiendo clk de 50 MHz)
    constant DEBOUNCE_MS : integer := 500000;    -- 10 ms para evitar rebotes
    constant DOS_SEGUNDOS: integer := 100000000; -- 2 segundos a 50 MHz
    
    signal btn_counter : integer range 0 to DOS_SEGUNDOS := 0;
    
    -- Señales de estado del temporizador
    signal en_ejecucion : boolean := false;
    signal flag_reset   : boolean := false;

    -- Contadores
    signal min_count     : integer range 0 to 9 := 0;
    signal sec_dec_count : integer range 0 to 5 := 0;
    signal sec_uni_count : integer range 0 to 9 := 0;
    
    signal bcd_min, bcd_sec_dec, bcd_sec_uni : STD_LOGIC_VECTOR(3 downto 0);

begin

    U1: divisor_1Hz port map (clk_in => clk, reset => '0', clk_out => clk_1Hz);

    -- Proceso 1: Control del botón multifunción
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_unico = '1' then
                -- Si se mantiene presionado, aumenta el contador
                if btn_counter < DOS_SEGUNDOS then
                    btn_counter <= btn_counter + 1;
                end if;
                
                -- Si llega a 2 segundos exactos, dispara el reinicio
                if btn_counter = DOS_SEGUNDOS - 1 then
                    flag_reset <= true;
                    en_ejecucion <= false;
                end if;
            else
                -- Al soltar el botón
                if btn_counter > DEBOUNCE_MS and btn_counter < DOS_SEGUNDOS then
                    -- Fue una pulsación corta válida (Start/Stop alternado)
                    en_ejecucion <= not en_ejecucion;
                end if;
                
                -- Limpieza de variables al soltar
                btn_counter <= 0;
                flag_reset <= false;
            end if;
        end if;
    end process;

    -- Proceso 2: Lógica del temporizador
    process(clk_1Hz, flag_reset)
    begin
        if flag_reset then
            min_count <= 0;
            sec_dec_count <= 0;
            sec_uni_count <= 0;
        elsif rising_edge(clk_1Hz) then
            if en_ejecucion then
                if sec_uni_count = 9 then
                    sec_uni_count <= 0;
                    if sec_dec_count = 5 then
                        sec_dec_count <= 0;
                        if min_count = 9 then
                            en_ejecucion <= false; -- Tope en 9:59
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

    -- Mapeo a binario para displays
    bcd_min     <= std_logic_vector(to_unsigned(min_count, 4));
    bcd_sec_dec <= std_logic_vector(to_unsigned(sec_dec_count, 4));
    bcd_sec_uni <= std_logic_vector(to_unsigned(sec_uni_count, 4));

    -- Instancias SSD
    U2: decodificador_ssd port map (bcd_in => bcd_min, seg_out => seg_min);
    U3: decodificador_ssd port map (bcd_in => bcd_sec_dec, seg_out => seg_sec_dec);
    U4: decodificador_ssd port map (bcd_in => bcd_sec_uni, seg_out => seg_sec_uni);

end Funcional;