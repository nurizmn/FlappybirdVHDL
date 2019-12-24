library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity btnPulseModule is
    Port ( btn : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           buttonPulse : out  STD_LOGIC);
end btnPulseModule;

architecture stateArchitecture of btnpulseModule is
	type states is (zero, activatePulse, waitLoop);
	signal stateCurrent, stateNext: states;
begin

	process(clk, reset)
	begin
		if reset='1' then 
			stateCurrent <= zero;
		elsif clk'event and clk='1' then
			stateCurrent <= stateNext;
		end if;
	end process;
	
	--Next State and Output Logic
	process (btn, stateCurrent)
	begin
		--Defaults
		buttonPulse <= '0';
		stateNext <= stateCurrent;
		case stateCurrent is
			when zero =>
				if (btn='0') then
					stateNext <= zero;
				else
					stateNext <= activatePulse;
				end if;
			when activatePulse =>
				buttonPulse <= '1';
				stateNext <= waitLoop;
			when waitLoop =>
				if btn='1' then
					stateNext <= waitLoop;
				else
					stateNext <= zero;
				end if;
		end case;
	end process;
	
end stateArchitecture;
