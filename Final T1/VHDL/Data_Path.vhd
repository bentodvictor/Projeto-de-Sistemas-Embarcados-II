-------------------------------------
-- Design unit: DataPath			|
-- Description: CORDIC data path	|
-------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.Add1Rip_package.all;
use work.adder_package.all;
use work.Compare_package.all;

entity Data_Path is
	generic(
		DATA_WIDTH	: integer := 16
	);
	port (
      clk				: in std_logic;
		rst				: in std_logic;
		enInput			: in std_logic;
		ready   		: out std_logic;
		enSquare		: in std_logic;
		enSum_2_Root	: in std_logic;
		MuxRoot_Sum_2	: in std_logic;
		MuxSquare		: in std_logic;
		OpMux			: in std_logic;
		menor 			: inout std_logic; 
		input			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		CurrentState	: in std_logic_vector(1 downto 0);
		final_root		: out std_logic_vector(7 downto 0)
	);
end Data_Path;

architecture structural of Data_Path is 
	signal q_input, d_sum2, q_sum2, d_square, q_square, input1_adder2, result_sum_2		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal c_menor, cout1, cout2		: std_logic;
	signal q_root, d_root, result_sum_1: std_logic_vector(7 downto 0);

begin
	-- REGISTER INPUT
	REG_INPUT: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enInput,
        d       => input,
        q       => q_input
     );
	-- REGISTER ROOT	
	REG_ROOT: entity work.RegisterNbits
     generic map (
        WIDTH   => 8
     )
     port map (
        clk     => clk,
        rst     => rst,
        ce      => enSum_2_Root,
        d       => d_root,
        q       => q_root
     );
	 -- REGISTER SUM_2
	 REG_SUM_2: entity work.RegisterNbits
     generic map (
        WIDTH   => 16
     )
     port map (
        clk     => clk,
        rst     => rst,
        ce      => enSum_2_Root,
        d       => d_sum2,
        q       => q_sum2
     );
	 -- REGISTER SQUARE
	 REG_SQUARE: entity work.RegisterNbits
     generic map (
        WIDTH   => 16
     )
     port map (
        clk     => clk,
        rst     => rst,
        ce      => enSquare,
        d       => d_square,
        q       => q_square
     );
	 -- SOMADOR ROOT + 1
	SUM1: entity work.Adder
	generic map(
		ADDER_WIDTH => 8
	)
	port map(
		input0	=>	q_root,
		input1	=>	x"01",
		carry_in	=>	'0',
		result	=>	result_sum_1,
		carry_out	=>	cout1
	);
	-- SOMADOR 2
	SUM2: entity work.Adder
	generic map(
		ADDER_WIDTH => 16
	)
	port map(
		input0	=>	q_sum2,
		input1	=>	input1_adder2,
		carry_in	=>	'0',
		result	=>	result_sum_2,
		carry_out	=>	cout2
	);
	-- COMPARADOR
	COMPARE: entity work.Compare
	port map(
		A		=>	q_input,
		B		=>	result_sum_2,
		AltB	=>	c_menor
	);
	
	-- Lógica para ready
	ready <= '1' when not((CurrentState = "10" and menor = '1') or (CurrentState = "11")) else
			 '0';

	--	Mux para Registradores
	d_root 	<=  x"01" when MuxRoot_Sum_2 = '0' else
				result_sum_1;
	d_sum2	<=	x"0003" when MuxRoot_Sum_2 = '0' else 
				result_sum_2;
	d_square	<=	x"0004" when MuxSquare = '0' else
					result_sum_2;
	
	-- Mux para Somadores
	input1_adder2	<=	x"0002" when OpMux = '0' else
						q_square;
						
	-- Flag menor
	menor	<=	c_menor;
	
	-- Raiz Final
	final_root	<=	q_root;
end  structural;
