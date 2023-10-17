----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/20/2023 10:23:37 AM
-- Design Name: 
-- Module Name: BallControl - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BallControl is
    Port ( clk25 : in STD_LOGIC;
           resetn : in STD_LOGIC;
           btnU : in STD_LOGIC;
		   btnD : in STD_LOGIC;
		   btnL : in STD_LOGIC;
		   btnR : in STD_LOGIC; 
		   collision: in boolean;		   
		   win: in boolean;
           F_End:in boolean;
           ballX: out integer range 1 to 640;
           ballY: out integer range 1 to 480
		   
           );
end BallControl;

architecture Behavioral of BallControl is

    signal x : integer range 1 to 640 ; 
    signal y : integer range 1 to 480 ; 
    signal x_velocity : integer;
    signal y_velocity : integer;
    constant max_x : integer := 630;
    constant max_y : integer:= 470;
    constant min_x : integer := 2;
    constant min_y : integer := 2;
--    constant ball_radius : integer := 5;

begin
    process(clk25, resetn)
    begin
        if resetn = '0' then
            x <= 2;
            y <= 2;     
            x_velocity <= 0;
            y_velocity <= 0;      
        elsif rising_edge(clk25) then
            if F_End = true then
                if collision = false then
         
                   if( btnL = '1' )then
                      x_velocity <=  - 1;
                
                   elsif ( btnR = '1' )then
                    x_velocity <= + 1;
           
                   end if;
            
                   if ( btnU = '1' ) then
                      y_velocity <=  - 1;
                   elsif ( btnD = '1' ) then
                      y_velocity <=  + 1;
                    end if;
             
                    x <= x + x_velocity;
                    y <= y + y_velocity;
             
                    
               else
                     x_velocity <= 0;
                     y_velocity <= 0;
                     x <= x - x_velocity;
                     y <= y - y_velocity;
               end if;
               
               if win = true then
                    x_velocity <= 0;
                    y_velocity <= 0;
                end if;
  
                if x > max_x then
                    x <= max_x;
                 elsif x < min_x then
                    x <= min_x;
                 end if;
                  
           
                if y > max_y then
                     y <= max_y;
                 elsif y < min_y then
                     y <= min_y;
                 end if;
         
         end if;           
                
       end if;      
           
    end process;
    
    ballX <= x;
    ballY <= y;
    
    
end Behavioral;



