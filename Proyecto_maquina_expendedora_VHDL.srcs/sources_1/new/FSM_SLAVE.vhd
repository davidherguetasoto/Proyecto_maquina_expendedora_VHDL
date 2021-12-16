library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SLAVE_FSM is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           START : in STD_LOGIC;
           DELAY : in UNSIGNED (7 downto 0);
           DONE : out STD_LOGIC;
           count : inout unsigned(7 downto 0):="00000000"
           );
end SLAVE_FSM;

architecture Behavioral of SLAVE_FSM is

signal done_aux : std_logic:='0';

begin
  process (CLK, RESET)
  begin
    if RESET = '0' then
      count <= (others => '0');
      done_aux<='0';
    elsif rising_edge(CLK) then
      if START='1' then
        count <= DELAY;
      elsif count /= "00000000" then
       count <= count - 1;
      end if;
      if count="00000000" then
          done_aux<='1';
      else 
          done_aux<='0';
      end if;
    end if;
  end process;
  
DONE<=done_aux;
  
end Behavioral;
