library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

package Compare_package is

component Compare is
	port(
		A	: in std_logic_vector(15 downto 0);
		B	: in std_logic_vector(15 downto 0);
		AltB	: out std_logic
	);
end component;

end Compare_package;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
	use work.Compare_package.all;


entity Compare is
	port(
		A	: in std_logic_vector(15 downto 0);
		B	: in std_logic_vector(15 downto 0);
		AltB	: out std_logic
	);
end Compare;

architecture behavioral of Compare is
begin
	AltB	<=	'1' when A < B else 
				'0';
end behavioral;
