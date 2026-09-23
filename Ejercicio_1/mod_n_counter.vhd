library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.counter_pkg.all; -- Llama al paquete que creamos arriba

entity mod_n_counter is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        en    : in  std_logic;
        mod_n : in  std_logic_vector(COUNTER_WIDTH-1 downto 0); -- Límite N ingresado por switches
        q     : out std_logic_vector(COUNTER_WIDTH-1 downto 0); -- Salida del conteo actual
        tc    : out std_logic                                   -- Señal de Terminal Count (Fin de cuenta)
    );
end mod_n_counter;

architecture Behavioral of mod_n_counter is
    -- Registro interno de tipo unsigned para poder hacer operaciones matemáticas (+, -)
    signal count_reg : unsigned(COUNTER_WIDTH-1 downto 0) := (others => '0');
begin
    
    -- Proceso principal síncrono
    process(clk, rst)
    begin
        -- Reset asíncrono (activa inmediatamente sin importar el reloj)
        if rst = '1' then
            count_reg <= (others => '0');
            
        -- Comportamiento síncrono (reacciona en el flanco de subida del reloj)
        elsif rising_edge(clk) then
            
            -- Si el enable está activo, el contador avanza
            if en = '1' then
                
                -- CONDICIÓN 1: Protección para valores inválidos (N <= 1)
                -- Según tu rúbrica, si N es 0 o 1, no debe contar.
                if unsigned(mod_n) <= 1 then
                    count_reg <= (others => '0'); 
                    
                -- CONDICIÓN 2: Operación normal
                else
                    -- Si la cuenta actual llega al límite (N - 1), se reinicia a 0
                    if count_reg >= unsigned(mod_n) - 1 then
                        count_reg <= (others => '0');
                    -- Si no ha llegado al límite, sigue contando hacia arriba
                    else
                        count_reg <= count_reg + 1;
                    end if;
                end if;
                
            end if;
        end if;
    end process;

    -- Asignación continua: Convertimos la señal interna (unsigned) a la salida externa (std_logic_vector)
    q <= std_logic_vector(count_reg);

    -- Lógica de la señal de fin de cuenta (tc)
    -- Se pone en '1' SOLAMENTE cuando la cuenta está en N-1 y el valor ingresado es válido (N > 1).
    tc <= '1' when (count_reg = (unsigned(mod_n) - 1)) and (unsigned(mod_n) > 1) else '0';

end Behavioral;