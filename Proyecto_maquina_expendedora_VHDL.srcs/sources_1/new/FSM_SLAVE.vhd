library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SLAVE_FSM is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           START : in STD_LOGIC;
           DELAY : in UNSIGNED (7 downto 0);
           DONE : out STD_LOGIC
           );
end SLAVE_FSM;

architecture Behavioral of SLAVE_FSM is

signal count : unsigned(DELAY'range);
begin
  process (CLK, RESET)
  begin
    if RESET = '0' then
      count <= (others => '0');
    elsif rising_edge(CLK) then
      if START='1' then
        count <= DELAY;
      elsif count /= 0 then
       count <= count - 1;
       if count=0 then
        DONE<='1';
       else
        DONE<='0';
       end if;
      end if;
    end if;
  end process;
end Behavioral;
