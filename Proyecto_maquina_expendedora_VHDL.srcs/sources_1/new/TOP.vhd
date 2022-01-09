library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TOP is
PORT(
button_10cent: IN std_logic; -- Entrada bot�n moneda 10 cents 
button_20cent: IN std_logic; -- Entrada bot�n moneda 20 cents 
button_50cent: IN std_logic; -- Entrada bot�n moneda 50 cents 
button_1euro: IN std_logic;  -- Entrada bot�n moneda 1 euro 
clk: IN std_logic; -- Se�al de reloj 
reset: IN std_logic; -- Se�al de RESET 
producto: in std_logic_vector(2 downto 0);   -- Entrada para los switches que servir�n para seleccionar el producto deseado
led : out std_logic_vector(2 downto 0);      -- Salida para encender los LEDs de cada producto
digsel : out std_logic_vector(7 downto 0);   -- Salida para la activaci�n de cada uno de los displays de la placa 
segmentos : out std_logic_vector(7 downto 0) -- Salida para la activaci�n de cada uno de los segmentos los display de la placa
);
end TOP;


architecture Behavioral of TOP is

--Se�ales intermedias de los sincronizadores
signal sync_media: std_logic;
signal sync_media2: std_logic;
signal sync_media3: std_logic;
signal sync_media4: std_logic;
--Se�ales para las salidas de los debouncers
signal deb_media: std_logic;
signal deb_media2: std_logic;
signal deb_media3: std_logic;
signal deb_media4: std_logic;
--Se�ales para las salidas de los detectores de flanco
signal sal_edge: std_logic;
signal sal_edge2: std_logic;
signal sal_edge3: std_logic;
signal sal_edge4: std_logic;
--Se�al para el bit de error de la FSM
signal error : std_logic;
--Se�al para el bit de venta de la FSM
signal vending: std_logic;
--Se�al para llevar la cuenta del dinero del contador
signal cuenta: std_logic_vector (3 downto 0);

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
--SINCRONIZADORES
Inst_SYNCHRNZR_10CENT: SYNCHRNZR PORT MAP (
async_in =>button_10cent ,
clk => clk,
sync_out => sync_media,
reset => reset
);
Inst_SYNCHRNZR_20CENT: SYNCHRNZR PORT MAP (
async_in =>button_20cent ,
clk => clk,
sync_out => sync_media2,
reset => reset
);
Inst_SYNCHRNZR_50CENT: SYNCHRNZR PORT MAP (
async_in =>button_50cent ,
clk => clk,
sync_out => sync_media3,
reset => reset
);
Inst_SYNCHRNZR_1EURO: SYNCHRNZR PORT MAP (
async_in =>button_1euro ,
clk => clk,
sync_out => sync_media4,
reset => reset
);

--DEBOUNCERS
Inst_DEBOUNCER_10CENT: DEBOUNCER PORT MAP (
btn_in =>sync_media ,
clk => clk,
btn_out => deb_media,
reset => reset
);
Inst_DEBOUNCER_20CENT: DEBOUNCER PORT MAP (
btn_in =>sync_media2,
clk => clk,
btn_out => deb_media2,
reset => reset
);
Inst_DEBOUNCER_50CENT: DEBOUNCER PORT MAP (
btn_in =>sync_media3 ,
clk => clk,
btn_out => deb_media3,
reset => reset
);
Inst_DEBOUNCER_1EURO: DEBOUNCER PORT MAP (
btn_in =>sync_media4,
clk => clk,
btn_out => deb_media4,
reset => reset
);

--DETECTORES DE FLANCO
Inst_EDGEDTCTR_10CENT: EDGEDTCTR PORT MAP (
sync_in =>deb_media ,
clk => clk,
edge=>sal_edge,
reset => reset
);
Inst_EDGEDTCTR_20CENT: EDGEDTCTR PORT MAP (
sync_in =>deb_media2 ,
clk => clk,
edge=>sal_edge2,
reset => reset
);
Inst_EDGEDTCTR_50CENT: EDGEDTCTR PORT MAP (
sync_in =>deb_media3 ,
clk => clk,
edge=>sal_edge3,
reset => reset
);
Inst_EDGEDTCTR_1EURO: EDGEDTCTR PORT MAP (
sync_in =>deb_media4 ,
clk => clk,
edge=>sal_edge4,
reset => reset
);

--CONTADOR
Inst_CONTADOR: CONTADOR PORT MAP(
CLK=>clk,
ten_cent=>sal_edge,
twenty_cent=>sal_edge2,
fifty_cent=>sal_edge3,
one_euro=>sal_edge4,
RESET=>reset,
ERROR=>error,
vending=>vending,
CUENTA=>cuenta
);

--M�QUINA DE ESTADOS
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
