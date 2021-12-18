library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_FSM is
end tb_FSM;

architecture tb of tb_FSM is

    component FSM
        port (CUENTA   : in std_logic_vector (3 downto 0);
              PRODUCTO : in std_logic_vector (2 downto 0);
              CLK      : in std_logic;
              RESET    : in std_logic;
              LED      : out std_logic_vector (2 downto 0);
              VENDING  : out std_logic;
              ERROR    : out std_logic;
              count    : out unsigned (7 downto 0);
              start_viewer : out std_logic;
              edge_viewer : out std_logic;
              done_viewer : out std_logic;
              aux_start_viewer : out std_logic
              );
    end component;

    signal CUENTA   : std_logic_vector (3 downto 0);
    signal PRODUCTO : std_logic_vector (2 downto 0);
    signal CLK      : std_logic;
    signal RESET    : std_logic;
    signal LED      : std_logic_vector (2 downto 0);
    signal VENDING  : std_logic;
    signal ERROR    : std_logic;
    signal count    : unsigned (7 downto 0);
    signal start_viewer : std_logic;
    signal edge_viewer : std_logic;
    signal done_viewer : std_logic;
    signal aux_start_viewer : std_logic;

--IMPORTANTE ANTES DE LANZAR LA SIULACIÓN, AJUSTAR LOS CICLOS DEL TEMPORIZADOR PARA LOS
--TIEMPOS DE ERROR Y VENDER DE LA MASTER_FSM PARA AJUSTARLOS AL RELOJ DE LA SIMULACIÓN.
    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : FSM
    port map (CUENTA   => CUENTA,
              PRODUCTO => PRODUCTO,
              CLK      => CLK,
              RESET    => RESET,
              LED      => LED,
              VENDING  => VENDING,
              ERROR    => ERROR,
              count    => count,
              start_viewer    => start_viewer,
              edge_viewer=> edge_viewer,
              done_viewer=>done_viewer,
              aux_start_viewer=>aux_start_viewer
              );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        CUENTA <= "0000", "1010" after 4000 ns, "1011" after 7000 ns, "0000" after 8000 ns;
        PRODUCTO <= "000", "001" after 2000 ns, "000" after 5000 ns;

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal
        RESET <= '1', '0' after 6000 ns, '1' after 7500 ns;

        -- EDIT Add stimuli here
        --wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        --TbSimEnded <= '1';
        wait;
    end process;

end tb;