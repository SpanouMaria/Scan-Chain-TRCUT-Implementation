library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Testbench entity for SDFF
entity SDFF_tb is
end SDFF_tb;

architecture testbench of SDFF_tb is
	-- Testbench signals
	signal CLK_tb : STD_LOGIC := '0'; -- Clock signal
	signal DI_tb  : STD_LOGIC := '0'; -- Data input
	signal SI_tb  : STD_LOGIC := '0'; -- Scan input
	signal SE_tb  : STD_LOGIC := '0'; -- Scan enable
	signal SO_tb  : STD_LOGIC;        -- Scan output

	-- Clock period constant
	constant CLK_PERIOD : time := 20 ns;

begin
	-- Instantiate the DUT: SDFF
	UUT: entity work.SDFF
		port map (
			CLK => CLK_tb,
			DI  => DI_tb,
			SI  => SI_tb,
			SE  => SE_tb,
			SO  => SO_tb
		);

	-- Clock generation process
	process
	begin
		while true loop
			CLK_tb <= '0';
			wait for CLK_PERIOD / 2;
			CLK_tb <= '1';
			wait for CLK_PERIOD / 2;
		end loop;
		wait;
	end process;

	-- Test process 
	process
	begin
		-- Initialize/reset values
		DI_tb <= '0';
		SI_tb <= '0';
		SE_tb <= '0';

		-- Wait a bit before starting the tests
		wait for 50 ns;

		-- First test vector: scan mode enabled, scan input = 1
		SE_tb <= '1';
		SI_tb <= '1';
		wait for CLK_PERIOD;

		-- Second test vector: scan mode disabled, data input = 1
		SE_tb <= '0';
		DI_tb <= '1';
		wait for CLK_PERIOD;

		-- Third test vector: scan mode enabled, scan input = 0
		SE_tb <= '1';
		SI_tb <= '0';
		wait for CLK_PERIOD;

		-- Fourth test vector: scan input = 1, data input = 0
		SI_tb <= '1';
		DI_tb <= '0';
		wait for CLK_PERIOD;

		-- End of simulation
		report "Testbench completed successfully!" severity note;
		wait;
	end process;
  
end testbench;
