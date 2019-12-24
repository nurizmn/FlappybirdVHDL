library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity topModule is
	port(
		clk: in std_logic;
		btn: in std_logic_vector(3 downto 0); 
		Hsync: out std_logic;
		Vsync: out std_logic;
		vgaRed: out std_logic_vector(2 downto 0); 
		vgaGreen: out std_logic_vector(2 downto 0);
		vgaBlue: out std_logic_vector(1 downto 0);
		an: out std_logic_vector(3 downto 0);
		seg: out std_logic_vector(6 downto 0);
		dp: out std_logic
	);
end topModule;

architecture Behavioral of topModule is
    
    -- VGA Signals
	signal pixelX, pixelY: std_logic_vector(9 downto 0);
	signal pixX, pixY: unsigned(9 downto 0);
	signal blank: std_logic;
	signal lastColumn: std_logic;
	signal lastRow: std_logic;
	signal rgb: std_logic_vector(7 downto 0);
	signal rst: std_logic;
	signal HS: std_logic;
	signal VS: std_logic;
	
	-- Signals for Flappy Bird Graphics
    signal birdTop: unsigned(9 downto 0):= to_unsigned(200,10);
    signal birdLeft: unsigned(9 downto 0):= to_unsigned(100,10);
    signal birdOutlineOn, birdLipsOn, birdWhiteOn, birdColorOn, pipeOn, groundBorderOn: std_logic;
    signal birdOutlineRgb, birdLipsRgb, birdWhiteRgb, birdColorRgb, pipeRgb, groundRgb, groundBorder: std_logic_vector(7 downto 0);
    signal turnGGon: boolean;
    
    --Clock divided by 4
	signal clkModified: std_logic;
	
	--Signals to generate pseudorandom numbers
	signal random: unsigned (pixelX'range) := (others => '0');
	
	-- Seven Segment Display Signals
    signal dataIn: std_logic_vector(15 downto 0);
    signal dpIn: std_logic_vector(3 downto 0);
    signal blankSegments: std_logic_vector(3 downto 0);
   
    --signals to keep score
    signal rightSevenSegData: std_logic_vector(7 downto 0);
    signal leftSevenSegData: std_logic_vector(7 downto 0);
    
    --Physics
    signal button0, button0Pulse: std_logic;
    
begin
--Component Declarations
vgaTimer: entity work.vgaTiming
           port map(clk=>clkModified, reset=>rst, HS=>HS, VS=>VS, pixelX=>pixelX, pixelY=>pixelY, blank=>blank,
					lastColumn=>lastColumn, lastRow=>lastRow);

clockDivider: entity work.clockDivider
              port map (clock=>clk, clockDividedByFour=>clkModified, reset=>rst);

numberGenerator: entity work.pseudorandomNumberGenerator
                 port map( pixelX=>pixelX, randomOut=>random, clk=>clkModified, pixX=>pixX, pixY=>pixY);

scoreDisplay: entity work.sevenSegmentDisplayModule
              port map(clk=>clkModified, dataIn=>dataIn, dpIn=>dpIn, empty=>blankSegments, seg=>seg, dp=>dp, an=>an);

drawingModule: entity work.drawingModule
              port map( blank=>blank, turnGGon=>turnGGon, birdTop=>birdTop, birdLeft=>birdLeft, birdOutlineOnOut=>birdOutlineOn, 
                        birdLipsOnOut=>birdLipsOn, 
                        birdWhiteOnOut=>birdWhiteOn, birdColorOnOut=>birdColorOn,  
                        groundBorderOnOut=>groundBorderOn, pipeOn=>pipeOn, birdOutlineRgbOut=>birdOutlineRgb, 
                        birdLipsRgbOut=>birdLipsRgb, birdWhiteRgbOut=>birdWhiteRgb, birdColorRgbOut=>birdColorRgb, 
                        pipeRgbOut=>pipeRgb, groundRgbOut=>groundRgb, groundBorderOut=>groundBorder, 
                        pixelX=>pixelX, pixelY => pixelY, rgb=>rgb);

gameStateAndScore: entity work.gameStateAndScoreModule
                   port map( clk => clkModified, btn=>btn, button0Out=>button0, button0pulse=>button0pulse,  
                             random=>random,pixelX=>pixelX,pixelY=>pixelY, birdTop=>birdTop, 
                             birdTopOut=>birdTop, birdLeftOut=>birdLeft, turnGGon => turnGGon, 
                             birdOutlineOn=>birdOutlineOn, groundBorderOn=>groundBorderOn,
                             pipeOnOut=>pipeOn, leftSevenSegData=>leftSevenSegData, 
                             rightSevenSegData=>rightSevenSegData, rgb=>rgb, vgaRed=>vgaRed, 
                             vgaGreen=>vgaGreen, vgaBlue=>vgaBlue, HS=>HS, VS=>VS, Hsync=>Hsync, Vsync=>Vsync, 
                             rst=>rst);
                         
buttonPulseHandler: entity work.btnPulseModule
                    port map (btn=>button0, clk=>clkModified, reset=>rst, buttonPulse=>button0Pulse);
      
      pixX <= unsigned(pixelX);
      pixY <= unsigned(pixelY);
      
      dataIn <= leftSevenSegData & rightSevenSegData;
      blankSegments <= "0000";  --turn on all displays
      dpIn <= "0100";  --turn off decimal points
 end Behavioral;