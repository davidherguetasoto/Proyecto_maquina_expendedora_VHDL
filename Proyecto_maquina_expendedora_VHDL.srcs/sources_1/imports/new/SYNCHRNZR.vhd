library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity SYNCHRNZR is
 port (
 clk : in std_logic;
 async_in : in std_logic;
 sync_out : out std_logic;
 reset: in std_logic
 );
end SYNCHRNZR;
architecture BEHAVIORAL of SYNCHRNZR is
 signal sreg : std_logic_vector(1 downto 0);
begin
 process (CLK,reset)
 begin
 if (reset='1') then
 sync_out <= '0';
 elsif rising_edge(CLK) then
 sync_out <= sreg(1);
 sreg <= sreg(0) & async_in;
 end if;
 end process;
end BEHAVIORAL;


