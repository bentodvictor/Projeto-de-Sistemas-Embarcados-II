---------------------------------	
-- Design unit: Square			|
-- Description: Square Test		|
---------------------------------


library IEEE;						
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity Square_tb  is
end Square_tb;

architecture tb of Square_tb is
	signal clk:	std_logic;
	signal rst, start,  menor:	std_logic;
   signal input:	std_logic_vector (15 downto 0);
	signal final_root:	std_logic_vector(7 downto 0);
	signal ready:	std_logic;
	signal cicle_counter:	integer := 0;
	
	component Square
	port(
			clk : in std_logic;
			rst : in std_logic;
			start : in std_logic;
			ready : inout std_logic;
			input : in std_logic_vector(15 downto 0);
			menor : inout std_logic;
			final_root: out std_logic_vector(7 downto 0)
		);
	end component;
begin

    clk <= '0', not clk after 3.625 ns;
    rst <= '1', '0' after 2 ns;
    start <= '1', '0' after 8 ns;	
	 input <= "0000000010001001" after 1ns;				-- 137 ~ 19 Ciclos ~ 71.5 ns
	 --input <= "0000010011011011" after 1ns;					--	1243 ~ 67 Ciclos ~246.5 ns
	
	DUV: Square port map(
			clk,
			rst,
			start,
			ready,
			input,
			menor,
			final_root
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