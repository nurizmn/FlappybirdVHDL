library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity drawingModule is
    Port ( blank: in std_logic;
           turnGGon: in boolean;
           birdTop, birdLeft: in unsigned(9 downto 0);
           birdOutlineOnOut: out std_logic;
           birdLipsOnOut: out std_logic;
           birdWhiteOnOut: out std_logic; 
           birdColorOnOut: out std_logic; 
           pipeOn: in std_logic;
           groundBorderOnOut: out std_logic;
           birdOutlineRgbOut: out std_logic_vector(7 downto 0);
           birdLipsRgbOut: out std_logic_vector(7 downto 0); 
           birdWhiteRgbOut: out std_logic_vector(7 downto 0);
           birdColorRgbOut: out std_logic_vector(7 downto 0); 
           pipeRgbOut: out std_logic_vector(7 downto 0);
           groundRgbOut: out std_logic_vector(7 downto 0);
           groundBorderOut: out std_logic_vector(7 downto 0);
           pixelX: in std_logic_vector(9 downto 0);
           pixelY: in std_logic_vector(9 downto 0);
           rgb: out std_logic_vector(7 downto 0));
end drawingModule;

architecture Behavioral of drawingModule is

signal pixX, pixY: unsigned(9 downto 0);
signal skyRgb: std_logic_vector(7 downto 0);
signal GG_rgb: std_logic_vector(7 downto 0);
signal GG_on: std_logic;
signal groundOn: std_logic;

--intermediate signals for outputs
signal birdOutlineOn: std_logic;
signal birdLipsOn: std_logic;
signal birdWhiteOn: std_logic; 
signal birdColorOn: std_logic; 
signal groundBorderOn: std_logic;
signal birdOutlineRgb: std_logic_vector(7 downto 0);
signal birdLipsRgb: std_logic_vector(7 downto 0); 
signal birdWhiteRgb: std_logic_vector(7 downto 0);
signal birdColorRgb: std_logic_vector(7 downto 0); 
signal pipeRgb: std_logic_vector(7 downto 0);
signal groundRgb: std_logic_vector(7 downto 0);
signal groundBorder: std_logic_vector(7 downto 0);

begin

pixX <= unsigned(pixelX);
pixY <= unsigned(pixelY);
      
--assignment of intermediate signals to outputs
birdOutlineOnOut <= birdOutlineOn;
birdLipsOnOut <= birdLipsOn;
birdWhiteOnOut <= birdWhiteOn; 
birdColorOnOut <= birdColorOn; 
groundBorderOnOut <= groundBorderOn;
birdOutlineRgbOut <= birdOutlineRgb;
birdLipsRgbOut <= birdLipsRgb; 
birdWhiteRgbOut <= birdWhiteRgb;
birdColorRgbOut <= birdColorRgb; 
pipeRgbOut <= pipeRgb;
groundRgbOut <= groundRgb;
groundBorderOut <= groundBorder;

