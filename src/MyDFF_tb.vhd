library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench entity for MyDFF
entity MyDFF_tb is
end MyDFF_tb;

architecture testbench of MyDFF_tb is
	-- Testbench signals for inputs and output
	signal CLK_tb : STD_LOGIC := '0'; -- Clock signal
	signal D_tb   : STD_LOGIC := '0'; -- Data input
	signal Q_tb   : STD_LOGIC;        -- Output

	-- Clock period constant
	constant CLK_PERIOD : time := 20 ns;

begin
	-- Instantiate the DUT: MyDFF
	DUT: entity work.MyDFF
		port map (
			CLK => CLK_tb,
			D   => D_tb,
			Q   => Q_tb
		);

	-- Clock generation process
	process
	begin
		CLK_tb <= '0';
		wait for CLK_PERIOD / 2;
		while true loop
			CLK_tb <= not CLK_tb;    -- Toggle the clock
			wait for CLK_PERIOD / 2; -- Half-period delay
		end loop;
		wait;
	end process;

	-- Stimulus process to apply test vectors to MyDFF
	process
	begin
		wait for 60 ns;
		D_tb <= '0';               -- Apply 0 to D after 60 ns
		wait for 60 ns;
		D_tb <= '1';               -- Apply 1 to D after another 60 ns
    
		-- Stop simulation after some time
		wait for 100 ns;
		report "Testbench completed" severity note;
		wait;
	end process;
  
end testbench;
