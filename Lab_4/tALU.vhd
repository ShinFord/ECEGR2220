--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Start testing the ALU
		datain_a <= X"11223344";	-- DataIn in hex
		datain_b <= X"01234567";
		control  <= "00000";		-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 			-- result = 0x124578AB  and zeroOut = 0
		control <= "00001"; --Subtraction, result = 0x0FFEEDDD and zeroOut = 0
		wait for 20 ns;
		control <= "00010"; --AND, result = 0x01220144 and zeroOut = 0
		wait for 20 ns;		
		control <= "00011"; --OR, result = 0x11237767 and zeroOut = 0
		wait for 20 ns;	
		control <= "00101"; --Right shift 1, result = 0x089119A2 and zeroOut = 0
		wait for 20 ns;	
		control <= "00110"; --Right shift 2, result = 0x04488CD1 and zeroOut = 0
		wait for 20 ns;	
		control <= "00111"; --Right shift 3, result = 0x02244668 and zeroOut = 0
		wait for 20 ns;	
		control <= "01001"; --Left shift 1, result = 0x22446688 and zeroOut = 0
		wait for 20 ns;	
		control <= "01010"; --Left shift 2, result = 0x4488CD10 and zeroOut = 0
		wait for 20 ns;	
		control <= "01011"; --Left shift 3, result = 0x89119A20 and zeroOut = 0
		wait for 20 ns;	

		datain_b <= X"00000123";
		control  <= "10000";		-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 			-- result = 0x11223467  and zeroOut = 0
		control <= "10010"; --ANDi, result = 0x00000100 and zeroOut = 0
		wait for 20 ns;		
		control <= "10011"; --ORi, result = 0x11223367 and zeroOut = 0
		wait for 20 ns;	
		control <= "10101"; --Right i shift 1, result = 0x089119A2 and zeroOut = 0
		wait for 20 ns;	
		control <= "10110"; --Right i shift 2, result = 0x04488CD1 and zeroOut = 0
		wait for 20 ns;	
		control <= "10111"; --Right i shift 3, result = 0x02244668 and zeroOut = 0
		wait for 20 ns;	
		control <= "11001"; --Left i shift 1, result = 0x22446688 and zeroOut = 0
		wait for 20 ns;	
		control <= "11010"; --Left i shift 2, result = 0x4488CD10 and zeroOut = 0
		wait for 20 ns;	
		control <= "11011"; --Left i shift 3, result = 0x89119A20 and zeroOut = 0
		wait for 20 ns;	

		datain_a <= x"12345678";
		datain_b <= x"12345678";
		control <= "00001"; --Subtraction, result = 0x00000000 and zeroOut = 0
		wait for 20 ns;

		wait; -- will wait forever
	END PROCESS;

END;