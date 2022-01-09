library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MASTER_FSM is
    Port ( CLK : in STD_LOGIC;     -- Entrada para la se�al de reloj 
           RESET : in STD_LOGIC;   -- Entrada para la se�al de RESET 
           CUENTA : in STD_LOGIC_VECTOR (3 downto 0);   -- Entrada para la cuenta del dinero introducido en la m�quina
           PRODUCTO : in STD_LOGIC_VECTOR (2 downto 0); -- Entrada para la selecci�n del producto deseado 
           DONE : in STD_LOGIC;      -- Se�al del bit de fin de la cuenta del temporizador 
           ERROR : out STD_LOGIC;    -- Salida del bit de error de la m�quina 
           START : out STD_LOGIC;    -- Salida del bit de start del temporizador
           VENDING : out STD_LOGIC;  -- Salida del bit del estado vendiendo de la m�quina
           LED : out STD_LOGIC_VECTOR (2 downto 0);  -- Salida para el control de los LEDs asociados a los productos de la m�quina
           DELAY : out unsigned(29 downto 0)); -- Tiempo que se cargar� en el temporizador
end MASTER_FSM;

architecture Behavioral of MASTER_FSM is

type STATE is (
    S0, --ESTADO DE REPOSO
    S1, --PRODUCTO 1 SELECCIONADO
    S2, --PRODUCTO 2 SELECCIONADO
    S3, --PRODUCTO 3 SELECCIONADO
    S4, --VENDIENDO PRODUCTO 1
    S5, --VENDIENDO PRODUCTO 2
    S6, --VENDIENDO PRODUCTO 3
    S7  --ESTADO DE ERROR
    );
signal next_state : STATE;         -- Estado siguiente
signal present_state : STATE:=S0;  -- Estado actual

constant ERROR_DURATION : positive :=500000000; --DURACI�N DE ESPERA TRAS ESTADO DE ERROR EN CICLOS DE RELOJ
constant VENDING_DURATION: positive:=500000000; --DURACI�N DE ESPERA TRAS VENTA

begin

    ACTUALIZACION_DE_ESTADO: process(CLK,RESET)
    begin
    --Cuando se activa la se�al de reset, se pasar� al estado de reposo de forma as�ncrona
        if RESET='0' then
            present_state<=S0;
        elsif rising_edge(CLK) then
    --Con cada flanco de reloj se pasar� del estado actual al estado que se haya cargado en el estado pr�ximo
            present_state<=next_state;
        end if;
    end process;
    
    CAMBIO_DE_ESTADO: process(PRODUCTO,CUENTA,DONE,PRESENT_STATE)
    begin
        next_state<=present_state;
        case present_state is 
            when S0 =>  if CUENTA="1011" then
                            next_state<=S7;   --Si la cuenta del dinero es mayor a 1euro, se pasar� al estado de error
                        --Cuando se active solo la se�al asociada a acada producto, se pasar� al estado de ese producto seleccionado    
                        elsif PRODUCTO(0)='1' AND PRODUCTO(1)='0' AND PRODUCTO(2)='0' then
                            next_state<=S1;
                        elsif PRODUCTO(0)='0' AND PRODUCTO(1)='1' AND PRODUCTO(2)='0' then
                            next_state<=S2;
                        elsif PRODUCTO(0)='0' AND PRODUCTO(1)='0' AND PRODUCTO(2)='1' then
                            next_state<=S3;
                        end if;
            
            when S1 => if CUENTA="1011" then
                       next_state<= S7;
                       elsif CUENTA="1010" then
                       next_state<=S4;  --Si el dinero introducido llega a 1euro, se pasar� al estado de venta del producto
                       elsif PRODUCTO(0)='0' OR PRODUCTO(1)='1' OR PRODUCTO(2)='1' then
                       next_state<=S0;  --Si se  selecciona otro producto, o se quita el producto seleccionado, se volver� al estado de reposo
                       end if;
            
            when S2 => if CUENTA="1011" then
                       next_state<= S7;
                       elsif CUENTA="1010" then
                       next_state<=S5;
                       elsif PRODUCTO(0)='1' OR PRODUCTO(1)='0' OR PRODUCTO(2)='1' then
                       next_state<=S0;
                       end if;
            
            when S3 => if CUENTA="1011" then
                       next_state<= S7;
                       elsif CUENTA="1010" then
                       next_state<=S6;
                       elsif PRODUCTO(0)='1' OR PRODUCTO(1)='1' OR PRODUCTO(2)='0' then
                       next_state<=S0;
                       end if;
            
            when S4 => if DONE='1' then
                       next_state<=S0;  -- Cuando termina la cuenta del temporizador, se vuelve al estado de reposo
                       end if;
                       
            when S5 => if DONE='1' then
                       next_state<=S0;
                       end if;
                       
            when S6 => if DONE='1' then
                       next_state<=S0;
                       end if;
            
            when S7 => if DONE='1' then
                       next_state<=S0;
                       end if;            
        end case;            
    end process;
    
    ACTUALIZACION_SALIDAS: process(present_state)
    begin
    --VALORES POR DEFECTO DE LAS SALIDAS
        ERROR<='0';
        VENDING<='0';
        DELAY<=(OTHERS=>'0');
        START<='0';
        LED<=(OTHERS=>'0');
        
        case present_state is 
            when S0=> LED<=(others=>'0');
                      VENDING<='0';
                      DELAY<=(others=>'0');
                      START<='0';
                      ERROR<='0';
            
            --Cuando se selecciona un producto se encender� su respectivo LED
            when S1=> LED<="001";
                      VENDING<='0';
                      DELAY<=(others=>'0');
                      START<='0';
                      ERROR<='0';
                      
            when S2=> LED<="010";
                      VENDING<='0';
                      DELAY<=(others=>'0');
                      START<='0';
                      ERROR<='0';
            
            when S3=> LED<="100";
                      VENDING<='0';
                      DELAY<=(others=>'0');
                      START<='0';
                      ERROR<='0';
            
            --Cuando se est� vendiendo un producto, se cargar� el tiempo de venta en el temporizador,
            --se mantendr� encendido el led del producto, se activar� el bit de start del temporizador,
            --y se activar� el bit de vendiendo
            when S4=> LED<="001";
                      VENDING<='1';
                      DELAY<=to_unsigned(VENDING_DURATION, DELAY'length);
                      START<='1';
                      ERROR<='0';
            
            when S5=> LED<="010";
                      VENDING<='1';
                      DELAY<=to_unsigned(VENDING_DURATION, DELAY'length);
                      START<='1';
                      ERROR<='0';
            
            when S6=> LED<="100";
                      VENDING<='1';
                      DELAY<=to_unsigned(VENDING_DURATION, DELAY'length);
                      START<='1';
                      ERROR<='0';
            
            --Cuando se entra en el estado de error, se activa el bit de error, se activa el temporizador con el
            --bit de start, y se carga en el temporizador el tiempo de error
            when S7=> LED<=(others=>'0');
                      VENDING<='0';
                      DELAY<=to_unsigned(ERROR_DURATION, DELAY'length);
                      START<='1';
                      ERROR<='1';            
         end case;    
    end process;
end Behavioral;
