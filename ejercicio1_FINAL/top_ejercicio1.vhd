library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_ejercicio1 is
    generic (
        FREQ_RELOJ : integer := 50_000_000
    );
    port (
        clk_fpga         : in  std_logic;
        reset            : in  std_logic;
        sensor_presencia : in  std_logic;
        led_alarma       : out std_logic;
        led_felicitacion : out std_logic;
        display_dec      : out std_logic_vector(6 downto 0);
        display_uni      : out std_logic_vector(6 downto 0)
    );
end entity top_ejercicio1;

architecture Estructural of top_ejercicio1 is

    -- Declaración de componentes
    component divisor_frecuencia is
        generic ( FREQ_RELOJ_IN : integer );
        port (
            clk_fpga : in  std_logic;
            reset    : in  std_logic;
            tick_1s  : out std_logic
        );
    end component;

    component control_fsm is
        port (
            clk              : in  std_logic;
            reset            : in  std_logic;
            sensor_presencia : in  std_logic;
            fin_35s          : in  std_logic;
            rst_contador     : out std_logic;
            ena_contador     : out std_logic;
            modo_extra       : out std_logic;
            led_alarma       : out std_logic;
            led_felicitacion : out std_logic
        );
    end component;

    component contador is
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            tick_1s      : in  std_logic;
            ena_contador : in  std_logic;
            rst_contador : in  std_logic;
            fin_35s      : out std_logic;
            cuenta_out   : out integer range 0 to 99
        );
    end component;

    component decodificador_7seg is
        port (
            valor_bin   : in  integer range 0 to 99;
            display_dec : out std_logic_vector(6 downto 0);
            display_uni : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Señales internas de conexión
    signal s_tick_1s      : std_logic;
    signal s_fin_35s      : std_logic;
    signal s_rst_contador : std_logic;
    signal s_ena_contador : std_logic;
    signal s_modo_extra   : std_logic;
    signal s_cuenta       : integer range 0 to 99;

begin

    -- Instanciación e interconexión mediante Port Map
    U_DIVISOR: divisor_frecuencia
        generic map ( FREQ_RELOJ_IN => FREQ_RELOJ )
        port map (
            clk_fpga => clk_fpga,
            reset    => reset,
            tick_1s  => s_tick_1s
        );

    U_FSM: control_fsm
        port map (
            clk              => clk_fpga,
            reset            => reset,
            sensor_presencia => sensor_presencia,
            fin_35s          => s_fin_35s,
            rst_contador     => s_rst_contador,
            ena_contador     => s_ena_contador,
            modo_extra       => s_modo_extra,
            led_alarma       => led_alarma,
            led_felicitacion => led_felicitacion
        );

    U_CONTADOR: contador
        port map (
            clk          => clk_fpga,
            reset        => reset,
            tick_1s      => s_tick_1s,
            ena_contador => s_ena_contador,
            rst_contador => s_rst_contador,
            fin_35s      => s_fin_35s,
            cuenta_out   => s_cuenta
        );

    U_DECODER: decodificador_7seg
        port map (
            valor_bin   => s_cuenta,
            display_dec => display_dec,
            display_uni => display_uni
        );

end architecture Estructural;