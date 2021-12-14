library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TOP is
PORT(
button_10cent: IN std_logic;
button_20cent: IN std_logic;
button_50cent: IN std_logic;
button_1euro: IN std_logic;
clk: IN std_logic;
reset: IN std_logic
);
end TOP;


architecture Behavioral of TOP is
signal sync_media: std_logic;
signal sync_media2: std_logic;
signal sync_media3: std_logic;
signal sync_media4: std_logic;
signal deb_media: std_logic;
signal deb_media2: std_logic;
signal deb_media3: std_logic;
signal deb_media4: std_logic;
signal sal_edge: std_logic;
signal sal_edge2: std_logic;
signal sal_edge3: std_logic;
signal sal_edge4: std_logic;
COMPONENT SYNCHRNZR
PORT (
CLK : in std_logic;
async_in : IN std_logic;
sync_out : OUT std_logic
);
END COMPONENT;
COMPONENT DEBOUNCER
PORT (
CLK	    : in std_logic;
btn_in	: in std_logic;
btn_out	: out std_logic
);
END COMPONENT;
COMPONENT EDGEDTCTR
PORT (
CLK : in std_logic;
sync_in : in std_logic;
edge : out std_logic
);
END COMPONENT;
begin

Inst_SYNCHRNZR: SYNCHRNZR PORT MAP (
async_in =>button_10cent ,
clk => clk,
sync_out => sync_media
);
Inst_SYNCHRNZR2: SYNCHRNZR PORT MAP (
async_in =>button_20cent ,
clk => clk,
sync_out => sync_media2
);
Inst_SYNCHRNZR3: SYNCHRNZR PORT MAP (
async_in =>button_50cent ,
clk => clk,
sync_out => sync_media3
);
Inst_SYNCHRNZR4: SYNCHRNZR PORT MAP (
async_in =>button_1euro ,
clk => clk,
sync_out => sync_media4
);
Inst_DEBOUNCER: DEBOUNCER PORT MAP (
btn_in =>sync_media ,
clk => clk,
btn_out => deb_media
);
Inst_DEBOUNCER2: DEBOUNCER PORT MAP (
btn_in =>sync_media2,
clk => clk,
btn_out => deb_media2
);
Inst_DEBOUNCER3: DEBOUNCER PORT MAP (
btn_in =>sync_media3 ,
clk => clk,
btn_out => deb_media3
);
Inst_DEBOUNCER4: DEBOUNCER PORT MAP (
btn_in =>sync_media4,
clk => clk,
btn_out => deb_media4
);

Inst_EDGEDTCTR: EDGEDTCTR PORT MAP (
sync_in =>deb_media ,
clk => clk,
edge=>sal_edge
);
Inst_EDGEDTCTR2: EDGEDTCTR PORT MAP (
sync_in =>deb_media2 ,
clk => clk,
edge=>sal_edge2
);
Inst_EDGEDTCTR3: EDGEDTCTR PORT MAP (
sync_in =>deb_media3 ,
clk => clk,
edge=>sal_edge3
);
Inst_EDGEDTCTR4: EDGEDTCTR PORT MAP (
sync_in =>deb_media4 ,
clk => clk,
edge=>sal_edge4
);
end Behavioral;
