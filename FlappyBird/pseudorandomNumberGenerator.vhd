library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pseudorandomNumberGenerator is
  Port ( pixelX: in std_logic_vector(9 downto 0);
         randomOut: out unsigned (9 downto 0); 
         clk: in std_logic; 
         pixX: in unsigned(9 downto 0); 
         pixY: in unsigned(9 downto 0));
end pseudorandomNumberGenerator;

architecture Behavioral of pseudorandomNumberGenerator is
    signal random, randomNext, randomTemp: unsigned (pixelX'range) := (others => '0');
begin
    ---------------generates a psuedorandom number between 15 and 255---------------
	process(clk)
	begin
		if clk'event and clk='1' then
			random <= randomNext;
		end if;
	end process;
	-- concatenated values keep it in the proper range
	randomTemp <=  random(6 downto 5) & (pixX(3 downto 1) xor pixY(8 downto 6)) & random(7) & (pixX(5 downto 2) xor pixY(9 downto 6));
	randomNext <= "00" & randomTemp(9 downto 6) & "1111";
    
    randomOut <= random;
end Behavioral;
