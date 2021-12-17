library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity FSM is
    Port ( CUENTA : in STD_LOGIC_VECTOR (3 downto 0);
           PRODUCTO : in STD_LOGIC_VECTOR (2 downto 0);
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (2 downto 0);
           VENDING : out STD_LOGIC;
           ERROR : out STD_LOGIC;
           count : out unsigned(7 downto 0);
           start_viewer : out std_logic;
           edge_viewer : out std_logic;
           done_viewer : out std_logic;
           aux_start_viewer : out std_logic);
end FSM;

architecture Structural of FSM is

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
           DELAY : out unsigned(7 downto 0)
           );
end component;

component SLAVE_FSM port(
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           START : in STD_LOGIC;
           DELAY : in UNSIGNED (7 downto 0);
           DONE : out STD_LOGIC;
           count_viewer : out unsigned(7 downto 0);
           aux_start_viewer : out std_logic
           );
end component;

component EDGEDTCTR port(
           CLK : in std_logic;
           sync_in : in std_logic;
           edge : out std_logic;
           reset: in std_logic
            );
end component;

signal done, start : std_logic;
signal delay : unsigned(7 downto 0);
signal start_edge : std_logic;

begin
    start_viewer <= start;
    edge_viewer<=start_edge;
    done_viewer<=done;
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
                            DONE=>done,
                            count_viewer=>count,
                            aux_start_viewer=>aux_start_viewer 
                            );
                            
     Inst_EDGEDTCTR_FSM: EDGEDTCTR port map(
                            CLK=>CLK,
                            reset=>RESET,
                            sync_in=>not(start),
                            edge=>start_edge
                            );
    
end Structural;
