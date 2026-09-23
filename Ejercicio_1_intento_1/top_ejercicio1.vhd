library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.counter_pkg.all; -- Llama al paquete con la constante de 8 bits y el componente mod_n_counter

entity top_ejercicio1 is
    Port (
        -- Entradas físicas de la tarjeta FPGA
        clk_50MHz : in  std_logic;                                  -- Reloj interno de la tarjeta (50 MHz)
        rst       : in  std_logic;                                  -- Botón de reset
        en        : in  std_logic;                                  -- Switch de habilitación (enable)
        mod_n     : in  std_logic_vector(COUNTER_WIDTH-1 downto 0); -- 8 Switches para ingresar el límite N
        
        -- Salidas físicas de la tarjeta FPGA
        tc        : out std_logic;                                  -- LED que indica el fin de cuenta
        seg       : out std_logic_vector(6 downto 0)                -- Pines hacia el display de 7 segmentos
    );
end top_ejercicio1;

architecture Structural of top_ejercicio1 is

    -- ==========================================
    -- 1. SEÑALES INTERNAS (Cables de conexión)
    -- ==========================================
    signal clk_1Hz_sig : std_logic; -- Cable que lleva el pulso lento de 1Hz al contador
    signal q_sig       : std_logic_vector(COUNTER_WIDTH-1 downto 0); -- Cable que lleva la cuenta del contador al decodificador

    -- ==========================================
    -- 2. DECLARACIÓN DE COMPONENTES EXISTENTES
    -- ==========================================
    
    -- Componente 1: Tu divisor de frecuencia (¡Verifica que los nombres clk_in y clk_out coincidan con tu archivo!)
    component divisor_1Hz is
        Port ( 
            clk_in  : in  std_logic; 
            clk_out : out std_logic 
        );
    end component;

    -- Componente 2: Tu decodificador de 7 segmentos (¡Verifica los nombres bcd y seg!)
    component decodificador_ssd is
        Port ( 
            bcd : in  std_logic_vector(3 downto 0); 
            seg : out std_logic_vector(6 downto 0) 
        );
    end component;

begin

    -- ==========================================
    -- 3. INSTANCIACIÓN Y "CABLEADO" DE LOS MÓDULOS
    -- ==========================================

    -- Bloque A: Divisor de frecuencia
    -- Toma los 50MHz de la FPGA y saca 1Hz por la señal interna
    U_DIV: divisor_1Hz 
        port map (
            clk_in  => clk_50MHz,
            clk_out => clk_1Hz_sig
        );

    -- Bloque B: Contador Mod-N (El que diseñamos hoy)
    -- Recibe el reloj lento (1Hz), los botones, switches y saca la cuenta a 'q_sig'
    U_COUNT: mod_n_counter 
        port map (
            clk   => clk_1Hz_sig, 
            rst   => rst,
            en    => en,
            mod_n => mod_n,
            q     => q_sig,
            tc    => tc
        );

    -- Bloque C: Decodificador 7 Segmentos
    -- Toma los 4 bits menos significativos (q_sig de 0 a 3) y los convierte para el display
    U_DEC: decodificador_ssd 
        port map (
            bcd => q_sig(3 downto 0), 
            seg => seg
        );

end Structural;