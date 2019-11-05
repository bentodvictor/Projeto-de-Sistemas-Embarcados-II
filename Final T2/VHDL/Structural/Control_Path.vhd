---------------------------------------------
-- Design unit: Control_Path				|
-- Description: OddEven Control Path		|
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Control_Path is
    port (
		-- inputs
        clk			    : in std_logic;
		rst			    : in std_logic;
        start           : in std_logic;
        even		    : in std_logic;
		sort		    : in std_logic;
		-- outputs
		SZERO			: out std_logic;
		enEven			: out std_logic;
		MuxEven			: out std_logic;
		CurrentState	: out std_logic_vector(2 downto 0)
	);
end Control_Path;

architecture structural of Control_Path is
	subtype state_t is std_logic_vector(2 downto 0);
	constant S0 : state_t := "000";
	constant S1 : state_t := "001";
	constant S2 : state_t := "010";
	constant S3 : state_t := "011";
	constant S4 : state_t := "100";
	constant S5 : state_t := "101";
	signal CS : state_t;
   
	
	
begin
----------------------------- NEXT STATE -------------------------------------------------------
    
    process(clk, rst)
    begin
		if rst = '1' then
            CS <= S0;
		
		elsif rising_edge(clk) then		
			case CS is
				when S0 =>
					if start = '1' and rst = '0' then
						CS <= S1;
					else
						CS <= S0;
					end if;
						 
				when S1 =>
					if rst = '0' and even = '0' then
						CS <= S2;
					elsif rst = '0' and even = '1' then
						CS <= S3;
					else
						CS <= S0;
					end if;
					
				when S2 =>
					if rst = '0' then
						CS <= S1;
					else
						CS <= S0;
					end if;
				
				when S3 =>                
					if rst = '0' then
						CS <= S5;
					else
						CS <= S0;
					end if;
					
				when S5 =>                
					if rst = '0' and sort = '0' then
						CS <= S1;
					elsif rst = '0' and sort = '1' then
						CS <= S4;
					else
						CS <= S0;
					end if;
					
				when others =>
					if rst = '0' then
						CS <= S4;
					else
						CS <= S0;
					end if; 
					
			end case;
		end if;
	end process;
	
	CurrentState <= CS;		-- Saída para o Control Path
	
	
----------------------------- OUTPUTS -------------------------------------------------------
   MuxEven <= '1' when CS = S2 else '0';
	enEven <= '1' when (CS = S0 or CS = S2 or CS = S3) else '0';
	SZERO <= '1' when CS = S0 else '0';
	
end structural;