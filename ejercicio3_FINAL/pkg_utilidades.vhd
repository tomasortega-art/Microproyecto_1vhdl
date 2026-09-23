library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package pkg_utilidades is
    function bin_a_7seg(digito : integer range 0 to 9) return std_logic_vector;
end package pkg_utilidades;

package body pkg_utilidades is
    function bin_a_7seg(digito : integer range 0 to 9) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        -- Mapeo de vector: (6)=g, (5)=f, (4)=e, (3)=d, (2)=c, (1)=b, (0)=a
        -- '0' = ENCENDIDO | '1' = APAGADO
        case digito is
            when 0 => seg := "1000000"; -- a,b,c,d,e,f encendidos
            when 1 => seg := "1111001"; -- b,c encendidos
            when 2 => seg := "0100100"; -- a,b,d,e,g encendidos
            when 3 => seg := "0110000"; -- a,b,c,d,g encendidos
            when 4 => seg := "0011001"; -- b,c,f,g encendidos
            when 5 => seg := "0010010"; -- a,c,d,f,g encendidos (CORREGIDO)
            when 6 => seg := "0000010"; -- a,c,d,e,f,g encendidos
            when 7 => seg := "1111000"; -- a,b,c encendidos
            when 8 => seg := "0000000"; -- todos encendidos
            when 9 => seg := "0010000"; -- a,b,c,d,f,g encendidos
            when others => seg := "1111111";
        end case;
        return seg;
    end function bin_a_7seg;
end package body pkg_utilidades;