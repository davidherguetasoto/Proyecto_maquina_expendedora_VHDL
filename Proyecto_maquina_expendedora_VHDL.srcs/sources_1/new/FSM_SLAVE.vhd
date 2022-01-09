library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SLAVE_FSM is
    Port ( CLK : in STD_LOGIC;                            --Entrada para la se�al de reloj 
           RESET : in STD_LOGIC;                          --Entrada para la se�al de reset 
           START : in STD_LOGIC;                          --Entrada para el bit de start del temporizador 
           DELAY : in UNSIGNED (29 downto 0);             --Entrada para el tiempo que se cargar� en el temporizador 
           DONE : out STD_LOGIC                           --Salida para el bit de fin de la cuenta 
           
       --SALIDAS EMPLEADAS PARA VER LA EVOLUCI�N DE LAS SE�ALES EN EL TESTBENCH DE LA ENTIDAD    
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
    --Si la se�al de start se activa, se cargar� el temporizador para poder empezar la cuenta atr�s
    --La se�al de START servir� para disparar el temporizador
      if START='1' then
        count <= DELAY;
        aux_done<='0';
        aux_start<='1'; -- Aux_start pasar� a 1 si previamente se ha detectado la se�al de start activa
      end if;
      
      if aux_start='1' then  -- Mientras aux_start est� a '1', el temporizador seguir� con la cuenta atr�s
         if count /= 0 then  -- Mientras el temporizador est� activo, se decrementar� en 1 la cuenta con cada ciclo de reloj
           count <= count - 1;
           aux_done<='0';    -- La se�al de fin de la cuenta se mantendr� a '0' mientras la cuenta del temporizador no sea 0
         elsif count=0 then  -- Cuando la cuenta llegue a cero, se activar� el bit de fin, y la se�al aux_start volver� a cero
          aux_done<='1';           
           aux_start<='0';
         end if;
      elsif aux_start='0' then -- Si aux_start est� a '0', significar� que el temporizador est� parado y el bit de fin deber� ser '0'
          aux_done<='0';
      end if;
    end if;
  end process;
 
 DONE<=aux_done;
 
--aux_start_viewer<=aux_start;
--count_viewer<=count;
  
end Behavioral;
