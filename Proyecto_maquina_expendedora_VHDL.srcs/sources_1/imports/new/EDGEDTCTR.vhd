library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity EDGEDTCTR is
 port (
 CLK : in std_logic;
 sync_in : in std_logic;
 edge : out std_logic;
 reset: in std_logic
 );
end EDGEDTCTR;
architecture BEHAVIORAL of EDGEDTCTR is
 signal sreg : std_logic_vector(2 downto 0);
begin
 process (CLK, reset)
 begin
 if (reset='0') then
 sreg<="000";
 elsif rising_edge(CLK) then
 sreg <= sreg(1 downto 0) & sync_in;
 end if;
 end process;
 
 edge<= '0' when reset='0' else
        '1' when sreg="100" else
        '0';
        
-- with sreg select
-- edge <= '1' when "100",
-- '0' when others;
end BEHAVIORAL;