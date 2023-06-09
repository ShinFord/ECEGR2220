--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

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

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	register8_1: bitstorage PORT MAP (datain(0), enout, writein, dataout(0));
	register8_2: bitstorage PORT MAP (datain(1), enout, writein, dataout(1));
	register8_3: bitstorage PORT MAP (datain(2), enout, writein, dataout(2));
	register8_4: bitstorage PORT MAP (datain(3), enout, writein, dataout(3));
	register8_5: bitstorage PORT MAP (datain(4), enout, writein, dataout(4));
	register8_6: bitstorage PORT MAP (datain(5), enout, writein, dataout(5));
	register8_7: bitstorage PORT MAP (datain(6), enout, writein, dataout(6));
	register8_8: bitstorage PORT MAP (datain(7), enout, writein, dataout(7));

end architecture memmy;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	     	     enout:  in std_logic;
	     	     writein: in std_logic;
	     	     dataout: out std_logic_vector(7 downto 0));
	end component;

	signal inWrite, outEn: std_logic_vector(3 DOWNTO 0);
	signal inWrite_data, outEn_data: std_logic_vector(2 DOWNTO 0);

begin
	inWrite_data <= writein32 & writein16 & writein8;
	outEn_data <= enout32 & enout16 & enout8;

	with inWrite_data select
		inWrite <= "1111" when "100",
			   "0011" when "010",
			   "0001" when "001",
			   "0000" when others;

	with outEn_data select
		outEn <= "0000" when "011",
		         "1100" when "101",
			 "1110" when "110",
			 "1111" when others;

	register32_1: register8 PORT MAP (datain(7 DOWNTO 0), outEn(0), inWrite(0), dataout(7 DOWNTO 0));
	register32_2: register8 PORT MAP (datain(15 DOWNTO 8), outEn(1), inWrite(1), dataout(15 DOWNTO 8));
	register32_3: register8 PORT MAP (datain(23 DOWNTO 16), outEn(2), inWrite(2), dataout(23 DOWNTO 16));
	register32_4: register8 PORT MAP (datain(31 DOWNTO 24), outEn(3), inWrite(3), dataout(31 DOWNTO 24));

end architecture biggermem;

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
	with dir & shamt select
		dataout <= datain(30 DOWNTO 0) & "0" when "000001",
			   datain(29 DOWNTO 0) & "00" when "000010",
			   datain(28 DOWNTO 0) & "000" when "000011",
			   "0" & datain(31 DOWNTO 1) when "100001",
			   "00" & datain(31 DOWNTO 2) when "100010",
			   "000" & datain(31 DOWNTO 3) when "100011",
			   datain when others;
			   
end architecture shifter;



