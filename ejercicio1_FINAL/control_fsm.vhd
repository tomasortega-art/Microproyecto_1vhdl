library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_fsm is
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
end entity control_fsm;

architecture Comportamental of control_fsm is
    type estado_type is (IDLE, TEMPO_35S, RESET_EXTRA, SOBRETIEMPO, FELICITACION);
    signal estado_act, estado_sig : estado_type;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            estado_act <= IDLE;
        elsif rising_edge(clk) then
            estado_act <= estado_sig;
        end if;
    end process;

    process(estado_act, sensor_presencia, fin_35s)
    begin
        rst_contador     <= '0';
        ena_contador     <= '0';
        modo_extra       <= '0';
        led_alarma       <= '0';
        led_felicitacion <= '0';
        estado_sig       <= estado_act;

        case estado_act is
            when IDLE =>
                rst_contador <= '1';
                if sensor_presencia = '1' then
                    estado_sig <= TEMPO_35S;
                end if;

            when TEMPO_35S =>
                ena_contador <= '1';
                if sensor_presencia = '0' then
                    estado_sig <= FELICITACION;
                elsif fin_35s = '1' then
                    estado_sig <= RESET_EXTRA; 
                end if;
                
            when RESET_EXTRA =>
                rst_contador <= '1';
                estado_sig   <= SOBRETIEMPO; 

            when SOBRETIEMPO =>
                ena_contador <= '1';
                modo_extra   <= '1';
                led_alarma   <= '1'; 
                if sensor_presencia = '0' then
                    estado_sig <= IDLE;
                end if;

            when FELICITACION =>
                led_felicitacion <= '1'; 
                rst_contador     <= '1'; 
                
                if sensor_presencia = '1' then
                    estado_sig <= TEMPO_35S;
                end if;
        end case;
    end process;
end architecture Comportamental;