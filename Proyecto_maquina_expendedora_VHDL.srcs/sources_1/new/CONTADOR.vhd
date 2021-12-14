library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

entity CONTADOR is
    Port ( CLK : in STD_LOGIC;
           ten_cent : in STD_LOGIC;
           twenty_cent : in STD_LOGIC;
           fifty_cent : in STD_LOGIC;
           one_euro : in STD_LOGIC;
           RESET : in STD_LOGIC;
           ERROR : in STD_LOGIC;
           DONE : in STD_LOGIC;
           CUENTA : out STD_LOGIC_VECTOR (3 downto 0));
end CONTADOR;

architecture Behavioral of CONTADOR is

signal cuenta_aux : unsigned(4 downto 0):=(others=>'0');

begin

    process(CLK, RESET)
    begin  
        if RESET='0' then
            cuenta_aux<="00000";
            CUENTA<=(others=>'0');
            
        elsif rising_edge(CLK)then       
            if DONE='1' OR ERROR='1' then
                cuenta_aux<="00000";
                
            elsif ten_cent='1' then
                cuenta_aux<=cuenta_aux+"00001";
                
            elsif twenty_cent='1' then
                cuenta_aux<=cuenta_aux+"00010";
                
            elsif fifty_cent='1' then
                cuenta_aux<=cuenta_aux+"00101";
                
            elsif one_euro='1' then
                cuenta_aux<=cuenta_aux+"01010";
                
            end if;
       end if;
        
       case cuenta_aux is
            when "00000"=>CUENTA<="0000";
            when "00001"=>CUENTA<="0001";
            when "00010"=>CUENTA<="0010";
            when "00011"=>CUENTA<="0011";
            when "00100"=>CUENTA<="0100";
            when "00101"=>CUENTA<="0101";
            when "00110"=>CUENTA<="0110";
            when "00111"=>CUENTA<="0111";
            when "01000"=>CUENTA<="1000";
            when "01001"=>CUENTA<="1001";
            when "01010"=>CUENTA<="1010";
            when others=>CUENTA<="1011";
      end case;
    end process;

end Behavioral;