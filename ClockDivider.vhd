library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockDivider is
    Port (clockIn: in std_logic;
          clockOut: out std_logic);
end ClockDivider;

architecture Behavioral of ClockDivider is
    signal firstDivider, secondDivider: std_logic:= '0';
    begin
        process(clockIn, firstDivider) 
        begin
            if clockIn'event and clockIn = '1' then --T-flip flop 1
                firstDivider <= not firstDivider;
            end if;
            if firstDivider'event and firstDivider = '1' then --T flip flop 2
                secondDivider <= not secondDivider;
            end if;
        end process;
        clockOut <= secondDivider;
end Behavioral;
