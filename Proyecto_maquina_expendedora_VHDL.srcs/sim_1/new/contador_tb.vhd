library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador_tb is
end contador_tb;

architecture testbench of contador_tb is

component CONTADOR port(
             CLK : in STD_LOGIC;
           ten_cent : in STD_LOGIC;
           twenty_cent : in STD_LOGIC;
           fifty_cent : in STD_LOGIC;
           one_euro : in STD_LOGIC;
           RESET : in STD_LOGIC;
           ERROR : in STD_LOGIC;
           DONE : in STD_LOGIC;
           CUENTA : out STD_LOGIC_VECTOR (3 downto 0)
           );
end component;

signal CLK: std_logic;
signal ten_cent : std_logic;
signal twenty
begin


end testbench;
