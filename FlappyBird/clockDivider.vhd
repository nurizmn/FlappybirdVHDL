library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity clockDivider is
port ( clock,reset: in std_logic;
       clockDividedByFour: out std_logic);
end clockDivider;
  
architecture behavioral of clockDivider is
  
signal count: integer:=1;
signal temp : std_logic := '0';
  
begin
  
process(clock,reset)
begin
if(reset = '1') then
count <= 1;
temp <= '0';
elsif(clock'event and clock = '1') then
count <= count + 1;
if (count = 2) then
temp <= NOT temp;
count <= 1;
end if;
end if;
clockDividedByFour <= temp;
end process;

end behavioral;