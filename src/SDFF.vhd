library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Definition of the SDFF (Scan D Flip-Flop) entity
entity SDFF is
	Port (
		CLK : in STD_LOGIC; -- Clock signal
		DI  : in STD_LOGIC; -- Data Input
		SI  : in STD_LOGIC; -- Scan Input
		SE  : in STD_LOGIC; -- Scan Enable
		SO  : out STD_LOGIC -- Scan Output
	);
end SDFF;

architecture Behavioral of SDFF is
	-- Internal signals for multiplexer output and flip-flop state
	signal mux_output : STD_LOGIC;
	signal dff_output : STD_LOGIC;

begin
	-- Multiplexer: Selects between SI (Scan Input) or DI (Data Input) based on SE (Scan Enable)
	mux_output <= SI when SE = '1' else DI;

	-- D Flip-Flop: Captures data on the rising edge of the clock
	process (CLK)
	begin
		if rising_edge(CLK) then
			dff_output <= mux_output;
		end if;
	end process;

	-- Final Output: The output of the D Flip-Flop is assigned to SO
	SO <= dff_output;

end Behavioral;
