----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2023 10:04:18 AM
-- Design Name: 
-- Module Name: maze - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
    
entity maze is
  Port (
        clk:in std_logic;
        btnCpuReset,btnL,btnR,btnU, btnD: in STD_LOGIC;
--        btnC:in std_logic;
        Hsync:out std_logic;
        Vsync:out std_logic;
        vgaRed,vgaGreen,vgaBlue: out std_logic_vector (3 downto 0)
       );
end maze;


architecture Behavioral of maze is
    signal clk25:std_logic;
    signal resetn: std_logic;
    signal colour_B: std_logic_vector(11 downto 0);
    signal pixel_data_from_rom: std_logic_vector(11 downto 0);
    signal pixel_pkq: std_logic_vector(11 downto 0);

    signal address: integer range 0 to 19199;
--    signal colour_Ball: std_logic_vector(11 downto 0);
    signal colour: std_logic_vector(11 downto 0);
    signal HC: integer range 1 to 800;
    signal VC : integer range 1 to 525;
    signal FC : integer range 0 to 2**10-1;
    signal F_End: boolean;
    signal exist_wall:boolean;
    signal ballX_signal : integer range 1 to 640;
    signal ballY_signal : integer range 1 to 480;
    signal collision:boolean;
    signal exist_ball:boolean;
    signal exist_end:boolean;
    signal win:boolean;


    component clk_wiz_0
           Port (clk_out1:out std_logic; 
                 resetn  :in  std_logic;
                 clk_in1 :in  std_logic);
    end component clk_wiz_0;
    
    component VGA
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
    end component;
    
    component background 
    Port ( HC : in integer range 1 to 800;
           VC : in integer range 1 to 525;
           colour_B : out  std_logic_vector (11 downto 0);
           exist_end : out boolean;
           exist_wall: out boolean   
           );
    end component;

    component BallControl 
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
    end component;

    component success
    Port ( resetn : in STD_LOGIC;
           clk25 : in STD_LOGIC;
           F_End: in boolean;
           HC : in integer range 1 to 800;
           VC : in integer range 1 to 525;
           pixel_data_from_rom : out  std_logic_vector (11 downto 0);
           pixel_pkq: out  std_logic_vector (11 downto 0);
           address: integer range 0 to 19199
           );
    end component;
    
begin

VGA_Instance:VGA
    port map(
            clk25 =>clk25,
            resetn =>resetn,
            Hsync =>Hsync,
            Vsync =>Vsync,
            vgaRed =>vgaRed,
            vgaBlue =>vgaBlue,
            vgaGreen =>vgaGreen,
            HC => HC,
            VC => VC,    
            FC => FC,            
            F_End => F_End,
            colour => colour
            );
            
pixelClk: clk_wiz_0
    port map( clk_in1 => clk,
              resetn  => btnCpuReset,
              clk_out1=> clk25);

MazeBackground:background
    port map(
            HC => HC,
            VC => VC,            
            colour_B => colour_B,
            exist_wall => exist_wall,
            exist_end => exist_end
            );
BallControl_Instance: BallControl
        port map (
            clk25 => clk25,
            resetn => resetn,
            btnL => btnL,
            btnR => btnR,
            btnU => btnU,
            btnD => btnD,
            ballX => ballX_signal,
            ballY => ballY_signal,
            collision =>collision,
            win => win,
            F_End => F_End
        );
Success_Display: success
    port map(
        resetn => resetn,
        clk25 => clk25,
        F_End => F_End,
        HC => HC,
        VC => VC,
        pixel_data_from_rom => pixel_data_from_rom,
        pixel_pkq => pixel_pkq,

        address => address
    );     
        
resetn <= btnCpuReset;


process (clk25, resetn)
begin
 if resetn = '0' then
    win <= false;
    collision <= false; 
    
 elsif rising_edge (clk25) then
  
    if exist_ball = true and exist_end = true then
       win <= true;  
     end if;
    if exist_ball = true and exist_wall = true then
        collision <= true;  
    end if;
     
     if F_End then
--       win <= false;
       collision <= false; 
      end if;  
  end if;
    
end process;




process (ballX_signal, ballY_signal, colour_B, win, HC, VC,  pixel_data_from_rom,pixel_pkq)

begin
    if win = false then
        if( HC >= ballX_signal and HC <= (ballX_signal +17 )and VC >= ballY_signal and VC <= (ballY_signal +17) ) then
            address <= (VC - ballY_signal) * 18 + (HC - ballX_signal);
            colour <= pixel_pkq;
            exist_ball <= true;
        else   
            colour <= colour_B;
            exist_ball <= false;
        end if;
    else
        if  HC >= 241 and HC <= 400 and VC >= 180 and VC < 300 then
            address <= (VC-180) * 160 + (HC-241);
            colour <= pixel_data_from_rom;
        else
            colour <= colour_B;
        end if;
    end if;
    
end process;

end Behavioral;
