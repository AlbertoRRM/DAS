---------------------------------------------------------------------
--
--  Fichero:
--    lab1.vhd  14/7/2015
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Laboratorio 1
--
--  Notas de diseño:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab1 is
  port (
    switches_n : in  std_logic_vector(7 downto 0);
    pbs_n      : in  std_logic_vector(1 downto 0);
    leds       : out std_logic_vector(7 downto 0);
    upSegs     : out std_logic_vector(7 downto 0);
    leftSegs   : out std_logic_vector(7 downto 0);
    rightSegs  : out std_logic_vector(7 downto 0)
  );
end lab1;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of lab1 is

  signal opCode  : std_logic_vector(1 downto 0); 
  signal leftOp  : signed(7 downto 0);
  signal rightOp : signed(7 downto 0);
  signal result  : signed(7 downto 0);
  signal op : std_logic_vector(3 downto 0);
begin
  
  opCode  <= not pbs_n;
  leftOp  <= "0000" & not signed(switches_n(7 downto 4));
  rightOp <= "0000" & not signed(switches_n(3 downto 0));

  ALU:
  with opCode select
   result <= 
		leftOp + rightOp when "00",
		leftOp - rightOp when "01",
			  0 - rightOp when "10",
		leftOp * rightOp when "11",
		"00000000" when others;
	
  op <= "00" & opCode;
  leftConverter : bin2segs 
  port map ( bin => std_logic_vector(result(7 downto 4)), dp => NO, segs => leftSegs );
  
  rigthConverter : bin2segs
  port map ( bin => std_logic_vector(result(3 downto 0)), dp => NO, segs => rightSegs );

  upConverter : bin2segs
  port map ( bin => op, dp => NO, segs => upSegs );

  leds <= not switches_n;
  
end syn;
