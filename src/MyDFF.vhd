library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Definition of the MyDFF (D Flip-Flop) entity
entity MyDFF is
	Port (
		CLK : in STD_LOGIC; -- Clock signal
		D   : in STD_LOGIC; -- Data input
		Q   : out STD_LOGIC -- Data output
	);
end MyDFF;

architecture Behavioral of MyDFF is
	-- Internal signal to store the flip-flop state
	signal Q_reg : STD_LOGIC;

begin
	-- **D Flip-Flop:** Captures data on the rising edge of the clock
	process (CLK)
	begin
		if rising_edge(CLK) then
			Q_reg <= D; -- Store the value of D in the register on clock edge
		end if;
	end process;

	-- Output Assignment: The stored value is assigned to Q
	Q <= Q_reg;

end Behavioral;
