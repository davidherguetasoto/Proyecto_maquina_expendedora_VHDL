library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_SLAVE_FSM is
end tb_SLAVE_FSM;

architecture tb of tb_SLAVE_FSM is

    component SLAVE_FSM
        port (CLK   : in std_logic;
              RESET : in std_logic;
              START : in std_logic;
              DELAY : in unsigned (7 downto 0);
              DONE  : out std_logic;
              count : inout unsigned (7 downto 0)
              );
    end component;

    signal clk   : std_logic;
    signal reset : std_logic;
    signal start : std_logic:='0';
    signal delay : unsigned (7 downto 0);
    signal done  : std_logic;

    constant TbPeriod : time := 1 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    signal count : unsigned (DELAY' range);

begin

    dut : SLAVE_FSM
    port map (CLK   => clk,
              RESET => reset,
              START => start,
              DELAY => delay,
              DONE  => done,
              count => count);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        start <= '1' after 2ns, '0' after 4 ns;
        delay <= (others=>'0'), "00000101" after 2ns;

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal
        RESET <= '1', '0' after 12 ns;
        -- EDIT Add stimuli here
        --wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        --TbSimEnded <= '1';
        wait;
    end process;
end tb;