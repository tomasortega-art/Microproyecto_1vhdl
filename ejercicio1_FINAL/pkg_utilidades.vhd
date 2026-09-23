library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package pkg_utilidades is
    -- Función para convertir un dígito (0 a 9) a 7 segmentos (Cátodo Común)
    function bin_a_7seg(digito : integer range 0 to 9) return std_logic_vector;
end package pkg_utilidades;

package body pkg_utilidades is
    function bin_a_7seg(digito : integer range 0 to 9) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        -- Orden de segmentos: "gfedcba"
        case digito is
            when 0 => seg := "0111111";
            when 1 => seg := "0000110";
            when 2 => seg := "1011011";
            when 3 => seg := "1001111";
            when 4 => seg := "1100110";
            when 5 => seg := "1101101";
            when 6 => seg := "1111101";
            when 7 => seg := "0000111";
            when 8 => seg := "1111111";
            when 9 => seg := "1101111";
            when others => seg := "0000000";
        end case;
        return seg;
    end function bin_a_7seg;
end package body pkg_utilidades;