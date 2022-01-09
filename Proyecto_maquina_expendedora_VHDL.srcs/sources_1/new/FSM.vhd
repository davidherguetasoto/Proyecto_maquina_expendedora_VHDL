library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity FSM is
    Port ( CUENTA : in STD_LOGIC_VECTOR (3 downto 0);   -- Entrada para la cuenta del dinero introducido en la máquina 
           PRODUCTO : in STD_LOGIC_VECTOR (2 downto 0); -- Entrada para la selección del producto deseado
           CLK : in STD_LOGIC;                          -- Entrada para la señal de reloj
           RESET : in STD_LOGIC;                        -- Entrada para la señal de reset
           LED : out STD_LOGIC_VECTOR (2 downto 0);     -- Salida para el control de los LED asignados a los productos
           VENDING : out STD_LOGIC;                     -- Salida del bit de venta
           ERROR : out STD_LOGIC                        -- Salida del bit de bit de error 
           
      -- ESTAS SEÑALES SE HAN EMPLEADO PARA VER EL FUNCIONAMIENTO DE LA ENTIDAD EN EL TESTBENCH     
           --count : out unsigned(29 downto 0);         -- Visor de la cuenta del temporizador de la FSM_SLAVE
          -- start_viewer : out std_logic;              -- Visor del bit de start del temporizador
           --edge_viewer : out std_logic;               -- Visor del flanco del bit de start
          -- done_viewer : out std_logic;               -- Visor del bit de fin del temporizador
           --aux_start_viewer : out std_logic           -- Visor del bit auxiliar del bit de start
           );
end FSM;

architecture Structural of FSM is

--COMPONENTES DE LA FSM
component MASTER_FSM port(
            CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           CUENTA : in STD_LOGIC_VECTOR (3 downto 0);
           PRODUCTO : in STD_LOGIC_VECTOR (2 downto 0);
           DONE : in STD_LOGIC;
           ERROR : out STD_LOGIC;
           START : out STD_LOGIC;
           VENDING : out STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (2 downto 0);
           DELAY : out unsigned(29 downto 0)
           );
end component;

component SLAVE_FSM port(
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           START : in STD_LOGIC;
           DELAY : in UNSIGNED (29 downto 0);
           DONE : out STD_LOGIC
           --count_viewer : out unsigned(29 downto 0);
           --aux_start_viewer : out std_logic
           );
end component;

component EDGEDTCTR port(
           CLK : in std_logic;
           sync_in : in std_logic;
           edge : out std_logic;
           reset: in std_logic
            );
end component;

signal done, start : std_logic;        -- Señal para los bit de fin y start del temporizador
signal delay : unsigned(29 downto 0);  -- Tiempo que se carga en el temporizador
signal start_edge : std_logic;         -- Señal para el flanco en el bit de start
signal edge_in : std_logic;            -- Señal para la entrada del detector de flanco

begin
    --start_viewer <= start;
    --edge_viewer<=start_edge;
    --done_viewer<=done;
   edge_in<=not start;  -- El detector de flancos lee flancos negativos, por lo que si queremos flancos ascendentes habrá que negar la señal
    Inst_MASTER_FSM: MASTER_FSM port map(
                           CLK=>CLK,
                           RESET=>RESET,
                           CUENTA=>CUENTA,
                           PRODUCTO=>PRODUCTO,
                           DONE=>done,
                           ERROR=>ERROR,
                           START=>start,
                           VENDING=>VENDING,
                           LED=>LED,
                           DELAY=>delay);
                           
     Inst_SLAVE_FSM: SLAVE_FSM port map(
                            CLK=>CLK,
                            RESET=>RESET,
                            START=>start_edge,
                            DELAY=>delay, 
                            DONE=>done
                            --count_viewer=>count,
                            --aux_start_viewer=>aux_start_viewer 
                            );
                            
     Inst_EDGEDTCTR_FSM: EDGEDTCTR port map(
                            CLK=>CLK,
                            reset=>RESET,
                            sync_in=>edge_in,
                            edge=>start_edge
                            );
    
end Structural;
