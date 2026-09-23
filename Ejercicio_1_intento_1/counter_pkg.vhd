library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package counter_pkg is
    -- Definición del ancho de bits para el contador. 
    -- 8 bits permiten contar hasta 255, suficiente para conectarlo al display.
    constant COUNTER_WIDTH : integer := 8;

    -- Declaración del componente para que pueda ser llamado por top_ejercicio1.vhd
    component mod_n_counter is
        Port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            en    : in  std_logic;
            mod_n : in  std_logic_vector(COUNTER_WIDTH-1 downto 0);
            q     : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
            tc    : out std_logic
        );
    end component;
end package counter_pkg;