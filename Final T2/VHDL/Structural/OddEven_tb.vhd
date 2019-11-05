---------------------------------	
-- Design unit: Square			|
-- Description: Square Test		|
---------------------------------


library IEEE;						
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity OddEven_tb  is
end OddEven_tb;

architecture tb of OddEven_tb is
	signal clk:	std_logic := '1';
	signal rst, start, sorted		: std_logic;
    signal inV0, inV1, inV2, inV3, inV4, inV5, inV6, inV7, inV8, inV9	: std_logic_vector(15 downto 0);
	signal cicle_counter						: SIGNED (7 downto 0);
	
	component OddEven
		port(
		clk 		: in std_logic;
        rst     	: in std_logic;
		start		: in std_logic;
        sorted      : out std_logic;
        inV0, inV1, inV2, inV3, inV4, inV5, inV6, inV7, inV8, inV9:	in std_logic_vector(15 downto 0)
		);
	end component;
	
begin

	-- INICIALIZAÇACOES
    clk <= not clk after 2 ns;
    rst <= '1', '0' after 4 ns;
    start <= '1', '0' after 8 ns;	
	inV0 <= "0000000000000101";
	inV1 <= "0000000000000111";
	inV2 <= "0000000000000001";
	inV3 <= "0000000000000010";
	inV4 <= "0000000000000011";
	inV5 <= "0000000000000100";
	inV6 <= "0000000000000110";
	inV7 <= "0000000000001001";
	inV8 <= "0000000000001000";
	inV9 <= "0000000000000000";
	
	
	DUV: OddEven
		port map(
		clk,
        rst,
		start,
        sorted,
        inV0, inV1, inV2, inV3, inV4, inV5, inV6, inV7, inV8, inV9
		);
	
	process (clk)
		begin
			if(rst = '1') then 
				cicle_counter <= x"00";
			elsif (clk = '1' and clk'event) then 
				cicle_counter <= cicle_counter + x"01";
			end if;
		end process;
end tb;