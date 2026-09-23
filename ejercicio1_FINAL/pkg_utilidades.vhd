library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package pkg_utilidades is
    -- Función para convertir un dígito (0 a 9) a 7 segmentos (Lógica Invertida / Ánodo Común)
    function bin_a_7seg(digito : integer range 0 to 9) return std_logic_vector;
end package pkg_utilidades;

package body pkg_utilidades is
    function bin_a_7seg(digito : integer range 0 to 9) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        -- Orden de segmentos: "gfedcba"
        -- '0' = Segmento ENCENDIDO | '1' = Segmento APAGADO
        case digito is
            when 0 => seg := "1000000";
            when 1 => seg := "1111001";
            when 2 => seg := "0100100";
            when 3 => seg := "0110000";
            when 4 => seg := "0011001";
            when 5 => seg := "0010010"; -- CORREGIDO: f='0' (encendido), e='1' (apagado)
            when 6 => seg := "0000010";
            when 7 => seg := "1111000";
            when 8 => seg := "0000000";
            when 9 => seg := "0010000";
            when others => seg := "1111111"; -- Todos los segmentos apagados
        end case;
        return seg;
    end function bin_a_7seg;
end package body pkg_utilidades;