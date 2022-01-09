library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

entity CONTADOR is
    Port ( CLK : in STD_LOGIC;          -- Entrada de la señal de reloj 
           ten_cent : in STD_LOGIC;     -- Entrada para la señal de 10 cents 
           twenty_cent : in STD_LOGIC;  -- Entrada para la señal de 20 cents 
           fifty_cent : in STD_LOGIC;   -- Entrada para la señal de 50 cents 
           one_euro : in STD_LOGIC;     -- Entrada para la señal de 1 euro 
           RESET : in STD_LOGIC;        -- Entrada para la señal de RESET 
           ERROR : in STD_LOGIC;        -- Entrada para el bit de error de la máquina 
           VENDING : in STD_LOGIC;      -- Entrada para el bit de venta de la máquina
           CUENTA : out STD_LOGIC_VECTOR (3 downto 0));  -- Salida con el valor de la cuenta del dinero introducido
end CONTADOR;

architecture Behavioral of CONTADOR is

signal cuenta_aux : unsigned(4 downto 0):=(others=>'0'); -- Señal para realizar la suma del dinero, con un bit más que la salida para evitar desbordamientos

begin

    process(CLK, RESET)
    begin  
    --Cuando la señal de RESET se active, la señal intermedia cuenta_aux y la salida 
    --cuenta pasarán a cero
        if RESET='0' then
            cuenta_aux<="00000";
            CUENTA<=(others=>'0');
    
            
        elsif rising_edge(CLK)then 
        --Si el bit de error o de venta está activo, la cuenta del dinero se reiniciará a cero      
            if ERROR='1' then
                cuenta_aux<="00000";
            elsif VENDING='1' then
                cuenta_aux<="00000";              
            else
            --Si la señal de 10cents está activa, se le sumará 1 unidad a la cuenta 
                if ten_cent='1' then
                  cuenta_aux<=cuenta_aux+"00001";
                end if;
            --Si la señal de 20cents está activa, se le sumaran 2 unidades a la cuenta  
                if twenty_cent='1' then
                  cuenta_aux<=cuenta_aux+"00010";
                end if;
            --Si la señal de 50cents está activa, se le sumaran 5 unidades a la cuenta     
                if fifty_cent='1' then
                  cuenta_aux<=cuenta_aux+"00101";
                end if;
            --Si la señal de 1euro está activa, se le sumaran 10 unidades a la cuenta   
                if one_euro='1' then
                  cuenta_aux<=cuenta_aux+"01010";                
                end if;
            end if;
       end if;
        
       --La cuenta de salida podrá ir de 0 a 10, si la suma en cuenta_aux es mayor, la salida tomará el valor 11 (1011)
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