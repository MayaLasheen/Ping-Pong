----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 12:41:01 PM
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC;
           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnL : in STD_LOGIC;
           btnR : in STD_LOGIC;
           restart : in STD_LOGIC);
end VGA;

architecture Behavioral of VGA is

component Clock_Divider is
port ( clk,reset: in std_logic;
       clock_out: out std_logic);
end component;


signal Clock_Out : STD_LOGIC;
signal Video_Out : STD_LOGIC;
signal p1Wins, p2Wins : STD_LOGIC;
signal Game_Over : STD_LOGIC := '0';
signal leftup : STD_LOGIC := '1';
signal leftdown, rightdown, rightup : STD_LOGIC := '0';
signal H_Count : integer range 0 to 800 := 0;
signal V_Count : integer range 0 to 525 := 0;
signal Draw1, Draw2, Draw3, Draw4, Draw5 : STD_LOGIC;
signal Draw6_1, Draw6_2, Draw6_3 : STD_LOGIC;
signal Draw7_1, Draw7_2, Draw7_3 : STD_LOGIC;

----------------------------------------------------------------------------------------
-- Procedure 1 (Rod)
----------------------------------------------------------------------------------------
procedure Rod (
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if (((x_Cur > x_Pos and x_Cur < (x_Pos + 10)) and (y_Cur > y_Pos and y_Cur < (y_Pos + 100)))) then
        Draw <= '1';
    else
        Draw <= '0';    
    end if;
end procedure;

----------------------------------------------------------------------------------------
-- Procedure 2 (Ball)
----------------------------------------------------------------------------------------
procedure Ball (
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if (((x_Cur > x_Pos and x_Cur < (x_Pos + 20)) and (y_Cur > y_Pos and y_Cur < (y_Pos + 20)))) then
        Draw <= '1';
    else
        Draw <= '0';    
    end if;
end procedure;

----------------------------------------------------------------------------------------
-- Procedure 3 (Border)
----------------------------------------------------------------------------------------
procedure Border (
    signal x_Cur, y_Cur: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if ((((x_Cur >= 1 and x_Cur <= 3) or (x_Cur >= 636 and x_Cur <= 638)) and y_Cur >= 61 and y_Cur <= 478)) then
        Draw <= '1';
    elsif ((((y_Cur >= 61 and y_Cur <= 63) or (y_Cur >= 476 and y_Cur <= 478)) and x_Cur >= 1 and x_Cur <= 638)) then
        Draw <= '1';  
    else
        Draw <= '0';  
    end if;
end procedure; 

----------------------------------------------------------------------------------------
-- Procedure 3 (Middle Line)
----------------------------------------------------------------------------------------
procedure MiddleLine (
    signal x_Cur, y_Cur: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if ((((x_Cur >= 319 and x_Cur <= 321) and y_Cur >= 61 and y_Cur <= 478))) then
        Draw <= '1';  
    else
        Draw <= '0';  
    end if;
end procedure;

----------------------------------------------------------------------------------------
-- Procedure 4 (ScoreBox)
----------------------------------------------------------------------------------------
procedure ScoreBox (
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw : out STD_LOGIC) is
    begin
    if (x_Cur >= x_Pos and x_Cur <= (x_Pos + 40) and y_Cur >= y_Pos and y_Cur <= (y_Pos + 10) ) then
        Draw <= '1';
    else
        Draw <= '0';  
    end if;
end procedure;
        
signal x_Pos_1 : integer := 10;
signal y_Pos_1 : integer := 220;
signal x_Pos_2 : integer := 620;
signal y_Pos_2 : integer := 220;
signal x_Pos_3 : integer := 310;
signal y_Pos_3 : integer := 260;
signal x_Pos_4_1 : integer := 108;
signal x_Pos_4_2 : integer := 153;
signal x_Pos_4_3 : integer := 198;
signal y_Pos_4 : integer := 25;
signal x_Pos_5_1 : integer := 395;
signal x_Pos_5_2 : integer := 440;
signal x_Pos_5_3 : integer := 485;
signal y_Pos_5 : integer := 25;
signal score_1 : integer := 0;
signal score_2 : integer := 0;


begin

CD : Clock_Divider port map (clk, reset, Clock_Out);

Rod(H_Count, V_Count, x_Pos_1, y_Pos_1, Draw1);
Rod(H_Count, V_Count, x_Pos_2, y_Pos_2, Draw2);
Ball(H_Count, V_Count, x_Pos_3, y_Pos_3, Draw3);
Border(H_Count, V_Count, Draw4);
MiddleLine(H_Count, V_Count, Draw5);
ScoreBox(H_Count, V_Count, x_Pos_4_1, y_Pos_4, Draw6_1);
ScoreBox(H_Count, V_Count, x_Pos_4_2, y_Pos_4, Draw6_2);
ScoreBox(H_Count, V_Count, x_Pos_4_3, y_Pos_4, Draw6_3);
ScoreBox(H_Count, V_Count, x_Pos_5_1, y_Pos_5, Draw7_1);
ScoreBox(H_Count, V_Count, x_Pos_5_2, y_Pos_5, Draw7_2);
ScoreBox(H_Count, V_Count, x_Pos_5_3, y_Pos_5, Draw7_3);

----------------------------------------------------------------------------------------
-- Process 1
----------------------------------------------------------------------------------------
HL_Position : process (Clock_Out, reset)
begin
    if (reset = '1') then
        H_Count <= 0;
    elsif (rising_edge(Clock_Out)) then
            if (H_Count = 799) then
                H_Count <= 0;
            else
                H_Count <= H_Count + 1;
            end if;
    end if;         
end process;       

----------------------------------------------------------------------------------------
-- Process 2
----------------------------------------------------------------------------------------
VL_Position : process (Clock_Out, reset, H_Count)
begin
    if (reset = '1') then
        V_Count <= 0;
    elsif (rising_edge(Clock_Out)) then
            if (H_Count = 799) then
                if (V_Count = 525) then
                   V_Count <= 0;
                   if (start = '1' and Game_Over = '0' and restart = '0') then 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                       if (btnD = '1') then
                           if (y_Pos_1 >= 375) then
                               y_Pos_1 <= 375;
                           else
                               y_Pos_1 <= y_Pos_1 + 5;
                           end if;
                       elsif (btnL = '1') then
                           if (y_Pos_1 <= 65) then
                               y_Pos_1 <= 65;
                           else
                               y_Pos_1 <= y_Pos_1 - 5;
                           end if;
                       end if;
                       if (btnR = '1') then
                           if (y_Pos_2 >= 375) then
                               y_Pos_2 <= 375;
                           else
                               y_Pos_2 <= y_Pos_2 + 5;
                           end if;
                       elsif (btnU = '1') then
                           if (y_Pos_2 <= 65) then
                               y_Pos_2 <= 65;
                           else
                               y_Pos_2 <= y_Pos_2 - 5;
                           end if;
                       end if;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                   
                       if (leftup = '1') then
                           x_Pos_3 <= x_Pos_3 - 5;
                           y_Pos_3 <= y_Pos_3 - 5;
                           if (x_Pos_3 <= 20 and y_Pos_3 < y_Pos_1 + 100 and  y_Pos_3 > y_Pos_1 - 20) then -- Collision with rod 1
                               x_Pos_3 <= 20;
                               leftup <= '0';
                               rightup <= '1';
                           end if;
                           if (x_Pos_3 <= 10 and (y_Pos_3 >= y_Pos_1 + 100 or y_Pos_3 <= y_Pos_1 - 20)) then -- Player 2 scores
                               score_2 <= score_2 + 1;
                               if (score_2 = 2) then -- Player 2 wins
                                   p2Wins <= '1';
                                   Game_Over <= '1';
                               else
                                   rightup <= '1';
                               end if; 
                               leftup <= '0';
                           end if;
                           if (y_Pos_3 <= 65) then -- Collision with the upper border
                               y_Pos_3 <= 65;
                               leftup <= '0';
                               leftdown <= '1';
                           end if;
                       end if; -- This is the end if of leftup = 1 case.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                       if (leftdown = '1') then
                           x_Pos_3 <= x_Pos_3 - 5;
                           y_Pos_3 <= y_Pos_3 + 5;  
                           if (x_Pos_3 <= 20 and y_Pos_3 > y_Pos_1 - 20 and  y_Pos_3 < y_Pos_1 + 100) then -- Collsion with rod 1
                               x_Pos_3 <= 20;
                               leftdown <= '0';
                               rightdown <= '1';
                           end if;
                           if (x_Pos_3 <= 10 and (y_Pos_3 >= y_Pos_1 + 100 or y_Pos_3 <= y_Pos_1 - 20)) then -- Player 2 scores
                               score_2 <= score_2 + 1;
                               if (score_2 = 2) then -- Player 2 wins
                                   p2Wins <= '1';
                                   Game_Over <= '1';
                               else
                                   rightdown <= '1';
                               end if;
                               leftdown <= '0';
                           end if;
                           if (y_Pos_3 >= 455) then -- Collision with the lower border
                               y_Pos_3 <= 455;
                               leftdown <= '0';
                               leftup <= '1'; 
                           end if;
                       end if;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                       if (rightup = '1') then
                           x_Pos_3 <= x_Pos_3 + 5;
                           y_Pos_3 <= y_Pos_3 - 5;  
                           if (x_Pos_3 >= 600 and y_Pos_3 < y_Pos_2 + 100 and  y_Pos_3 > y_Pos_2 - 20) then -- Collision with rod 2
                               x_Pos_3 <= 600;
                               rightup <= '0';
                               leftup <= '1';
                           end if;
                           if (x_Pos_3 >= 610 and (y_Pos_3 >= y_Pos_2 + 100 or y_Pos_3 <= y_Pos_2 - 20)) then -- Player 1 scores
                               score_1 <= score_1 + 1;
                               if (score_1 = 2) then -- Player 1 wins
                                   p1Wins <= '1';
                                   Game_Over <= '1';
                               else
                                   leftup <= '1';
                               end if;
                               rightup <= '0';
                           end if;
                           if (y_Pos_3 <= 65) then -- Collision with the upper border
                               y_Pos_3 <= 65;
                               leftdown <= '0';
                               rightdown <= '1';
                           end if;
                       end if;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                       if (rightdown = '1') then
                           x_Pos_3 <= x_Pos_3 + 5;
                           y_Pos_3 <= y_Pos_3 + 5;  
                           if (x_Pos_3 >= 600 and y_Pos_3 < y_Pos_2 + 100 and  y_Pos_3 > y_Pos_2 - 20) then -- Collision with rod 2
                               x_Pos_3 <= 600;
                               rightdown <= '0';
                               leftdown <= '1';
                           end if;
                           if (x_Pos_3 >= 610 and (y_Pos_3 >= y_Pos_2 + 100 or y_Pos_3 <= y_Pos_2 - 20)) then -- Player 1 scores
                               score_1 <= score_1 + 1;
                               if (score_1 = 2) then -- Player 1 wins
                                   p1Wins <= '1';
                                   Game_Over <= '1';
                               else
                                   leftdown <= '1';
                               end if;
                               rightdown <= '0';
                           end if;
                           if (y_Pos_3 >= 455) then -- Collision with the lower border
                               y_Pos_3 <= 455;
                               rightdown <= '0'; 
                               rightup <= '1';
                           end if;
                       end if;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                   end if;
                   if (restart = '1') then
                        Game_Over <= '0';
                        p1Wins <= '0';
                        p2Wins <= '0';
                        score_1 <= 0;
                        score_2 <= 0;
                        rightdown <= '1';
                        x_Pos_1 <= 6;
                        y_Pos_1 <= 230;
                        x_Pos_2 <= 623;
                        y_Pos_2 <= 230;
                        x_Pos_3 <= 310;
                        y_Pos_3 <= 260;
                   end if;
                else
                    V_Count <= V_Count + 1;
                end if;
            end if;
    end if;         
end process; 

----------------------------------------------------------------------------------------
-- Process 3
----------------------------------------------------------------------------------------
HL_Sync : process (Clock_Out, reset, H_Count)
begin
    if (reset = '1') then
        Hsync <= '1';
    elsif (rising_edge(Clock_Out)) then
            if (H_Count > 655 and H_Count < 752) then
                Hsync <= '0';
            else
                Hsync <= '1';
            end if;
    end if;         
end process;

----------------------------------------------------------------------------------------
-- Process 4
----------------------------------------------------------------------------------------
VL_Sync : process (Clock_Out, reset, V_Count)
begin
    if (reset = '1') then
        Vsync <= '1';
    elsif (rising_edge(Clock_Out)) then
            if (V_Count > 489 and V_Count < 492) then
                Vsync <= '0';
            else
                Vsync <= '1';
            end if;
    end if;         
end process;

----------------------------------------------------------------------------------------
-- Process 5
----------------------------------------------------------------------------------------
Display : process (Clock_Out, reset, H_Count, V_Count)
begin
    if (reset = '1') then
        Video_Out <= '0';
    elsif (rising_edge(Clock_Out)) then
            if (V_Count < 490 and H_Count < 656) then
                Video_Out <= '1';
            else
                Video_Out <= '0';
            end if;
    end if;         
end process;

----------------------------------------------------------------------------------------
-- Process 6
----------------------------------------------------------------------------------------
process (Video_Out)
begin
    if (Video_Out = '1') then
        if (Game_Over = '0') then
            if (Draw1 = '1') then -- Player 1
                vgaRed <= "1011";
                vgaBlue <= "1011";
                vgaGreen <= "0000";
            end if;
            if (Draw2 = '1') then -- Player 2
                vgaRed <= "0000";
                vgaBlue <= "1011";
                vgaGreen <= "1011";
            end if;
            if (Draw5 = '1') then -- Middle Line
                vgaRed <= "1111";
                vgaBlue <= "1111";
                vgaGreen <= "1111";
            end if;
            if (Draw4 = '1') then -- Border
                vgaRed <= "1011";
                vgaBlue <= "0000";
                vgaGreen <= "1011";
            end if;
            if (Draw6_1 = '1') then
                if (score_1 >= 1) then
                    vgaRed <= "1011";
                    vgaBlue <= "1011";
                    vgaGreen <= "0000";
                else
                    vgaRed <= "1111";
                    vgaBlue <= "1111";
                    vgaGreen <= "1111";
                end if;
            end if;
            if (Draw6_2 = '1') then
                if (score_1 >= 2) then
                    vgaRed <= "1011";
                    vgaBlue <= "1011";
                    vgaGreen <= "0000";
                else
                    vgaRed <= "1111";
                    vgaBlue <= "1111";
                    vgaGreen <= "1111";
                end if;
            end if;
            if (Draw6_3 = '1') then
                if (score_1 >= 3) then
                    vgaRed <= "1011";
                    vgaBlue <= "1011";
                    vgaGreen <= "0000";
                else
                    vgaRed <= "1111";
                    vgaBlue <= "1111";
                    vgaGreen <= "1111";
                end if;
            end if; 
            if (Draw7_1 = '1') then
                if (score_2 >= 1) then
                    vgaRed <= "0000";
                    vgaBlue <= "1011";
                    vgaGreen <= "1011";
                else
                    vgaRed <= "1111";
                    vgaBlue <= "1111";
                    vgaGreen <= "1111";
                end if;
            end if;
            if (Draw7_2 = '1') then
                if (score_2 >= 2) then
                    vgaRed <= "0000";
                    vgaBlue <= "1011";
                    vgaGreen <= "1011";
                else
                    vgaRed <= "1111";
                    vgaBlue <= "1111";
                    vgaGreen <= "1111";
                end if;
            end if;
            if (Draw7_3 = '1') then
                if (score_2 >= 3) then
                    vgaRed <= "0000";
                    vgaBlue <= "1011";
                    vgaGreen <= "1011";
                else
                    vgaRed <= "1111";
                    vgaBlue <= "1111";
                    vgaGreen <= "1111";
                end if;
            end if;
            if (Draw3 = '1') then -- Ball
                vgaRed <= "1111";
                vgaBlue <= "1111";
                vgaGreen <= "1111";
            end if;
            if (Draw1 = '0' and Draw2 = '0' and Draw3 = '0' and Draw4 = '0' and Draw5 = '0' and
                Draw6_1 = '0' and Draw6_2 = '0' and Draw6_3 = '0' and Draw7_1 = '0' and 
                Draw7_2 = '0' and Draw7_3 = '0') then -- Rest of the Screen
                    vgaRed <= "0000";
                    vgaBlue <= "0000";
                    vgaGreen <= "0000";
            end if;
        end if;
        if (Game_Over = '1') then
            if (p1Wins = '1') then
                if (Draw1 = '1') then -- Player 1
                    vgaRed <= "1011";
                    vgaBlue <= "1011";
                    vgaGreen <= "0000";
                end if;
                if (Draw2 = '1') then -- Player 2
                    vgaRed <= "1011";
                    vgaBlue <= "1011";
                    vgaGreen <= "0000";
                end if;
                if (Draw5 = '1') then -- Middle Line
                    vgaRed <= "1011";
                    vgaBlue <= "1011";
                    vgaGreen <= "0000";
                end if;
                if (Draw4 = '1') then -- Border
                    vgaRed <= "1011";
                    vgaBlue <= "1011";
                    vgaGreen <= "0000";
                end if;
                if (Draw6_1 = '1' or Draw6_2 = '1' or Draw6_3 = '1' or Draw7_1 = '1' or Draw7_2 = '1' or Draw7_3 = '1') then -- Score
                    vgaRed <= "1011";
                    vgaBlue <= "1011";
                    vgaGreen <= "0000";
                end if;
                if (Draw3 = '1') then -- Ball
                    vgaRed <= "1011";
                    vgaBlue <= "1011";
                    vgaGreen <= "0000";
                end if;
                if (Draw1 = '0' and Draw2 = '0' and Draw3 = '0' and Draw4 = '0' and Draw5 = '0' and
                    Draw6_1 = '0' and Draw6_2 = '0' and Draw6_3 = '0' and Draw7_1 = '0' and 
                    Draw7_2 = '0' and Draw7_3 = '0') then -- Rest of the Screen
                    vgaRed <= "0000";
                    vgaBlue <= "0000";
                    vgaGreen <= "0000";
                end if;
            end if;
            if (p2Wins = '1') then
                if (Draw1 = '1') then -- Player 1
                    vgaRed <= "0000";
                    vgaBlue <= "1011";
                    vgaGreen <= "1011";
                end if;
                if (Draw2 = '1') then -- Player 2
                    vgaRed <= "0000";
                    vgaBlue <= "1011";
                    vgaGreen <= "1011";
                end if;
                if (Draw5 = '1') then -- Middle Line
                    vgaRed <= "0000";
                    vgaBlue <= "1011";
                    vgaGreen <= "1011";
                end if;
                if (Draw4 = '1') then -- Border
                    vgaRed <= "0000";
                    vgaBlue <= "1011";
                    vgaGreen <= "1011";
                end if;
                if (Draw6_1 = '1' or Draw6_2 = '1' or Draw6_3 = '1' or Draw7_1 = '1' or Draw7_2 = '1' or Draw7_3 = '1') then -- Score
                    vgaRed <= "0000";
                    vgaBlue <= "1011";
                    vgaGreen <= "1011";
                end if;
                if (Draw3 = '1') then -- Ball
                    vgaRed <= "0000";
                    vgaBlue <= "1011";
                    vgaGreen <= "1011";
                end if;
                if (Draw1 = '0' and Draw2 = '0' and Draw3 = '0' and Draw4 = '0' and Draw5 = '0' and 
                    Draw6_1 = '0' and Draw6_2 = '0' and Draw6_3 = '0' and Draw7_1 = '0' and 
                    Draw7_2 = '0' and Draw7_3 = '0') then -- Rest of the Screen
                    vgaRed <= "0000";
                    vgaBlue <= "0000";
                    vgaGreen <= "0000";
                end if;
            end if;
        end if;        
    else
        vgaRed <= "0000";
        vgaBlue <= "0000";
        vgaGreen <= "0000";
   end if;
end process;    

   
end Behavioral;
