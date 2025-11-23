library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Testbench entity for Scan_Chain
entity Scan_Chain_tb is
end Scan_Chain_tb;

architecture testbench of Scan_Chain_tb is
	-- Testbench signals
	signal CLK_tb  : STD_LOGIC := '0'; -- Clock
	signal SE_tb   : STD_LOGIC := '0'; -- Scan Enable
	signal SI_tb   : STD_LOGIC := '0'; -- Scan Input
	signal SO_tb   : STD_LOGIC;        -- Scan Output
	signal DI1_tb  : STD_LOGIC := '0'; -- Data Input 1
	signal DI2_tb  : STD_LOGIC := '0'; -- Data Input 2
	signal DI3_tb  : STD_LOGIC := '0'; -- Data Input 3
	signal DI4_tb  : STD_LOGIC := '0'; -- Data Input 4

	-- Clock period
	constant CLK_PERIOD : time := 10 ns;

begin
	-- Instantiate the DUT: Scan_Chain
	DUT: entity work.Scan_Chain
		port map (
			CLK  => CLK_tb,
			SE   => SE_tb,
			SI   => SI_tb,
			SO   => SO_tb,
			DI1  => DI1_tb,
			DI2  => DI2_tb,
			DI3  => DI3_tb,
			DI4  => DI4_tb
		);

	-- Clock generator process
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

	-- Scan Test Process
	process
	begin
		-- Step 1: Reset initial values
		SE_tb <= '0';
		SI_tb <= '0';
		wait for 20 ns;

		-- Step 2: Enable Scan Mode (SE = '1')
		SE_tb <= '1';
		wait for CLK_PERIOD;

		-- Step 3: Serially insert bits into the Scan Chain
		report "Serial Data Loading: 1011";

		SI_tb <= '1'; wait until rising_edge(CLK_tb); -- Bit 1
		SI_tb <= '0'; wait until rising_edge(CLK_tb); -- Bit 2
		SI_tb <= '1'; wait until rising_edge(CLK_tb); -- Bit 3
		SI_tb <= '1'; wait until rising_edge(CLK_tb); -- Bit 4

		-- Step 4: Capture Mode (SE = '0') to store response
		SE_tb <= '0';
		wait until rising_edge(CLK_tb);

		-- Step 5: Read from Scan Chain output
		SE_tb <= '1'; -- Enable Scan Mode for reading SO
		wait for CLK_PERIOD;

		report "Data Reading from Scan Chain:";
		for i in 0 to 3 loop
			wait until rising_edge(CLK_tb);
			report "SO = " & std_logic'image(SO_tb);
		end loop;

		-- End of simulation
		report "Testbench completed successfully!" severity note;
		wait;
	end process;
end testbench;
