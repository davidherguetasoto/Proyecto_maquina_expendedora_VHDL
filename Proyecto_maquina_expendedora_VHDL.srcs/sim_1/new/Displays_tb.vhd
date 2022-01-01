
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Displays_tb is
--  Port ( );
end Displays_tb;

architecture tb of Displays_tb is

    component Display_Control
        port (cuenta    : in std_logic_vector (3 downto 0);
              clk       : in std_logic;
              error     : in std_logic;
              vending     : in std_logic;
              digsel    : out std_logic_vector (7 downto 0);
              segmentos : out std_logic_vector (7 downto 0));
    end component;

    signal cuenta    : std_logic_vector (3 downto 0);
    signal clk      : std_logic:='0';
    signal error     : std_logic;
    signal vending      : std_logic;
    signal digsel    : std_logic_vector (7 downto 0);
    signal segmentos : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- 100 MHZ
   signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Display_Control
    port map (cuenta    => cuenta,
              clk       => clk,
              error     => error,
              vending      => vending,
              digsel    => digsel,
              segmentos => segmentos);

    -- Clock generation
     TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
     clk <= TbClock;

     stimuli : process
    begin
 
       wait for 10ns;
       cuenta<="0011";
        error <= '0';
        vending <= '0';
        
    wait for 17ms;
       cuenta<="0000";
       vending<='1';
       
         wait for 16ms;
       cuenta<="0000";
       vending<='0';
        error <= '1';

        wait for 16ms;
       cuenta<="0000";
       vending<='0';
       error <= '0';
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

