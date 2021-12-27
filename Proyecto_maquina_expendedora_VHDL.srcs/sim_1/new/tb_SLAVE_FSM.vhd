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
              DELAY : in unsigned (29 downto 0);
              DONE  : out std_logic;
              count_viewer : out unsigned (29 downto 0);
              aux_start_viewer : out std_logic
              );
    end component;

    signal clk   : std_logic;
    signal reset : std_logic;
    signal start : std_logic:='0';
    signal delay : unsigned (29 downto 0);
    signal done  : std_logic;

    constant TbPeriod : time := 1 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    signal count : unsigned (DELAY' range);
    signal aux_start:std_logic;

begin

    dut : SLAVE_FSM
    port map (CLK   => clk,
              RESET => reset,
              START => start,
              DELAY => delay,
              DONE  => done,
              count_viewer => count,
              aux_start_viewer=>aux_start);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        start <= '1' after 2ns, '0' after 4 ns, '1' after 10 ns, '0' after 16 ns;
        delay <= (others=>'0'), to_unsigned(5,delay'length) after 2ns;

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal
        RESET <= '1', '0' after 12 ns, '1' after 14 ns;
        -- EDIT Add stimuli here
        --wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        --TbSimEnded <= '1';
        wait;
    end process;
end tb;