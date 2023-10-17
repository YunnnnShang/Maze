----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/19/2023 09:25:06 AM
-- Design Name: 
-- Module Name: background - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity background is
    Port ( HC : in integer range 1 to 800;
           VC : in integer range 1 to 525;
           colour_B : out  std_logic_vector (11 downto 0);
           exist_wall: out boolean;
           exist_end : out boolean    
           );
end background;

architecture Behavioral of background is
 

signal colbg: std_logic_vector (11 downto 0) ; 
constant coldeepgreen : std_logic_vector(11 downto 0) := x"FFF"; -- Deep Green color
constant collightgreen : std_logic_vector(11 downto 0) := x"1F0"; -- Light Green color
signal colwall : std_logic_vector(11 downto 0);                  -- Wall color mixed (to be determined by HC and VC)
constant colbrown : std_logic_vector(11 downto 0) := x"952";       -- Brown color
constant colblack : std_logic_vector(11 downto 0) := x"000";       -- Black color
signal colend  : std_logic_vector(11 downto 0) := x"EE0";        -- End color (Yellow)
begin
  

process(HC, VC)
begin

-- Determine grass color (background)
    if (HC mod 2 = 0 and VC mod 3 = 0) or (HC mod 3 = 0 and VC mod 2 = 0) then
        colbg <= coldeepgreen;
    else
        colbg <= collightgreen;
    end if;

    -- Determine wall mix color
    if (VC mod 4 = 0) then
        colwall <= colblack;
    else
        colwall <= colbrown;
    end if;
     -- Maze Walls:
     --wall1
     if VC < 90 and  HC > 40 and HC < 60  then
		colour_B <= colwall;
		exist_wall <= true;
     elsif VC < 100 and  VC >=80 and HC < 220 and HC > 40  then
        colour_B <= colwall;
        exist_wall <= true;
     elsif  HC >= 200 and HC < 220 and VC >= 100 and VC < 250 then
        colour_B <= colwall;
        exist_wall <= true;  
     elsif VC <= 270 and  VC >= 250 and HC < 220  and HC >= 40 then
        colour_B <= colwall;
        exist_wall <= true;
     --wall2                  
     elsif VC > 150 and VC < 170 and HC < 150 and HC > 40 then
        colour_B <= colwall;
        exist_wall <= true;
     elsif VC > 190 and VC < 210 and HC < 150 then
        colour_B <= colwall;
        exist_wall <= true;
     elsif VC >= 170 and VC <= 190 and HC < 150 and HC >= 130 then
        colour_B <= colwall;
        exist_wall <= true;
     --wall3           
     elsif VC < 55 and  VC >=35 and HC < 320 and HC > 90  then
        colour_B <= colwall;
        exist_wall <= true;
     elsif VC < 310  and VC >= 40 and HC < 300 and HC >= 280  then
        colour_B <= colwall;
        exist_wall <= true;   
      --wall4  
     elsif  HC < 380 and HC >= 360  and VC < 280 then
        colour_B <= colwall;
        exist_wall <= true;   
     elsif VC < 100 and  VC >= 80 and HC <= 360 and HC > 320  then
        colour_B <= colwall;
        exist_wall <= true;
     elsif VC < 300 and  VC >= 280 and HC <= 500 and HC >= 360  then
        colour_B <= colwall;
        exist_wall <= true;
     elsif  HC < 460 and HC >= 440  and VC < 400 and VC >= 300 then
        colour_B <= colwall;
        exist_wall <= true;   
      --wall5        
     elsif VC > 300 and VC < 320 and  HC <= 300 and HC > 40 then
        colour_B <= colwall;
        exist_wall <= true;
     elsif VC <= 380 and  VC >= 320 and HC < 60 and HC > 40  then
        colour_B <= colwall;
        exist_wall <= true;   
     elsif VC >= 320 and HC > 100 and HC < 120 then
        colour_B <= colwall;
        exist_wall <= true;
     elsif VC >= 460 and  HC < 180 then
        colour_B <= colwall;
        exist_wall <= true;  
     --wall6    
     elsif VC >= 360 and VC < 380  and  HC > 500 then
        colour_B <= colwall;
        exist_wall <= true;  
     elsif VC >= 100 and VC < 120  and  HC > 440 then
        colour_B <= colwall;
        exist_wall <= true;  
     elsif VC >= 400 and  VC <= 420 and HC < 460  and HC >= 300  then
        colour_B <= colwall;
        exist_wall <= true;
     --wall7
     elsif VC >= 200 and  VC <= 220 and HC >= 550  then
        colour_B <= colwall;
        exist_wall <= true;
     elsif VC >= 220 and  VC <= 320 and HC >= 550 and  HC < 570  then
        colour_B <= colwall;
        exist_wall <= true;
      elsif VC >= 50 and  VC <= 70 and HC >= 580   then
        colour_B <= colwall;
        exist_wall <= true;  
    -- End Point: 
     elsif VC >230 and VC < 250 and  HC > 610 then
		colour_B <= colend;
		exist_end <= true;  
		exist_wall <= false;	

     else
        colour_B <=  colbg;
		exist_wall <= false;	
     end if;

   
end process;						
			

end Behavioral;
