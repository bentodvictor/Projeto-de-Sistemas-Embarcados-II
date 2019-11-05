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
use work.Control_Register_package.all;

entity Data_Path is
	generic(
		DATA_WIDTH	: integer := 16
	);
	port (
        -- INPUTS
		clk				: in std_logic;
		rst				: in std_logic;
		inV0, inV1, inV2, inV3, inV4, inV5, inV6, inV7, inV8, inV9:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		even:	inout std_logic;
		sort:	out std_logic;
		sorted:	out std_logic;
		MuxEven:	in std_logic;
		enEven:	in std_logic;
		SZERO:	in std_logic;
		CurrentState:	in std_logic_vector(2 downto 0)
		
	);
end Data_Path;

architecture structural of Data_Path is 
	-- CONTROLE PARA OS REGISTRADORES
	signal enV0, enV1, enV2, enV3, enV4, enV5, enV6, enV7, enV8, enV9:	std_logic;
	signal out0, out1, out2, out3, out4, out5, out6, out7, out8, out9:	std_logic_vector(15 downto 0);
	signal d_V0, d_V1, d_V2, d_V3, d_V4, d_V5, d_V6, d_V7, d_V8, d_V9:	std_logic_vector(15 downto 0);
	--	RESULTADOS DAS COMPARAÇÕES
	signal V0, V1, V2, V3, V4, V5, V6, V7, V8, V9:	std_logic;
	-- SAIDA DOS MUX PARA OS COMPARADORES
	signal out_muxCompare1, out_muxCompare2, out_muxCompare3, out_muxCompare4:	std_logic_vector(15 downto 0);
	--	COMPARADOR 
	signal AltB:	std_logic;
	-- FF
	signal d_ff, q_ff:	std_logic;
	-- SUM
	signal inSum1, inSum2, MuxRegs4:	std_logic_vector(1 downto 0);
	signal cin, cout:	std_logic;
	--	EVEN
	signal d_even, q_even:	std_logic_vector(1 downto 0);
	
begin
	-- REGISTERs FOR VECTORS
	RegV0: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV0,
        d       => d_V0,
        q       => out0
     );
	 RegV1: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV1,
        d       => d_V1,
        q       => out1
     );
	 RegV2: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV2,
        d       => d_V2,
        q       => out2
     );
	 RegV3: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV3,
        d       => d_V3,
        q       => out3
     );
	 RegV4: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV4,
        d       => d_V4,
        q       => out4
     );
	 RegV5: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV5,
        d       => d_V5,
        q       => out5
     );
	 RegV6: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV6,
        d       => d_V6,
        q       => out6
     );
	 RegV7: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV7,
        d       => d_V7,
        q       => out7
     );
	 RegV8: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV8,
        d       => d_V8,
        q       => out8
     );
	 RegV9: entity work.RegisterNbits
    generic map (
		WIDTH   => 16
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enV9,
        d       => d_V9,
        q       => out9
     );
	 
	 -- EVEN
	 RegEVEN: entity work.RegisterNbits
    generic map (
		WIDTH   => 2
    )
    port map (
        clk     => clk,
        rst     => rst,
        ce      => enEven,
        d       => d_even,
        q       => q_even
     );
	 
	 -- SOMADOR
	cin <= '0';
	SUM1: entity work.Adder
	generic map(
		ADDER_WIDTH => 2
	)
	port map(
		input0	=>	inSum1,
		input1	=>	inSum2,
		carry_in	=>	cin,
		result	=>	MuxRegs4,
		carry_out	=>	cout			-- não usado
	);
	
	-- COMPARADORES
	COMPARE_1: entity work.Compare
	port map(
		A		=>	out_muxCompare1,
		B		=>	out1,
		AgtB	=>	V0,
		AltB	=>	V1
	);
	COMPARE_2: entity work.Compare
	port map(
		A		=>	out_muxCompare2,
		B		=>	out3,
		AgtB	=>	V2,
		AltB	=>	V3
	);
	COMPARE_3: entity work.Compare
	port map(
		A		=>	out_muxCompare3,
		B		=>	out5,
		AgtB	=>	V4,
		AltB	=>	V5
	);
	COMPARE_4: entity work.Compare
	port map(
		A		=>	out_muxCompare4,
		B		=>	out7,
		AgtB	=>	V6,
		AltB	=>	V7
	);
	COMPARE_5: entity work.Compare
	port map(
		A		=>	out8,
		B		=>	out9,
		AgtB	=>	v8,
		AltB	=>	AltB		-- não utilizado
	);
	
	-- FF pro sort
	process(clk, rst)
	begin
		if rst = '1' then
			q_ff <= '0';
		elsif rst = '0' and (rising_edge(clk)) then
			q_ff <= d_ff;
		end if;
	end process;
	
	
	-- CONTROL REGISTERs
	CTRL_REGS: entity work.Control_Register
		port map(
		SZERO => SZERO,
		even => even,
		V0 => V0,
		V1 => V1,
		V2 => V2,
		V3 => V3,
		V4 => V4,
		V5 => V5,
		V6 => V6,
		V7 => V7,
		V8 => V8,
		en0 => enV0,
		en1 => enV1,
		en2 => enV2,
		en3 => enV3,
		en4 => enV4,
		en5 => enV5,
		en6 => enV6,
		en7 => enV7,
		en8 => enV8,
		en9 => enV9
		);
	
	
	--- LOGICS -------------------------------------------------------------------------------
	-- SOMADOR
	inSum1 <= "01" when SZERO = '0' else "00";
	inSum2 <= q_even;
	
	-- EVEN
	d_even <= "00" when MuxEven = '0' else "01";
	even <= q_even(0);
	
	-- VERIFICAÇÃO ORDENAÇÃO
	sort <= not(V0 or V2 or V4 or V6 or V8) and q_ff;
	d_ff <= not(V1 or V3 or V5 or V7);
	
	-- SORTED
	sorted <= (not CurrentState(0)) and (not CurrentState(1)) and CurrentState(2);
	
	-- FRONT MUX
	d_V0 <=	inV0 when (not SZERO) = '0' else out1;
	d_V1 <=	inV1 when MuxRegs4 = "00" else out0 when MuxRegs4 = "01" else out2;
	d_V2 <=	inV2 when MuxRegs4 = "00" else out3 when MuxRegs4 = "01" else out1;
	d_V3 <=	inV3 when MuxRegs4 = "00" else out2	when MuxRegs4 = "01" else out4;
	d_V4 <=	inV4 when MuxRegs4 = "00" else out5 when MuxRegs4 = "01" else out3;
	d_V5 <=	inV5 when MuxRegs4 = "00" else out4 when MuxRegs4 = "01" else out6;
	d_V6 <=	inV6 when MuxRegs4 = "00" else out7 when MuxRegs4 = "01" else out5;
	d_V7 <=	inV7 when MuxRegs4 = "00" else out6 when MuxRegs4 = "01" else out8;
	d_V8 <=	inV8 when MuxRegs4 = "00" else out9 when MuxRegs4 = "01" else out7;
	d_V9 <=	inV9 when (not SZERO) = '0' else  out8;
	
	-- MUX FROM COMPARE
	out_muxCompare1 <= out0 when even = '0' else out2;
	out_muxCompare2 <= out2 when even = '0' else out4;
	out_muxCompare3 <= out4 when even = '0' else out6;
	out_muxCompare4 <= out6 when even = '0' else out8;
	
	
end  structural;