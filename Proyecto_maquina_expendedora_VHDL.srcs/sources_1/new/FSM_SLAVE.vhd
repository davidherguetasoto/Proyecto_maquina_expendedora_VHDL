library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SLAVE_FSM is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           START : in STD_LOGIC;
           DELAY : in UNSIGNED (7 downto 0);
           DONE : out STD_LOGIC;
           count_viewer : out UNSIGNED (7 downto 0);
           aux_start_viewer : out std_logic
           );
end SLAVE_FSM;

architecture Behavioral of SLAVE_FSM is

signal count: unsigned(7 downto 0):="00000000";
signal aux_start : std_logic:='0';
begin

  process (CLK, RESET)
  begin
    if RESET = '0' then
      count <= (others => '0');
      DONE<='0';   
    elsif rising_edge(CLK) then
      if START='1' then
        count <= DELAY;
        DONE<='0';
        aux_start<='1';
      end if;
      
      if aux_start='1' then
         if count /= 0 then
           count <= count - 1;
           DONE<='0';
         elsif count=0 then
          DONE<='1';           
           aux_start<='0';
         end if;
      elsif aux_start='0' then
          DONE<='0';
      end if;
    end if;
  end process;
 
aux_start_viewer<=aux_start;
count_viewer<=count;
  
end Behavioral;
