library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_ejercicio2 is
    generic (
        FREQ_RELOJ : integer := 50_000_000
    );
    port (
        clk_fpga  : in  std_logic;
        btn_reset : in  std_logic;
        btn_start : in  std_logic;
        btn_stop  : in  std_logic;
        hex0_suni : out std_logic_vector(6 downto 0);
        hex1_sdec : out std_logic_vector(6 downto 0);
        hex2_min  : out std_logic_vector(6 downto 0)
    );
end entity top_ejercicio2;

architecture Estructural of top_ejercicio2 is

    component divisor_frecuencia is
        generic ( FREQ_RELOJ_IN : integer );
        port (
            clk_fpga : in  std_logic;
            reset    : in  std_logic;
            tick_1s  : out std_logic
        );
    end component;

    component contador_timer is
        port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            tick_1s   : in  std_logic;
            btn_start : in  std_logic;
            btn_stop  : in  std_logic;
            min_out   : out integer range 0 to 9;
            sec_out   : out integer range 0 to 59
        );
    end component;

    component decodificador_timer is
        port (
            minutos      : in  integer range 0 to 9;
            segundos     : in  integer range 0 to 59;
            display_min  : out std_logic_vector(6 downto 0);
            display_sdec : out std_logic_vector(6 downto 0);
            display_suni : out std_logic_vector(6 downto 0)
        );
    end component;

    signal s_tick_1s : std_logic;
    signal s_minutos : integer range 0 to 9;
    signal s_segundos: integer range 0 to 59;

begin

    U_DIVISOR: divisor_frecuencia
        generic map ( FREQ_RELOJ_IN => FREQ_RELOJ )
        port map (
            clk_fpga => clk_fpga,
            reset    => btn_reset,
            tick_1s  => s_tick_1s
        );

    U_CONTADOR: contador_timer
        port map (
            clk       => clk_fpga,
            reset     => btn_reset,
            tick_1s   => s_tick_1s,
            btn_start => btn_start,
            btn_stop  => btn_stop,
            min_out   => s_minutos,
            sec_out   => s_segundos
        );

    U_DECODER: decodificador_timer
        port map (
            minutos      => s_minutos,
            segundos     => s_segundos,
            display_min  => hex2_min,
            display_sdec => hex1_sdec,
            display_suni => hex0_suni
        );

end architecture Estructural;