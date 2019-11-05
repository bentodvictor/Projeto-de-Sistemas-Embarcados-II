-------------------------------------------------------------------------
-- Design unit: Square
-- Description: Square top (Control path + Data path) 
--------------------------------------------------------------------------


library IEEE;						
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Square  is
	generic(
        DATA_WIDTH  : integer := 16
	);
	port (
        clk 		: in std_logic;
        rst     	: in std_logic;
		  start		: in std_logic;
        ready       	: out std_logic;
        input      	: in std_logic_vector (DATA_WIDTH-1 downto 0);
        menor       	: inout std_logic;
        final_root  	: out std_logic_vector (7 downto 0)
	);
		
end Square;

architecture structural of Square is  
        
   signal enInput, enSquare, enSum_2_Root	: std_logic;
	signal MuxRoot_Sum_2, MuxSquare, OpMux	: std_logic;
 	signal CurrentState			: std_logic_vector(1 downto 0);
    
begin
	
	CONTROL_PATH: entity work.Control_Path
		port map (
		-- inputs
      clk	=>	clk,
		rst	=>	rst,
		start =>	start,
      menor	=> menor,
		-- outputs
		enInput	=>	enInput,
		enSquare	=>	enSquare,
		enSum_2_Root	=>	enSum_2_Root,
		MuxRoot_Sum_2	=> 	MuxRoot_Sum_2,
		MuxSquare	=>	MuxSquare,
		OpMux	=>	OpMux,
		CurrentState	=>	CurrentState
    );
		
	DATA_PATH: entity work.Data_Path
		generic map (
			DATA_WIDTH	=> DATA_WIDTH
		)
		port map (
      clk	=>	clk,
		rst	=>	rst,
		enInput	=>	enInput,
		ready	=> ready,
		enSquare	=>	enSquare,
		enSum_2_Root	=>	enSum_2_Root,
		MuxRoot_Sum_2	=>	MuxRoot_Sum_2,
		MuxSquare		=>	MuxSquare,
		OpMux	=>	OpMux,
		menor =>	menor,
		input	=>	input,
		CurrentState	=>	CurrentState,
		final_root	=>	final_root
      );
		
end structural;
