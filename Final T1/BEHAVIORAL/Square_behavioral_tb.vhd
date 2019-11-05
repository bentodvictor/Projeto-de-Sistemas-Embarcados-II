---------------------------------	
-- Design unit: Square			|
-- Description: Square Test		|
---------------------------------


library IEEE;						
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity Square_behavioral_tb  is
end Square_behavioral_tb;

architecture tb of Square_behavioral_tb is
	signal clk			    : std_logic := '1';
	signal rst			    :  std_logic;
    signal start  		    :  std_logic;
    signal INPUT_i           :  std_logic_vector(15 downto 0);
    signal SQUARE_i         :  std_logic_vector(15 downto 0);
    signal SUM_2_i           :  std_logic_vector(15 downto 0);
    signal ROOT_i            :  std_logic_vector(7 downto 0);
    signal READY           :  std_logic;
	 signal cicle_counter:	integer := 0;
	-- signal CSout			:std_logic_vector(1 downto 0);
	 
	component Square_behavioral
	port(
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
	--	CSout				: out std_logic_vector(1 downto 0)
		);
	end component;
begin

    clk <= not clk after 3.5 ns;
    rst <= '1', '0' after 1.75 ns;
    start <= '1', '0' after 8 ns;	
--INPUT_i <= "0000000010001001" after 1ns;				-- 137 ~ 19 Ciclos ~ 71.5 ns
	 INPUT_i <= "0000010011011011" after 1ns;					--	1243 ~ 67 Ciclos ~246.5 ns
	
	DUV: Square_behavioral port map(
		-- inputs
		clk,
		rst,
		start,
		-- outputs
		INPUT_i,
		SQUARE_i,
		SUM_2_i,
		ROOT_i,
		READY
--		CSout
		);
	
	process (clk)
		begin
			if(rst = '1') then 
				cicle_counter <= 0;
			elsif rising_edge(clk) then 
				cicle_counter <= cicle_counter + 1;
			end if;
		end process;
end tb;
