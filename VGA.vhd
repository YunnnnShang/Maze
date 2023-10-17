----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2023 11:14:09 AM
-- Design Name: 
-- Module Name: VGA - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
    Port ( resetn : in STD_LOGIC;
           clk25 : in STD_LOGIC;
           Hsync :out std_logic;
           Vsync :out std_logic;
           vgaRed,vgaGreen,vgaBlue: out std_logic_vector (3 downto 0);
           HC : out integer range 1 to 800;
           VC : out integer range 1 to 525;
           FC: out integer range 0 to 2**10-1;
           F_End: out boolean;
           colour: in  std_logic_vector (11 downto 0)
          );
end VGA;

architecture Behavioral of VGA is
    signal hcnt:integer range 1 to 800;
    signal vcnt:integer range 1 to 525;
    constant flimit: INTEGER := 2**10-1;
    signal fcnt: integer range 0 to flimit;
--    constant RED :std_logic_vector(11 downto 0) := X"F00";
--    constant ORANGE :std_logic_vector(11 downto 0) := X"F80";
begin
    process(clk25,resetn)
    begin
        if resetn='0' then
          hcnt<=1;
           vcnt<=1;
           fcnt <= 0;
        elsif rising_edge (clk25) then
            F_End <= false;
            if hcnt<800 then
               hcnt<=hcnt + 1;
            else 
               hcnt<=1;
               if vcnt<525 then
                 vcnt<=vcnt + 1;
               else 
                  vcnt<=1;
                  F_End <= true;
                  if fcnt < flimit then
                        fcnt <= fcnt +1;
                  else
                        fcnt <= 0;
                  end if;
                end if;
            end if;
            
      end if;
      
end process;

Hsync<='0' when hcnt >= 657 and hcnt < 753 else '1';

Vsync<='0' when vcnt >= 491 and vcnt < 493 else '1';

HC <= hcnt;
VC <= vcnt;
FC <= fcnt;
process (hcnt, vcnt, colour)
  begin
  if hcnt <= 640 and vcnt <= 480 then
      vgaRed   <= colour (11 downto 8);
      vgaGreen <= colour (7 downto 4);
      vgaBlue  <= colour (3 downto 0);
   else
      vgaRed   <= x"0";
      vgaBlue  <= x"0";
      vgaGreen <= x"0";
   end if;
   
   if hcnt = 1 or hcnt = 640 or vcnt = 1 or vcnt = 480 then
      vgaRed   <= x"0";
      vgaBlue  <= x"0";
      vgaGreen <= x"0";
   end if;
   
   
end process;

end Behavioral;
