library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTADOR is
    Port ( CLK : in STD_LOGIC;
           ten_cent : in STD_LOGIC;
           twenty_cent : in STD_LOGIC;
           fify_cent : in STD_LOGIC;
           one_euro : in STD_LOGIC;
           RESET : in STD_LOGIC;
           ERROR : in STD_LOGIC;
           DONE : in STD_LOGIC;
           CUENTA : out STD_LOGIC_VECTOR (3 downto 0));
end CONTADOR;

architecture Behavioral of CONTADOR is

begin


end Behavioral;