------------------------------------Bird Draw Logic----------------------------------------	
      birdOutlineOn <= '1' when  
                  ((pixY=birdTop or pixY=birdTop+1) and (pixX>=birdLeft+12 and pixX<=birdLeft+25)) or  --line 0
                  ((pixY=birdTop+2 or pixY=birdTop+3) and ((pixX>=birdLeft+8 and pixX<=birdLeft+11) or pixX=birdLeft+20 or pixX=birdLeft+21 or pixX=birdLeft+26 or pixX=birdLeft+27)) or  --line 1
                  ((pixY=birdTop+4 or pixY=birdTop+5) and (pixX=birdLeft+6 or pixX=birdLeft+7 or pixX=birdLeft+18 or pixX=birdLeft+19 or pixX=birdLeft+28 or pixX=birdLeft+29)) or  --line 2
                  ((pixY=birdTop+6 or pixY=birdTop+7) and ((pixX>=birdLeft+2 and pixX<=birdLeft+11) or pixX=birdLeft+18 or pixX=birdLeft+19 or pixX=birdLeft+24 or pixX=birdLeft+25 or pixX=birdLeft+30 or pixX=birdLeft+31)) or  --line 3
                  ((pixY=birdTop+8 or pixY=birdTop+9) and (pixX=birdLeft or pixX=birdLeft+1 or pixX=birdLeft+12 or pixX=birdLeft+13 or pixX=birdLeft+18 or pixX=birdLeft+19 or pixX=birdLeft+24 or pixX=birdLeft+25 or pixX=birdLeft+30 or pixX=birdLeft+31)) or  --line 4
                  ((pixY=birdTop+10 or pixY=birdTop+11) and (pixX=birdLeft or pixX=birdLeft+1 or pixX=birdLeft+14 or pixX=birdLeft+15 or pixX=birdLeft+18 or pixX=birdLeft+19 or pixX=birdLeft+30 or pixX=birdLeft+31)) or  --line 5
                  ((pixY=birdTop+12 or pixY=birdTop+13) and (pixX=birdLeft or pixX=birdLeft+1 or pixX=birdLeft+14 or pixX=birdLeft+15 or pixX=birdLeft+20 or pixX=birdLeft+21 or pixX=birdLeft+30 or pixX=birdLeft+31)) or  --line 6
                  ((pixY=birdTop+14 or pixY=birdTop+15) and (pixX=birdLeft or pixX=birdLeft+1 or pixX=birdLeft+14 or pixX=birdLeft+15 or (pixX>=birdLeft+22 and pixX<=birdLeft+33))) or  --line 7
                  ((pixY=birdTop+16 or pixY=birdTop+17) and (pixX=birdLeft+2 or pixX=birdLeft+3  or pixX=birdLeft+12 or pixX=birdLeft+13 or pixX=birdLeft+20 or pixX=birdLeft+21 or pixX=birdLeft+34 or pixX=birdLeft+35)) or  --line 8
                  ((pixY=birdTop+18 or pixY=birdTop+19) and ((pixX>=birdLeft+4 and pixX<=birdLeft+11) or pixX=birdLeft+18 or pixX=birdLeft+19 or (pixX>=birdLeft+22 and pixX<=birdLeft+33))) or  --line 9
                  ((pixY=birdTop+20 or pixY=birdTop+21) and (pixX=birdLeft+4 or pixX=birdLeft+5 or pixX=birdLeft+20 or pixX=birdLeft+21 or pixX=birdLeft+32 or pixX=birdLeft+33)) or  --line 10
                  ((pixY=birdTop+22 or pixY=birdTop+23) and ((pixX>=birdLeft+6 and pixX<=birdLeft+11) or (pixX>=birdLeft+22 and pixX<=birdLeft+31))) or  --line 11
                  ((pixY=birdTop+24 or pixY=birdTop+25) and (pixX>=birdLeft+12 and pixX<=birdLeft+21))  --line 12
                  else '0';
      
      birdLipsOn <= '1' when
                  ((pixY=birdTop+16 or pixY=birdTop+17) and (pixX>=birdLeft+22 and pixX<=birdLeft+33)) or  --line 8
                  ((pixY=birdTop+18 or pixY=birdTop+19) and (pixX=birdLeft+20 or pixX=birdLeft+21)) or  --line 9
                  ((pixY=birdTop+20 or pixY=birdTop+21) and (pixX>=birdLeft+22 and pixX<=birdLeft+31))  --line 10
                  else '0';
      
      birdWhiteOn <= '1' when
                  ((pixY=birdTop+2 or pixY=birdTop+3) and (pixX>=birdLeft+22 and pixX<=birdLeft+25)) or  --line 1
                  ((pixY=birdTop+4 or pixY=birdTop+5) and (pixX>=birdLeft+20 and pixX<=birdLeft+27)) or  --line 2
                  ((pixY=birdTop+6 or pixY=birdTop+7) and ((pixX>=birdLeft+20 and pixX<=birdLeft+23) or (pixX>=birdLeft+26 and pixX<=birdLeft+29))) or  --line 3
                  ((pixY=birdTop+8 or pixY=birdTop+9) and ((pixX>=birdLeft+2 and pixX<=birdLeft+11) or (pixX>=birdLeft+20 and pixX<=birdLeft+23) or (pixX>=birdLeft+26 and pixX<=birdLeft+29))) or  --line 4
                  ((pixY=birdTop+10 or pixY=birdTop+11) and ((pixX>=birdLeft+2 and pixX<=birdLeft+13) or (pixX>=birdLeft+20 and pixX<=birdLeft+29))) or  --line 5
                  ((pixY=birdTop+12 or pixY=birdTop+13) and ((pixX>=birdLeft+2 and pixX<=birdLeft+13) or (pixX>=birdLeft+22 and pixX<=birdLeft+29))) or  --line 6
                  ((pixY=birdTop+14 or pixY=birdTop+15) and (pixX>=birdLeft+2 and pixX<=birdLeft+13)) or  --line 7
                  ((pixY=birdTop+16 or pixY=birdTop+17) and (pixX>=birdLeft+4 and pixX<=birdLeft+11))  --line 8
                  else '0';
                  
      birdColorOn <= '1' when
                  ((pixY=birdTop+2 or pixY=birdTop+3) and (pixX>=birdLeft+12 and pixX<=birdLeft+19)) or  --line 1
                  ((pixY=birdTop+4 or pixY=birdTop+5) and (pixX>=birdLeft+8 and pixX<=birdLeft+17)) or  --line 2
                  ((pixY=birdTop+6 or pixY=birdTop+7) and (pixX>=birdLeft+12 and pixX<=birdLeft+17)) or  --line 3
                  ((pixY=birdTop+8 or pixY=birdTop+9) and (pixX>=birdLeft+14 and pixX<=birdLeft+17)) or  --line 4
                  ((pixY=birdTop+10 or pixY=birdTop+11) and (pixX=birdLeft+16 or pixX=birdLeft+17)) or  --line 5
                  ((pixY=birdTop+12 or pixY=birdTop+13) and (pixX>=birdLeft+16 and pixX<=birdLeft+19)) or  --line 6
                  ((pixY=birdTop+14 or pixY=birdTop+15) and (pixX>=birdLeft+16 and pixX<=birdLeft+21)) or  --line 7
                  ((pixY=birdTop+16 or pixY=birdTop+17) and (pixX>=birdLeft+14 and pixX<=birdLeft+19)) or  --line 8
                  ((pixY=birdTop+18 or pixY=birdTop+19) and (pixX>=birdLeft+12 and pixX<=birdLeft+17)) or  --line 9
                  ((pixY=birdTop+20 or pixY=birdTop+21) and (pixX>=birdLeft+6 and pixX<=birdLeft+19)) or  --line 10
                  ((pixY=birdTop+22 or pixY=birdTop+23) and (pixX>=birdLeft+12 and pixX<=birdLeft+21))  --line 11
                  else '0';
      
      GG_on <= '1' when turnGGon and
               ((pixX>=280 and pixX<=310 and pixY>=215 and pixY<=220) or
               (pixX>=280 and pixX<=285 and pixY>=215 and pixY<=265) or
               (pixX>=280 and pixX<=310 and pixY>=260 and pixY<=265) or
               (pixX>=305 and pixX<=310 and pixY>=235 and pixY<=265) or
               (pixX>=300 and pixX<=310 and pixY>=235 and pixY<=245) or
               (pixX>=330 and pixX<=360 and pixY>=215 and pixY<=220) or
               (pixX>=330 and pixX<=335 and pixY>=215 and pixY<=265) or
               (pixX>=330 and pixX<=360 and pixY>=260 and pixY<=265) or
               (pixX>=355 and pixX<=360 and pixY>=235 and pixY<=265) or
               (pixX>=350 and pixX<=360 and pixY>=235 and pixY<=245))
               else '0';
      
      birdOutlineRgb <= "00000000";  --black outline
      birdLipsRgb <= "11101100";  --orange lips
      birdWhiteRgb <= "11111111";
      birdColorRgb <= "11111110";

-----------------------------Column Draw Logic-------------------------------------------
	pipeRgb <= "00010100";		-- solid colored, light green pipes
	groundRgb <= "11110101";	-- orangish ground
	groundBorder <= "00001100";	--Border for the ground

	groundBorderOn <= '1' when (pixY >= 425 and pixY < 430) else '0';
	groundOn <= '1' when pixY >= 430 else '0';
	
	--Output Logic--
    skyRgb <= "00001111";
    GG_rgb <= "11100000";
    
    rgb <= (others=>'0')     when blank='1' else
               GG_rgb        when GG_on='1' else
               groundBorder     when groundBorderOn='1' else
               groundRgb         when groundOn='1' else
               pipeRgb            when pipeOn='1' else
               birdOutlineRgb when birdOutlineOn='1' else
               birdLipsRgb     when birdLipsOn='1' else
               birdWhiteRgb     when birdWhiteOn='1' else
               birdColorRgb     when birdColorOn='1' else
               skyRgb; 
    --------------------------------------    
end Behavioral;
