library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MASTER_FSM is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           CUENTA : in STD_LOGIC_VECTOR (3 downto 0);
           PRODUCTO : in STD_LOGIC_VECTOR (2 downto 0);
           DONE : in STD_LOGIC;
           ERROR : out STD_LOGIC;
           START : out STD_LOGIC;
           VENDING : out STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (2 downto 0);
           DELAY : out unsigned(7 downto 0));
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
signal next_state : STATE;
signal present_state : STATE:=S0;

constant ERROR_DURATION : positive :=5; --DURACIÓN DE ESPERA TRAS ESTADO DE ERROR EN SEGUNDOS
constant VENDING_DURATION: positive:=5; --DURACIÓN DE ESPERA TRAS VENTA

begin

    ACTUALIZACION_DE_ESTADO: process(CLK,RESET)
    begin
        if RESET='0' then
            present_state<=S0;
        elsif rising_edge(CLK) then
            present_state<=next_state;
        end if;
    end process;
    
    CAMBIO_DE_ESTADO: process(PRODUCTO,CUENTA,DONE,PRESENT_STATE)
    begin
        next_state<=present_state;
        case present_state is 
            when S0 =>  if CUENTA="1011" then
                            next_state<=S7;
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
                       next_state<=S4;
                       elsif PRODUCTO(0)='0' OR PRODUCTO(1)='1' OR PRODUCTO(2)='1' then
                       next_state<=S0;
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
                       next_state<=S0;
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
            
            when S4=> LED<="001";
                      VENDING<='1';
                      DELAY<=to_unsigned(VENDING_DURATION- 2, DELAY'length);
                      START<='1';
                      ERROR<='0';
            
            when S5=> LED<="010";
                      VENDING<='1';
                      DELAY<=to_unsigned(VENDING_DURATION- 2, DELAY'length);
                      START<='1';
                      ERROR<='0';
            
            when S6=> LED<="100";
                      VENDING<='1';
                      DELAY<=to_unsigned(VENDING_DURATION- 2, DELAY'length);
                      START<='1';
                      ERROR<='0';
            
            when S7=> LED<=(others=>'0');
                      VENDING<='0';
                      DELAY<=to_unsigned(ERROR_DURATION- 2, DELAY'length);
                      START<='1';
                      ERROR<='1';            
         end case;    
    end process;
end Behavioral;
