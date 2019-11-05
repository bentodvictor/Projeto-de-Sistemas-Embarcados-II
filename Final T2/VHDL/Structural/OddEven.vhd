-------------------------------------------------------------------------
-- Design unit: OddEven
-- Description: Square top (Control path + Data path) 
--------------------------------------------------------------------------


library IEEE;						
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity OddEven  is
	generic(
        DATA_WIDTH  : integer := 16
	);
	port (
        clk 		: in std_logic;
        rst     	: in std_logic;
		start		: in std_logic;
        sorted      : out std_logic;
        inV0, inV1, inV2, inV3, inV4, inV5, inV6, inV7, inV8, inV9:	in std_logic_vector(DATA_WIDTH-1 downto 0)
	);
		
end OddEven;

architecture structural of OddEven is  
        
    signal even, sort, MuxEven, enEven, SZERO: std_logic;
 	signal CurrentState	: std_logic_vector(2 downto 0);
    
begin


	CONTROL_PATH: entity work.Control_Path
		port map (
		clk			    => clk,
		rst			    => rst,
        start           => start,
        even		    => even,
		sort		    => sort,
		SZERO			=> SZERO,
		enEven			=> enEven,
		MuxEven			=> MuxEven,
		CurrentState	=> CurrentState
    );
		
	DATA_PATH: entity work.Data_Path
		generic map (
			DATA_WIDTH	=> DATA_WIDTH
		)
		port map (
		clk => clk,
		rst => rst,
		inV0 => inV0,
		inV1 => inV1,
		inV2 => inV2,
		inV3 => inV3,
		inV4 => inV4,
		inV5 => inV5,
		inV6 => inV6,
		inV7 => inV7,
		inV8 => inV8,
		inV9 => inV9,
		even => even,
		sort => sort,
		sorted => sorted,
		MuxEven => MuxEven,
		enEven => enEven,
		SZERO => SZERO,
		CurrentState => CurrentState
        );
		
end structural;
