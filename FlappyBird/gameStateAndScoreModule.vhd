library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gameStateAndScoreModule is
    Port ( clk: in std_logic;
           btn: in std_logic_vector(3 downto 0); 
           button0Out: out std_logic;
           button0pulse: in std_logic;
           random: in unsigned(9 downto 0);
           pixelX, pixelY: in std_logic_vector(9 downto 0);
           birdTop: in unsigned(9 downto 0);
           birdTopOut: out unsigned(9 downto 0);
           birdLeftOut: out unsigned(9 downto 0);
           turnGGOn: out boolean;
           birdOutlineOn, groundBorderOn: in std_logic;
           pipeOnOut: out std_logic;
           leftSevenSegData, rightSevenSegData: out std_logic_vector(7 downto 0);
           rgb: in std_logic_vector(7 downto 0);
           vgaRed: out std_logic_vector(2 downto 0); 
           vgaGreen: out std_logic_vector(2 downto 0);
           vgaBlue: out std_logic_vector(1 downto 0);
           HS, VS: in std_logic;
           Hsync, Vsync: out std_logic;
           rst: out std_logic
   );
end gameStateAndScoreModule;

architecture Behavioral of gameStateAndScoreModule is

--signal and constant for debounce
constant BITS_OF_DEBOUNCE_TIMER: natural := 18;
signal debounceCounterValue, debounceCounterValueNext: unsigned( BITS_OF_DEBOUNCE_TIMER - 1 downto 0) := (others=>'0');

-- Signals for State Machine (necessary to have a "tap to start" type of behavior)
type state is (start, play);
signal stateRegister, stateNext: state;

--Physics
signal button0, button0Next: std_logic;
signal jumpRegister, jumpRegisterNext: unsigned(4 downto 0) := "00000";
signal fallRegister, fallRegisterNext: unsigned(3 downto 0) := "0000";
signal birdDelay, birdDelayNext: unsigned(20 downto 0):= to_unsigned(0,21);

-- Signals to Keep Score
signal scoreOnes, scoreOnesNext, scoreTens, scoreTensNext: unsigned (3 downto 0);
signal highscore, highscoreNext: unsigned (7 downto 0);

signal leftSevenSegDataNext: std_logic_vector(7 downto 0) := (others=>'0');
signal rightSevenSegDataNext: std_logic_vector(7 downto 0) := (others=>'0');

--signals about display
signal pixX, pixY: unsigned(9 downto 0);

--next values of the inputs
signal col1XNext, col1YNext: unsigned (9 downto 0) := (others => '1');
signal col2XNext, col2YNext: unsigned (9 downto 0):= (others => '1');
signal col3XNext, col3YNext: unsigned (9 downto 0):= (others => '1');
signal birdTopNext, birdTopTemp, birdTopTemp2: unsigned(9 downto 0):= to_unsigned(200,10);

