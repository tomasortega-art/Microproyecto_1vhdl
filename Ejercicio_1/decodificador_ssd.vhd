library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decodificador_ssd is
    Port (
        bcd_in  : in  STD_LOGIC_VECTOR (3 downto 0);
        seg_out : out STD_LOGIC_VECTOR (6 downto 0)
    );
end decodificador_ssd;

architecture DataFlow of decodificador_ssd is
begin
    with bcd_in select
        seg_out <= "1111110" when "0000", -- 0
                   "0110000" when "0001", -- 1
                   "1101101" when "0010", -- 2
                   "1111001" when "0011", -- 3
                   "0110011" when "0100", -- 4
                   "1011011" when "0101", -- 5
                   "1011111" when "0110", -- 6
                   "1110000" when "0111", -- 7
                   "1111111" when "1000", -- 8
                   "1111011" when "1001", -- 9
                   "0000000" when others;
end DataFlow;