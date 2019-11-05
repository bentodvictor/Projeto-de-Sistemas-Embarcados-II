---------------------------------------------
-- Design unit: Control_Path				|
-- Description: Square Control Path			|
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Control_Path is
    port (
	-- inputs
   clk			: in std_logic;
	rst			: in std_logic;
   start  			: in std_logic;
   menor           	: in std_logic;
	-- outputs
	enInput			: out std_logic;
	enSquare		: out std_logic;
	enSum_2_Root		: out std_logic;
	MuxRoot_Sum_2		: out std_logic;
	MuxSquare		: out std_logic;
	OpMux			: out std_logic;
	CurrentState		: out std_logic_vector(1 downto 0)
	);
end Control_Path;

architecture structural of Control_Path is
	subtype state_t is std_logic_vector(1 downto 0);
	constant S0 : state_t := "00";
	constant S1 : state_t := "01";
	constant S2 : state_t := "10";
	constant S3 : state_t := "11";

	signal CS, nextState : state_t;
	
	signal State_code : std_logic_vector(1 downto 0);
   
	
	
begin
	-- State memory
    process(clk, rst)
    begin
        
        if rst = '1' then
            CS <= S0;
        
        elsif rising_edge(clk) then
            CS <= nextState;
            
        end if;
    end process;
    
    -- Next state logic
    process(CS,start,clk, menor, rst)
    begin
		case CS is
            when S0 =>
                if start = '1' and rst = '0' then
                    nextState <= S1;
                else
                    nextState <= S0;
                end if;
					 
            when S1 =>
                if rst = '0' then
                    nextState <= S2;
                else
                    nextState <= S0;
                end if;
            when S2 =>
                if rst = '0' and menor = '1' then
                	nextState <= S3;
                elsif rst = '0' and menor = '0' then
                	nextState <= S1;
		else
			nextState <= S0;
                end if;
            when others =>
                if rst = '1' then
                	nextState <= S0;
                else
			nextState <= S3;
                end if;        
        end case;
	
	end process;
	

	-- CS para Current State
	State_code <= CS;
	CurrentState <= State_code;
	
    	-- Outputs
   enInput <= '1' when CS = S0 else '0';
	enSquare <= '1' when (CS = S0 or CS = S2) else '0';
	enSum_2_Root <= '1' when (CS = S0 or CS = S1) else '0';
	MuxRoot_Sum_2 <= '1' when CS = S1 else 
						  '0' when CS = S0 else 
						  '-'; 		--	'-' don't care
	MuxSquare <= '1' when CS = S2 else 
					 '0' when CS = S0 else 
					 '-'; 		--	'-' don't care
	OpMux <= '1' when CS = S2 else 
				'0' when CS = S1 else 
				'-'; 		--	'-' don't care
	
end structural;
