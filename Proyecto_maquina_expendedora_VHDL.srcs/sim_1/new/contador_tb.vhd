library ieee;
use ieee.std_logic_1164.all;

entity tb_CONTADOR is
end tb_CONTADOR;

architecture tb of tb_CONTADOR is

    component CONTADOR
        port (CLK         : in std_logic;
              ten_cent    : in std_logic;
              twenty_cent : in std_logic;
              fifty_cent  : in std_logic;
              one_euro    : in std_logic;
              RESET       : in std_logic;
              ERROR       : in std_logic;
              VENDING        : in std_logic;
              CUENTA      : out std_logic_vector (3 downto 0));
    end component;

    signal CLK         : std_logic;
    signal ten_cent    : std_logic;
    signal twenty_cent : std_logic;
    signal fifty_cent  : std_logic;
    signal one_euro    : std_logic;
    signal RESET       : std_logic;
    signal ERROR       : std_logic;
    signal VENDING        : std_logic;
    signal CUENTA      : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : CONTADOR
    port map (CLK         => CLK,
              ten_cent    => ten_cent,
              twenty_cent => twenty_cent,
              fifty_cent  => fifty_cent,
              one_euro    => one_euro,
              RESET       => RESET,
              ERROR       => ERROR,
              VENDING        => VENDING,
              CUENTA      => CUENTA);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
		 
		
        -- EDIT Add stimuli here
        ten_cent<='0','1' after 50 ns, '0' after 90 ns;
        twenty_cent<='0','1' after 60 ns, '0' after 100 ns, '1' after 280 ns;
        RESET<='1','0' after 110 ns,'1' after 120 ns, '0' after 160 ns, '1' after 200 ns;
        one_euro<='0','1' after 160 ns, '0' after 220 ns;
        fifty_cent<='0','1' after 280 ns, '0' after 300 ns;
        VENDING<='0','1' after 240 ns, '0' after 280 ns;
        ERROR<='0','1' after 320 ns;
		
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;