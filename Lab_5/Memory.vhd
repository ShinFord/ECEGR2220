--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
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
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	if ((WE = '1') AND (to_integer(unsigned(Address)) >= 0) AND (to_integer(unsigned(Address)) <= 127)) THEN
		i_ram(to_integer(unsigned(Address))) <= DataIn;
	else
		null;
	end if;
    end if;

    if ((OE = '0') AND (to_integer(unsigned(Address)) >= 0) AND (to_integer(unsigned(Address)) <= 127)) THEN
	DataOut <= i_ram(to_integer(unsigned(Address)));
    else
	DataOut <= (others => 'Z');
    end if;

  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
	type outData is array(7 DOWNTO 0) of std_logic_vector(31 DOWNTO 0);
	signal reg0to7: outData;

	signal reg_enable: std_logic_vector(7 DOWNTO 0);

begin
	process(WriteReg, WriteCmd) is
	begin
		if WriteCmd = '1' THEN
			if WriteReg = "01010" then
				reg_enable(0) <= '1';
			elsif WriteReg = "01011" then
				reg_enable(1) <= '1';
			elsif WriteReg = "01100" then
				reg_enable(2) <= '1';
			elsif WriteReg = "01101" then
				reg_enable(3) <= '1';
			elsif WriteReg = "01110" then
				reg_enable(4) <= '1';
			elsif WriteReg = "01111" then
				reg_enable(5) <= '1';
			elsif WriteReg = "10000" then
				reg_enable(6) <= '1';
			elsif WriteReg = "10001" then
				reg_enable(7) <= '1';
			else
				reg_enable <= "00000000";
			end if;
		else
			null;
		end if;
	end process;

	Reg32s: for i in 7 DOWNTO 0 generate
		reg: register32 PORT MAP (Writedata, '0', '1', '1', reg_enable(i), '0', '0', reg0to7(i));
	end generate;

	process(ReadReg1) is
	begin
		if ReadReg1 = "01010" then
			ReadData1 <= reg0to7(0);
		elsif ReadReg1 = "01011" then
			ReadData1 <= reg0to7(1);
		elsif ReadReg1 = "01100" then
			ReadData1 <= reg0to7(2);
		elsif ReadReg1 = "01101" then
			ReadData1 <= reg0to7(3);
		elsif ReadReg1 = "01110" then
			ReadData1 <= reg0to7(4);
		elsif ReadReg1 = "01111" then
			ReadData1 <= reg0to7(5);
		elsif ReadReg1 = "10000" then
			ReadData1 <= reg0to7(6);
		elsif ReadReg1 = "10001" then
			ReadData1 <= reg0to7(7);
		elsif ReadReg1 = "00000" then
			ReadData1 <= x"00000000";
		else
			ReadData1 <= (others => 'X');
		end if;
	end process;

	process(ReadReg2) is
	begin
		if ReadReg2 = "01010" then
			ReadData2 <= reg0to7(0);
		elsif ReadReg2 = "01011" then
			ReadData2 <= reg0to7(1);
		elsif ReadReg2 = "01100" then
			ReadData2 <= reg0to7(2);
		elsif ReadReg2 = "01101" then
			ReadData2 <= reg0to7(3);
		elsif ReadReg2 = "01110" then
			ReadData2 <= reg0to7(4);
		elsif ReadReg2 = "01111" then
			ReadData2 <= reg0to7(5);
		elsif ReadReg2 = "10000" then
			ReadData2 <= reg0to7(6);
		elsif ReadReg2 = "10001" then
			ReadData2 <= reg0to7(7);
		elsif ReadReg2 = "00000" then
			ReadData2 <= x"00000000";
		else
			ReadData2 <= (others => 'X');
		end if;
	end process;
end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
