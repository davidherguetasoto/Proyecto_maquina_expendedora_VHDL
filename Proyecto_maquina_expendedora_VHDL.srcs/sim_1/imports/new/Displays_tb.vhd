
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Displays_tb is
--  Port ( );
end Displays_tb;

architecture tb of Displays_tb is

    component Displays
        port (cuenta    : in std_logic_vector (3 downto 0);
              clk       : in std_logic;
              error     : in std_logic;
              done      : in std_logic;
              digsel    : out std_logic_vector (7 downto 0);
              segmentos : out std_logic_vector (7 downto 0));
    end component;

    signal cuenta    : std_logic_vector (3 downto 0);
    signal CLK      : std_logic:='0';
    signal Error     : std_logic;
    signal Done      : std_logic;
    signal digsel    : std_logic_vector (7 downto 0);
    signal segmentos : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
   -- signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Displays
    port map (cuenta    => cuenta,
              clk       => CLK,
              error     => Error,
              done      => Done,
              digsel    => digsel,
              segmentos => segmentos);

    -- Clock generation
   -- TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    CLK <= not CLK after 5ns;

     stimuli : process
    begin
 
        --wait for 1ms;
       cuenta<="0011";
        Error <= '0';
        Done <= '0';
        
    
        -- EDIT Add stimuli here
        wait for 10ms;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Displays of Displays_tb is
    for tb
    end for;
end cfg_tb_Displays;
