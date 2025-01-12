--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	component fulladder is
		port (a, b, cin: in std_logic;
		      sum, carry: out std_logic);
	end component;
	
	signal temp_data: std_logic_vector(31 DOWNTO 0);
	signal carryin: std_logic_vector(32 DOWNTO 0);

begin
	carryin(0) <= add_sub;
	
	with add_sub select
		temp_data <= datain_b when '0',
			     not(datain_b) when others;

	addloop: for i in 31 DOWNTO 0 generate
		adding: fulladder PORT MAP (datain_a(i), temp_data(i), carryin(i), dataout(i), carryin(i+1));
	end generate;
	
end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	
begin
	with shamt(3 DOWNTO 0) select
		dataout <= "0" & datain(31 DOWNTO 1) when "0101",
			   "00" & datain(31 DOWNTO 2) when "0110",
			   "000" & datain(31 DOWNTO 3) when "0111",
			   datain(30 DOWNTO 0) & "0" when "1001",
			   datain(29 DOWNTO 0) & "00" when "1010",
			   datain(28 DOWNTO 0) & "000" when "1011",
			   datain when others;
			   
end architecture shifter;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


--------------------------------------------------------------------------------


Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;


	--immediates
	signal addsub_out_i: std_logic_vector(31 DOWNTO 0);
	signal shift_out_i: std_logic_vector(31 DOWNTO 0);
	signal and_out_i: std_logic_vector(31 DOWNTO 0);
	signal or_out_i: std_logic_vector(31 DOWNTO 0);

	--non-immediates
	signal addsub_out: std_logic_vector(31 DOWNTO 0);
	signal shift_out: std_logic_vector(31 DOWNTO 0);
	signal and_out: std_logic_vector(31 DOWNTO 0);
	signal or_out: std_logic_vector(31 DOWNTO 0);

	--others
	signal carryout: std_logic;
	signal dirCtrl: std_logic;
	signal addorsub: std_logic;
	signal temp_data: std_logic_vector(31 DOWNTO 0);

begin
	with ALUCtrl select
		addorsub <= '0' when "00000",
			    '0' when "10000",
			    '1' when others;
	dirCtrl <= ALUCtrl(2);

	ALU_addsub: adder_subtracter PORT MAP (DataIn1, DataIn2, addorsub, addsub_out, carryout);
	ALU_addsubi: adder_subtracter PORT MAP (DataIn1, DataIn2, addorsub, addsub_out_i, carryout);
	ALU_shift: shift_register PORT MAP (DataIn1, dirCtrl, ALUCtrl, shift_out);
	ALU_shifti: shift_register PORT MAP (DataIn1, dirCtrl, ALUCtrl, shift_out_i);
	and_out <= DataIn1 AND DataIn2;
	and_out_i <= DataIn1 AND DataIn2;
	or_out <= DataIn1 OR DataIn2;
	or_out_i <= DataIn1 OR DataIn2;

	with ALUCtrl select
		temp_data <= addsub_out when "00000",
			     addsub_out when "00001",
			     and_out when "00010",
			     or_out when "00011",
			     shift_out when "00101",
			     shift_out when "00110",
			     shift_out when "00111",
			     shift_out when "01001",
			     shift_out when "01010",
			     shift_out when "01011",

			     addsub_out_i when "10000",
			     and_out_i when "10010",
			     or_out_i when "10011",
			     shift_out_i when "10101",
			     shift_out_i when "10110",
			     shift_out_i when "10111",
			     shift_out_i when "11001",
			     shift_out_i when "11010",
			     shift_out_i when "11011",
			     DataIn2 when others;
	ALUResult <= temp_data;
	with temp_data select
		Zero <= '1' when x"00000000",
			'0' when others;

end architecture ALU_Arch;