--signals for column movement
signal col1X, col1Y: unsigned (pixelX'range) := (others => '1');
signal col2X, col2Y: unsigned (pixelX'range) := (others => '1');
signal col3X, col3Y: unsigned (pixelX'range) := (others => '1');
signal enableMovement, col1On, col2On, col3On: std_logic := '0';    -- to delay the movement
signal delay, delayNext: Natural := 0; 

--Flappy Bird Graphics
signal birdLeft: unsigned(9 downto 0);
signal pipeOn: std_logic;
signal crashed: std_logic;

begin

pixX <= unsigned(pixelX);
pixY <= unsigned(pixelY);

process(clk, btn)
begin
    rst <='0';
    if btn(3)='1' then
        rst <= '1';
        birdTopTemp2 <= to_unsigned(200,10);
        birdDelay <= (others=>'0');
        col1X <= (others => '0');
        col2X <= (others => '0');
        col3X <= (others => '0');
        delay <= 0;
        stateRegister <= start;
        highscore <= (others => '0');
        scoreOnes <= (others => '0');
        scoreTens <= (others => '0');
        turnGGon <= false;
    elsif (clk'event and clk='1') then
        Hsync <= HS;
        Vsync <= VS;
        vgaRed <= rgb(7 downto 5);
        vgaGreen <= rgb(4 downto 2);
        vgaBlue <= rgb(1 downto 0);
        birdTopTemp2 <= birdTopNext;
        birdDelay <= birdDelayNext;

        leftSevenSegData <= leftSevenSegDataNext;
        rightSevenSegData <= rightSevenSegDataNext;
        stateRegister <= stateNext;
        
        debounceCounterValue <= debounceCounterValueNext;
        button0 <= button0Next;
        
        if button0Pulse='1' then
            turnGGon <= false;
            jumpRegister <= "10111";
            fallRegister <= "0000";
        else
            jumpRegister <= jumpRegisterNext;
            fallRegister <= fallRegisterNext;
        end if;
        
        --signals for columns
        col1X <= col1XNext;
        col2X <= col2XNext;
        col3X <= col3XNext;
        col1Y <= col1YNext;
        col2Y <= col2YNext;
        col3Y <= col3YNext;
        delay <= delayNext;
        
        --Signals for Score
        highscore <= highscoreNext;
        scoreOnes <= scoreOnesNext;
        scoreTens <= scoreTensNext;
        
        if (crashed = '1' or (scoreOnes = 9 and scoreTens = 9)) then
            turnGGon <= true;
        end if;
    end if;
end process;

--the new value of the birdTop is assigned to birdTopOut to connect the new value to the top module
birdTopOut <= birdTopTemp2;

--Debounce Logic
debounceCounterValueNext <= debounceCounterValue + 1;
button0Next <= '1' when (btn(0)='1' and debounceCounterValue = 0) else
                              '0' when (btn(0)='0' and debounceCounterValue = 0) else
                            button0;
button0Out<=button0;
						        
--Transition from start state to play state must turn col1 on.
col1On <= '1' when col1X <= (639+80) and col1X > 0 else '0';
col2On <= '1' when col2X <= (639+80) and col2X > 0 else '0';
col3On <= '1' when col3X <= (639+80) and col3X > 0 else '0';

enableMovement <= '1' when delay = 200000 else '0';
delayNext <= 0 when delay > 200000 else delay + 1;

--Logic to signal the pipe is on (80 is the width of the pipe, 100 is width of the gap)
pipeOn <= '1' when     (col1On='1' and ((pixX >= col1X - 80 and pixX < col1X) or (col1X <= 80 and pixX < col1X)) and (pixY <= col1Y or pixY > col1Y+100)) or
                            (col2On='1' and ((pixX >= col2X - 80 and pixX < col2X) or (col2X <= 80 and pixX < col2X)) and (pixY <= col2Y or pixY > col2Y+100)) or
                            (col3On='1' and ((pixX >= col3X - 80 and pixX < col3X) or (col3X <= 80 and pixX < col3X)) and (pixY <= col3Y or pixY > col3Y+100))
                else '0';
pipeOnOut<=pipeOn;

-- Calculate Crashes
crashed <= '1' when birdOutlineOn='1' and (groundBorderOn='1' or pipeOn='1') else '0';
--======================================================================================

------------------------------------Bird Movement-------------------------------------
	-- (+ is down and - is up)
	process(birdDelay, button0Pulse, jumpRegister, fallRegister)
	begin
		if birdDelay=0 then
			if jumpRegister/="00000" then
				jumpRegisterNext <= '0' & jumpRegister(4 downto 1);  --creates a shift register to add and subtract the heights
				fallRegisterNext <= fallRegister;
			else
				jumpRegisterNext <= jumpRegister;
				fallRegisterNext <= fallRegister(2 downto 0) & '1';
			end if;
		else
			jumpRegisterNext <= jumpRegister;
			fallRegisterNext <= fallRegister;
		end if;
	end process;

	birdDelayNext <= birdDelay+2;
	birdTopTemp <= to_unsigned(200,10) when (stateRegister=start and button0Pulse='1') else
						  (birdTopTemp2 - jumpRegister + fallRegister) when birdDelay=0 and stateRegister/=start
						  else birdTopTemp2;
	birdTopNext <= birdTopTemp when (birdTopTemp>=0 and birdTopTemp<425) else  --This caps the level so the bird can't fly above it
							(others=>'0');
	birdLeft <= to_unsigned(100,10);
	birdLeftOut<= birdLeft;
	
	--In order for columns to actually move off the the screen to the left, need to display them
    --relative to their right edge, rather than their left edge.
    
    -- Next State Logic
    process (stateRegister, button0Pulse, crashed, col1X, col2X, col3X, enableMovement, 
             col1On, col2On, col3On, random, col1Y, col2Y, col3Y) 
    begin
        --Defaults
        stateNext <= stateRegister;
        col1XNext <= col1X;
        col2XNext <= col2X;
        col3XNext <= col3X;
        col1YNext <= col1Y;
        col2YNext <= col2Y;
        col3YNext <= col3Y;
    
        case stateRegister is
            when start =>
                if (button0Pulse = '1') then
                    stateNext <= play;
                    col1XNext <= to_unsigned((638+80), 10);        --start column 1s
                    col2XNext <= (others => '1');
                    col3XNext <= (others => '1');
                    col1YNext <= random;
                else
                    stateNext <= start;
                end if;
            when play =>
                    if enableMovement = '1' then
                        if col1On = '1' then
                            col1XNext <= col1X - 1; 
                        end if;
                        if col2On = '1' then
                            col2XNext <= col2X - 1;
                        end if;
                        if col3On = '1' then
                            col3XNext <= col3X - 1;
                        end if;
                    end if;
                    if col3X = 450 then    --defines space between columns
                        col1XNext <= to_unsigned((638+80), 10);
                        col1YNext <= random;
                    end if;
                    if col2X = 450 then
                        col3XNext <= to_unsigned((638+80), 10);
                        col3YNext <= random;
                    end if;
                    if col1X = 450 then
                        col2XNext <= to_unsigned((638+80), 10);
                        col2YNext <= random;
                    end if;
                    if crashed = '1' or (scoreOnes = 9 and scoreTens = 9) then
                        stateNext <= start;
                    else
                        stateNext <= play;
                    end if;
        end case;
    end process;
    
-------------------------------------Calculate Scores-------------------------------------

scoreOnesNext <= scoreOnes + 1 when (birdLeft = col1X or birdLeft = col2X or birdLeft = col3X) and enableMovement = '1' else
                        (others => '0') when (stateRegister=start and button0Pulse='1') or scoreOnes = 9 else
                        scoreOnes;
scoreTensNext <= scoreTens + 1 when scoreOnes = 9 else
                        (others => '0') when (stateRegister=start and button0Pulse='1') else
                        scoreTens;
                    
highscoreNext <= (scoreTens & scoreOnes) when ((scoreTens&scoreOnes) > highscore and crashed='1') else highscore;

leftSevenSegDataNext <= std_logic_vector(highscore);
rightSevenSegDataNext <= std_logic_vector(scoreTens & scoreOnes);
--=======================================================================================

end Behavioral;
