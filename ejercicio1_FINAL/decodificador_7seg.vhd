library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_utilidades.all; -- Uso del paquete de funciones

entity decodificador_7seg is
    port (
        valor_bin  : in  integer range 0 to 99;
        display_dec : out std_logic_vector(6 downto 0);
        display_uni : out std_logic_vector(6 downto 0)
    );
end entity decodificador_7seg;

architecture DataFlow of decodificador_7seg is
    signal decenas  : integer range 0 to 9;
    signal unidades : integer range 0 to 9;
begin
    -- Separación de dígitos
    decenas  <= valor_bin / 10;
    unidades <= valor_bin rem 10;

    -- Asignaciones concurrentes por Flujo de Datos llamando a la función
    display_dec <= bin_a_7seg(decenas);
    display_uni <= bin_a_7seg(unidades);

end architecture DataFlow;