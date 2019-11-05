---------------------------------	
--      SQUARE BEHAVIORAL       |
-- Design unit: Square			|
-- Description: Square Test		|
---------------------------------



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity Square_behavioral  is
    port (
	-- inputs
    clk			    : in std_logic;
		rst			    : in std_logic;
    start  		    : in std_logic;
	-- outputs
    INPUT_i           : in std_logic_vector(15 downto 0);
    SQUARE_i         : inout std_logic_vector(15 downto 0);
    SUM_2_i           : inout std_logic_vector(15 downto 0);
    ROOT_i            : inout std_logic_vector(7 downto 0);
    READY           : out std_logic
	-- CSout				:out std_logic_vector(1 downto 0)
	);

end Square_behavioral;

architecture behavioral of Square_behavioral is
   type state is (S0, S1, S2, S3);
	signal CS : state;
	signal aux: std_logic_vector(15 downto 0);
begin
	aux <= SQUARE_i + SUM_2_i; 
-- Behavioral logic
    process(rst, clk)
    begin
		if rst = '1' then
            CS <= S0;
		elsif (rising_edge(clk)) then
		case CS is
            when S0 =>
            ROOT_i <= "00000001";
            SQUARE_i <= x"0004";
            SUM_2_i <= x"0003";
            READY <= '1';
                if start = '1' then
                    CS <= S1;
                else
                    CS <= S0;
                end if;

            when S1 =>
                ROOT_i <= ROOT_i + x"01";
                SUM_2_i <= SUM_2_i + x"0002";
					 
					 CS <= S2;
					 
            when S2 =>  
					SQUARE_i <= aux;
                if INPUT_i < aux then
                	CS <= S3;
                 READY <= '0';
                else
                	CS <= S1;            
                end if;
            when others =>
			        CS <= S3;
        end case;
		end if;
	end process;

end behavioral;

