library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Definition of the TRCUT entity
entity TRCUT is
	Port ( 
		CLK : in STD_LOGIC;  -- Clock signal
		SI  : in STD_LOGIC;  -- Scan Input
		SE  : in STD_LOGIC;  -- Scan Enable
		SO  : out STD_LOGIC  -- Scan Output
	);
end TRCUT;

architecture Structural of TRCUT is
	-- Intermediate signals for CUT inputs
	signal a, b, c, d, j_out, i_out : STD_LOGIC;
	signal scan_out : STD_LOGIC;

	-- Declaration of the Scan_Chain component
	component Scan_Chain
		Port (
			CLK : in STD_LOGIC;
			SE  : in STD_LOGIC;
			SI  : in STD_LOGIC;
			DI1 : in STD_LOGIC;
			DI2 : in STD_LOGIC;
			DI3 : in STD_LOGIC;
			DI4 : in STD_LOGIC;
			a, b, c, d : out STD_LOGIC;
			SO  : out STD_LOGIC
		);
	end component;

	-- Declaration of the CUT component
	component CUT
		Port ( 
			a, b, c, d : in STD_LOGIC;
			i, j : out STD_LOGIC
		);
	end component;

begin
	-- Connecting the CUT
	Cut_Instance: CUT 
	port map (
		a => a, 
		b => b, 
		c => c, 
		d => d, 
		i => i_out,  -- 'i' output of CUT goes to SDFF2
		j => j_out   -- 'j' output of CUT goes to SDFF1
	);

	-- Connecting the Scan Chain
	Scan: Scan_Chain port map (
		CLK => CLK,
		SI  => SI,
		SE  => SE,
		DI1 => j_out,  -- 'j' output of CUT becomes DI1 of SDFF1
		DI2 => i_out,	 -- 'i' output of CUT becomes DI2 of SDFF2
		DI3 => c,       -- 'c' output of CUT becomes DI3 of SDFF3
		DI4 => d,       -- 'd' output of CUT becomes DI4 of SDFF4
		a   => a,  
		b   => b,
		c   => c,
		d   => d,
		SO  => scan_out
	);

	-- Final output selection: Scan Output or CUT Output
	SO <= scan_out;

end Structural;
