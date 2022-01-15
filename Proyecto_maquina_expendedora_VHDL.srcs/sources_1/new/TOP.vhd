library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TOP is
PORT(
button_10cent: IN std_logic; -- Entrada botón moneda 10 cents 
button_20cent: IN std_logic; -- Entrada botón moneda 20 cents 
button_50cent: IN std_logic; -- Entrada botón moneda 50 cents 
button_1euro: IN std_logic;  -- Entrada botón moneda 1 euro 
clk: IN std_logic; -- Señal de reloj 
reset: IN std_logic; -- Señal de RESET 
producto: in std_logic_vector(2 downto 0);   -- Entrada para los switches que servirán para seleccionar el producto deseado
led : out std_logic_vector(2 downto 0);      -- Salida para encender los LEDs de cada producto
digsel : out std_logic_vector(7 downto 0);   -- Salida para la activación de cada uno de los displays de la placa 
segmentos : out std_logic_vector(7 downto 0) -- Salida para la activación de cada uno de los segmentos los display de la placa
);
end TOP;


architecture Behavioral of TOP is

--Señales intermedias de los sincronizadores
signal sync_media: std_logic_vector(3 downto 0);
--Señales para las salidas de los debouncers
signal deb_media: std_logic_vector(3 downto 0);
--Señales para las salidas de los detectores de flanco
signal sal_edge:std_logic_vector(3 downto 0);
--Señal para el bit de error de la FSM
signal error : std_logic;
--Señal para el bit de venta de la FSM
signal vending: std_logic;
--Señal para llevar la cuenta del dinero del contador
signal cuenta: std_logic_vector (3 downto 0);
--Señal para agrupar las entradas del dinero en un vector 
signal monedas: std_logic_vector(3 downto 0);
--COMPONENTES DE LA ENTIDAD
COMPONENT SYNCHRNZR
PORT (
    CLK : in std_logic;
    async_in : in std_logic;
    sync_out : out std_logic;
    reset: in std_logic
    );
END COMPONENT;

COMPONENT DEBOUNCER
PORT (
    CLK	    : in std_logic;
    btn_in	: in std_logic;
    btn_out	: out std_logic;
    reset: in std_logic
    );
END COMPONENT;

COMPONENT EDGEDTCTR
PORT (
    CLK : in std_logic;
    sync_in : in std_logic;
    edge : out std_logic;
    reset: in std_logic
    );
END COMPONENT;

COMPONENT CONTADOR
PORT (
    CLK : in STD_LOGIC;
    ten_cent : in STD_LOGIC;
    twenty_cent : in STD_LOGIC;
    fifty_cent : in STD_LOGIC;
    one_euro : in STD_LOGIC;
    RESET : in STD_LOGIC;
    ERROR : in STD_LOGIC;
    VENDING : in STD_LOGIC;
    CUENTA : out STD_LOGIC_VECTOR (3 downto 0)
    );
END COMPONENT;

COMPONENT FSM
PORT (
    CUENTA : in STD_LOGIC_VECTOR (3 downto 0);
    PRODUCTO : in STD_LOGIC_VECTOR (2 downto 0);
    CLK : in STD_LOGIC;
    RESET : in STD_LOGIC;
    LED : out STD_LOGIC_VECTOR (2 downto 0);
    VENDING : out STD_LOGIC;
    ERROR : out STD_LOGIC
    );
END COMPONENT;

COMPONENT Display_Control port(
    cuenta : IN std_logic_vector(3 DOWNTO 0);
    clk: IN std_logic;
    error: IN std_logic;
    vending: IN std_logic;
    digsel : OUT std_logic_vector(7 DOWNTO 0);
    segmentos : OUT std_logic_vector(7 DOWNTO 0)
    );
END COMPONENT;

begin
--ASIGNACIÓN DE LOS BOTONES DE MONEDAS A CADA POSICIÓN DEL VECTOR
monedas(0)<=button_10cent;
monedas(1)<=button_20cent;
monedas(2)<=button_50cent;
monedas(3)<=button_1euro;

--INSTANCIACIÓN DE LAS ENTIDADES SINCRONIZADOR, DEBOUNCER Y DETECTOR DE FLANCO PARA EL ACONDICIONAMIENTO
--DE LA SEÑAL PROCEDENTE DE LOS PULSADORES
acondicionamiento_botones: for i in 0 to 3 generate
inst_synchrnyzr: SYNCHRNZR port map(
                            clk=>clk,
                            async_in=>monedas(i),
                            sync_out=>sync_media(i),
                            reset=>reset);
                            
inst_debouncer: DEBOUNCER port map(
                            CLK=>clk,
                            btn_in=>sync_media(i),
                            btn_out=>deb_media(i),
                            reset=>reset);
                            
inst_edgedtctr: EDGEDTCTR port map(
                            CLK=>clk,
                            sync_in=>deb_media(i),
                            edge=>sal_edge(i),
                            reset=>reset);
end generate acondicionamiento_botones;

--CONTADOR
Inst_CONTADOR: CONTADOR PORT MAP(
CLK=>clk,
ten_cent=>sal_edge(0),
twenty_cent=>sal_edge(1),
fifty_cent=>sal_edge(2),
one_euro=>sal_edge(3),
RESET=>reset,
ERROR=>error,
vending=>vending,
CUENTA=>cuenta
);

--MÁQUINA DE ESTADOS
Inst_FSM: FSM PORT MAP(
CUENTA=>cuenta,
PRODUCTO=>producto,
CLK=>clk,
RESET=>reset,
LED=>led,
VENDING=>vending,
ERROR=>error 
);

--CONTROL DE LOS DISPLAYS
Inst_DISPLAY_CONTROL: Display_Control port map(
clk=>clk,
error=>error,
vending=>vending,
digsel=>digsel,
segmentos=>segmentos,
cuenta=> cuenta
);

end Behavioral;
