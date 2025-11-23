library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Definition of the Scan Chain entity
entity Scan_Chain is
	Port (
		CLK : in STD_LOGIC; -- Clock signal
		SE  : in STD_LOGIC; -- Scan Enable
		SI  : in STD_LOGIC; -- Scan Input
		DI1 : in STD_LOGIC; -- Data Input 1
		DI2 : in STD_LOGIC; -- Data Input 2
		DI3 : in STD_LOGIC; -- Data Input 3
		DI4 : in STD_LOGIC; -- Data Input 4
		a, b, c, d : out STD_LOGIC; -- Outputs to the CUT
		SO  : out STD_LOGIC -- Scan Output
	);
end Scan_Chain;

architecture Structural of Scan_Chain is
	-- Signals for the outputs of the scan flip-flops
	signal Q1, Q2, Q3, Q4 : STD_LOGIC;

	-- Declaration of the SDFF (Scan D Flip-Flop) component
	component SDFF
		Port (
			CLK : in STD_LOGIC; -- Clock signal
			DI  : in STD_LOGIC; -- Data Input
			SI  : in STD_LOGIC; -- Scan Input
			SE  : in STD_LOGIC; -- Scan Enable
			SO  : out STD_LOGIC -- Scan Output
		);
	end component;

begin
	-- Connecting the SDFF flip-flops in the correct sequence
	SDFF1: SDFF port map (CLK => CLK, DI => DI1, SI => SI, SE => SE, SO => Q1);
	SDFF2: SDFF port map (CLK => CLK, DI => DI2, SI => Q1, SE => SE, SO => Q2);
	SDFF3: SDFF port map (CLK => CLK, DI => DI3, SI => Q2, SE => SE, SO => Q3);
	SDFF4: SDFF port map (CLK => CLK, DI => DI4, SI => Q3, SE => SE, SO => Q4);

	-- The outputs of the SDFFs become the inputs of the CUT
	a <= Q1;
	b <= Q2;
	c <= Q3;
	d <= Q4;

	-- Final Scan Output
	SO <= Q4;

end Structural;
