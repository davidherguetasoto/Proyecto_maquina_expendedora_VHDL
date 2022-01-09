library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SLAVE_FSM is
    Port ( CLK : in STD_LOGIC;                            --Entrada para la señal de reloj 
           RESET : in STD_LOGIC;                          --Entrada para la señal de reset 
           START : in STD_LOGIC;                          --Entrada para el bit de start del temporizador 
           DELAY : in UNSIGNED (29 downto 0);             --Entrada para el tiempo que se cargará en el temporizador 
           DONE : out STD_LOGIC                           --Salida para el bit de fin de la cuenta 
           
       --SALIDAS EMPLEADAS PARA VER LA EVOLUCIÓN DE LAS SEÑALES EN EL TESTBENCH DE LA ENTIDAD    
           --count_viewer : out UNSIGNED (29 downto 0);   --Visor de la cuenta del temporizador
           --aux_start_viewer : out std_logic             --Visor del bit auxiliar del bit de start
           );
end SLAVE_FSM;

architecture Behavioral of SLAVE_FSM is

signal count: unsigned(29 downto 0):=(others=>'0'); --Cuenta del temporizador
signal aux_start : std_logic:='0'; --Bit auxiliar para el bit de start
signal aux_done : std_logic:='0';  --Bit auxiliar para gestionar el bit de fin de la cuenta
begin

  process (CLK, RESET)
  begin
    if RESET = '0' then
      count <= (others => '0');
      aux_done<='0'; 
      aux_start<='0';  
    elsif rising_edge(CLK) then
    --Si la señal de start se activa, se cargará el temporizador para poder empezar la cuenta atrás
    --La señal de START servirá para disparar el temporizador
      if START='1' then
        count <= DELAY;
        aux_done<='0';
        aux_start<='1'; -- Aux_start pasará a 1 si previamente se ha detectado la señal de start activa
      end if;
      
      if aux_start='1' then  -- Mientras aux_start esté a '1', el temporizador seguirá con la cuenta atrás
         if count /= 0 then  -- Mientras el temporizador esté activo, se decrementará en 1 la cuenta con cada ciclo de reloj
           count <= count - 1;
           aux_done<='0';    -- La señal de fin de la cuenta se mantendrá a '0' mientras la cuenta del temporizador no sea 0
         elsif count=0 then  -- Cuando la cuenta llegue a cero, se activará el bit de fin, y la señal aux_start volverá a cero
          aux_done<='1';           
           aux_start<='0';
         end if;
      elsif aux_start='0' then -- Si aux_start está a '0', significará que el temporizador está parado y el bit de fin deberá ser '0'
          aux_done<='0';
      end if;
    end if;
  end process;
 
 DONE<=aux_done;
 
--aux_start_viewer<=aux_start;
--count_viewer<=count;
  
end Behavioral;
