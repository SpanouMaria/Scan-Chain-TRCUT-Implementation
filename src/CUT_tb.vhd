library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Definition of the CUT testbench entity
entity CUT_tb is
end CUT_tb;

architecture Behavioral of CUT_tb is
	-- Testbench signals for inputs and outputs of CUT
	signal a_tb, b_tb, c_tb, d_tb, i_tb, j_tb : STD_LOGIC := '0';
	
	-- Instantiate the CUT
	component CUT
		Port (
			a, b, c, d : in STD_LOGIC;
			i, j : out STD_LOGIC
		);
	end component;

begin
	-- Connect the CUT to the testbench signals
	UUT: CUT port map (
		a => a_tb,
		b => b_tb,
		c => c_tb,
		d => d_tb,
		i => i_tb,
		j => j_tb
	);

	-- Test process
	process
		variable test_vector : std_logic_vector(3 downto 0);
		variable expected_i, expected_j : STD_LOGIC;
	begin
		wait for 10 ns;
		while true loop
			-- Loop through all possible 4-bit input combinations (0000 to 1111)
			for i in 0 to 15 loop
				test_vector := std_logic_vector(to_unsigned(i, 4));  -- Convert integer to binary
				a_tb <= test_vector(3);
				b_tb <= test_vector(2);
				c_tb <= test_vector(1);
				d_tb <= test_vector(0);
				wait for 10 ns;
      
				-- Compute expected output values based on CUT logic
				expected_i := (a_tb XOR b_tb) AND (c_tb XOR d_tb);
				expected_j := (a_tb XOR c_tb) OR (b_tb XOR d_tb);
				
				-- Check the outputs using assertions
				assert i_tb = expected_i report "Mismatch in i_tb for input " & integer'image(i) severity error;
				assert j_tb = expected_j report "Mismatch in j_tb for input " & integer'image(i) severity error;
				
			end loop;
			-- Report success after all combinations pass
			report "All test cases passed successfully!" severity note;
		end loop;
		wait;
	end process;

end Behavioral;
