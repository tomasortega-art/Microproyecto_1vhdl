library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_utilidades.all; 

entity decodificador_timer is
    port (
        minutos      : in  integer range 0 to 9;
        segundos     : in  integer range 0 to 59;
        display_min  : out std_logic_vector(6 downto 0);
        display_sdec : out std_logic_vector(6 downto 0);
        display_suni : out std_logic_vector(6 downto 0)
    );
end entity decodificador_timer;

architecture DataFlow of decodificador_timer is
    signal sec_decenas  : integer range 0 to 9;
    signal sec_unidades : integer range 0 to 9;
begin
    -- Separación de dígitos de los segundos (Flujo de datos concurrente)
    sec_decenas  <= segundos / 10;
    sec_unidades <= segundos rem 10;

    -- Asignación a displays
    display_min  <= bin_a_7seg(minutos);
    display_sdec <= bin_a_7seg(sec_decenas);
    display_suni <= bin_a_7seg(sec_unidades);

end architecture DataFlow;