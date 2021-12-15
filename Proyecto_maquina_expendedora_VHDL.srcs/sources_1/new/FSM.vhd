library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    Port ( CUENTA : in STD_LOGIC_VECTOR (3 downto 0);
           PRODUCTO : in STD_LOGIC_VECTOR (2 downto 0);
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (2 downto 0);
           DONE : out STD_LOGIC;
           ERROR : out STD_LOGIC);
end FSM;

architecture Behavioral of FSM is

begin


end Behavioral;
