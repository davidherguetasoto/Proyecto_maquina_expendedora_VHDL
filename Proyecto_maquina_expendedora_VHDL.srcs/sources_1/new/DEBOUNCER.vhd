library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DEBOUNCER is
    port (
    CLK    : in std_logic;
	btn_in	: in std_logic;
	btn_out	: out std_logic);
end DEBOUNCER;

architecture beh of DEBOUNCER is
    constant CNT_SIZE : integer := 19;
    signal btn_prev   : std_logic := '0';
    signal counter    : std_logic_vector(CNT_SIZE downto 0) := (others => '0');

begin
    process(clk)
    begin
	if (CLK'event and CLK='1') then
		if (btn_prev xor btn_in) = '1' then
			counter <= (others => '0');
			btn_prev <= btn_in;
		elsif (counter(CNT_SIZE) = '0') then
			counter <= counter + 1;
        	else
			btn_out <= btn_prev;
		end if;
	end if;
    end process;
end beh;


