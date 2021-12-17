library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 use ieee.numeric_std.all; 

entity Display_Control is
  PORT(cuenta : IN std_logic_vector(3 DOWNTO 0);
    clk: IN std_logic;
    error: IN std_logic;
    vending: IN std_logic;
    digsel : OUT std_logic_vector(7 DOWNTO 0);
    segmentos : OUT std_logic_vector(7 DOWNTO 0) --teniendo en cuenta el punto del display será vector de 8 bits
    );
end Display_Control;

architecture Behavioral of Display_Control is
    --signal anodos: std_logic_vector(7 downto 0);
    signal numero : integer;
    signal anodos: natural range 0 to 7 :=0;
     signal counter: natural range 0 to 18 :=0;
     signal clk_counter: natural range 0 to 2000 :=0;
begin
   process(clk)
    begin
        --Periodo 16 ms-> clk_counter=1600000
       if rising_edge(clk) then
         clk_counter<=clk_counter + 1;
         --periodo/8 = 2 ms -> clk_counter=200000
         if clk_counter>=2000 then
            clk_counter<=0;
            anodos<=anodos +1;
              if anodos > 7 then
                anodos<=0;
              end if;
         end if;
       end if;

    end process;
   
   --Activar display, cada display se iluminará durante 1/8 ciclo, es decir 2ms
   process(anodos)
     begin
     numero <= to_integer(unsigned(cuenta));
      if numero<=10 then --entre 0€ a 1€
         case anodos is
           when 0=>digsel <="11111110";
           when 1=>digsel <="11111101";
           when 2=>digsel <="11111011";
           when others=>digsel<="11111111";
         --  when 3=>digsel <="11110111";
         -- when 4=>digsel <="11101111";
          -- when 5=>digsel <="11011111";
          -- when 6=>digsel <="10111111";
          -- when 7=>digsel <="01111111";
         end case;
       end if;
         
        if numero>10 then --mayor a 1€
         case anodos is
           when 3=>digsel <="11110111";
           when 4=>digsel <="11101111";
           when 5=>digsel <="11011111";
           when 6=>digsel <="10111111";
           when 7=>digsel <="01111111";
           when others=>digsel<="11111111";
         end case;
      end if;
      
      if error='1' then --ERROR
         case anodos is
           when 3=>digsel <="11110111";
           when 4=>digsel <="11101111";
           when 5=>digsel <="11011111";
           when 6=>digsel <="10111111";
           when 7=>digsel <="01111111";
           when others=>digsel<="11111111";
         end case;
      end if;
      
       if vending='1' then --ERROR
         case anodos is
           when 4=>digsel <="11101111";
           when 5=>digsel <="11011111";
           when 6=>digsel <="10111111";
           when 7=>digsel <="01111111";
           when others=>digsel<="11111111";
         end case;
      end if;
   
   end process;
   
   --Indicar en cada caso qué números o letras se mostrarán en los displays
   process(anodos)
     begin
       if numero=0 then --0€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=0;--nº 0
           when 2=>counter<=16; --nºcero con punto
           when others=>counter<=16;--no muestra nada en display
         end case;
        end if;
        
        if numero=1 then --0.1€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=1;--nº 1
           when 2=>counter<=16;--nºcero con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero=2 then --0.2€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=2;-- nº 2
           when 2=>counter<=16;--nºcero con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero=3 then --0.3€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=3;--nº 3
           when 2=>counter<=16;--nºcero con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero=4 then --0.4€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=4;-- nº4
           when 2=>counter<=16;--nºcero con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero=5 then --0.5€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=5;--nº5
           when 2=>counter<=16;--nºcero con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero=6 then --0.6€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=6;--nº6
           when 2=>counter<=16;--nºcero con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero=7 then --0.7€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=7;--nº7
           when 2=>counter<=16;--nºcero con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero=8 then --0.8€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=8;--nº8
           when 2=>counter<=16;--nºcero con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero=9 then --0.9€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=9;--nº9
           when 2=>counter<=16;--nºcero con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero=10 then --1.0€
        case anodos is
           when 0=>counter<=0;
           when 1=>counter<=0;
           when 2=>counter<=17;--nº uno con punto
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if numero>10 then --mayor que 1.0€
        case anodos is
           when 3=>counter<=11;--e
           when 4=>counter<=14;--r
           when 5=>counter<=14;--r
           when 6=>counter<=13;--o
           when 7=>counter<=14;--r
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
         if error='1' then --ERROR
        case anodos is
           when 3=>counter<=14;--r
           when 4=>counter<=13;--o
           when 5=>counter<=14;--r
           when 6=>counter<=14;--r
           when 7=>counter<=11;--e
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
        if vending='1' then --Producto vendido
        case anodos is
         --SOLD
           when 4=>counter<=10;--d
           when 5=>counter<=12;--l
           when 6=>counter<=13;--o
           when 7=>counter<=15;--s
           when others=>counter<=18;--no muestra nada en display
         end case;
        end if;
        
   end process;
  
   --Número que se muestra en el display
   process(counter)
     begin
      case counter is
       when 0=>segmentos<="10000001"; --0
       when 1=>segmentos<="11001111"; --1
       when 2=>segmentos<="10010010"; --2
       when 3=>segmentos<="10000110"; --3
       when 4=>segmentos<="11001100"; --4
       when 5=>segmentos<="10100100"; --5
       when 6=>segmentos<="10100000"; --6
       when 7=>segmentos<="10001111"; --7
       when 8=>segmentos<="10000000"; --8
       when 9=>segmentos<="10000100"; --9
       when 10=>segmentos<="10000001"; --D
       when 11=>segmentos<="10110000"; --E
       when 12=>segmentos<="11110001"; --L
       when 13=>segmentos<="11100010"; --O
       when 14=>segmentos<="10001000"; --R
       when 15=>segmentos<="10100100"; --S
       when 16=>segmentos<="00000001"; --0.   nº 0 con punto
        when 17=>segmentos<="01001111"; --1.  nº 1 con punto
        when 18=>segmentos<="11111111"; --No se muestra nada
       when others=>segmentos<="11111111"; 
     end case;
   end process;


end Behavioral;
