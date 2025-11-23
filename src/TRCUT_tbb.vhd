library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.ALL;

-- Definition of the TRCUT testbench2 entity
entity TRCUT_tbb is
end TRCUT_tbb;

architecture Behavioral of TRCUT_tbb is
	-- Testbench Signals
	signal CLK_tb : STD_LOGIC := '0'; -- Clock signal
	signal SI_tb  : STD_LOGIC := '0'; -- Scan Input
	signal SE_tb  : STD_LOGIC := '0'; -- Scan Enable
	signal SO_tb  : STD_LOGIC := '0'; -- Scan Output 

	constant CLK_PERIOD : time := 10 ns; -- Clock period
	constant L : integer := 4; -- Length of Scan Chain

	-- Truth Table of CUT
	type truth_table_array is array (0 to 15) of std_logic_vector(1 downto 0);
	constant truth_table : truth_table_array := (
		"00", "10", "10", "10",
		"10", "01", "11", "10",
		"10", "11", "01", "10",
		"10", "10", "10", "00"
	);

	-- Function to convert std_logic_vector to string
	function slv_to_string(slv: std_logic_vector) return string is
		variable result : string(1 to slv'length);
		variable index  : integer := 1;
		begin
			for i in slv'range loop  -- Iterate over all bits
				if slv(i) = '1' then
						result(index) := '1';
				else
						result(index) := '0';
				end if;
				index := index + 1;
			end loop;
			return result;
		end function;


begin
	-- Instantiate TRCUT Unit Under Test (UUT)
	UUT: entity work.TRCUT
		port map (
			CLK => CLK_tb,
			SI  => SI_tb,
			SE  => SE_tb,
			SO  => SO_tb
		);

	-- Clock Generation Process
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

	-- Testbench Process
	process
		variable scan_data : std_logic_vector(L-1 downto 0);
		variable expected_output : std_logic_vector(1 downto 0);
		variable received_output : std_logic_vector(1 downto 0) := (others => '0');
		variable Lout : line;
	begin
		for i in 0 to 15 loop
			scan_data := std_logic_vector(to_unsigned(i, L)); 
			expected_output := truth_table(i);  

			write(Lout, string'("Testing input vector: "));
			write(Lout, i);
			writeline(output, Lout);

			-- 1. Serial Loading into the Scan Chain
			SE_tb <= '1'; -- Enable Scan Mode

			for j in L-1 downto 0 loop
				SI_tb <= scan_data(j);
				wait until rising_edge(CLK_tb);
			end loop;

			-- 2. Capture Mode (SE=0 for one clock cycle)
			SE_tb <= '0';
			wait until rising_edge(CLK_tb);

			-- 3. Simultaneous Read of Old Outputs & Load New Vector
			SE_tb <= '1';
			wait for CLK_PERIOD;

			for j in L-1 downto 0 loop
				received_output(0) := SO_tb;
				SI_tb <= scan_data(j);
				wait until rising_edge(CLK_tb);
			end loop;
			received_output(1) := SO_tb;

			write(Lout, string'("Expected Output: "));
			write(Lout, slv_to_string(expected_output));
			writeline(output, Lout);

			write(Lout, string'("Received Output: "));
			write(Lout, slv_to_string(received_output));
			writeline(output, Lout);

			if slv_to_string(received_output) /= slv_to_string(expected_output) then
				write(Lout, string'("ERROR: Expected = "));
				write(Lout, slv_to_string(expected_output));
				write(Lout, string'(", but got = "));
				write(Lout, slv_to_string(received_output));
				writeline(output, Lout);
			else
				write(Lout, string'("Test Passed for input: "));
				write(Lout, i);
				writeline(output, Lout);
			end if;

			write(Lout, string'("-------------------------------------------"));
			writeline(output, Lout);
		end loop;

		write(Lout, string'("ALL TEST VECTORS EXECUTED SUCCESSFULLY!"));
		writeline(output, Lout);
		wait;
	end process;

end Behavioral;