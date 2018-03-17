---------------------------------------------------------------------
--
--  Fichero:
--    lab4.vhd  15/7/2015
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Laboratorio 4
--
--  Notas de diseño:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab4 is
  port
  (
    rstPb_n   : in  std_logic;
    osc       : in  std_logic;
    ps2Clk    : in  std_logic;
    ps2Data   : in  std_logic;
    leftSegs  : out std_logic_vector(7 downto 0);
    rightSegs : out std_logic_vector(7 downto 0);
    speaker   : out std_logic
  );
end lab4;

---------------------------------------------------------------------

use work.common.all;

architecture syn of lab4 is

  constant CLKFREQ : natural := 50_000_000;  -- frecuencia del reloj en MHz
  
  signal clk, rst_n : std_logic;

  signal dataRdy : std_logic;
  signal code, data : std_logic_vector(7 downto 0);
  signal ldCode : std_logic;
  signal halfPeriod : natural;
  signal speakerTFF, soundEnable: std_logic;
 
begin

  clk <= ...
  
  resetSyncronizer : synchronizer
    generic map ( ... )
    port map ( ... );

  ------------------  
  
  ps2KeyboardInterface : ps2Receiver
    generic map ( ... )
    port map ( ... );
    
  codeRegister :
  process (rst_n, clk)
  begin
    if rst_n='0' then
      code <= ...;
    elsif rising_edge(clk) then
      ...
    end if; 
  end process;
  
  leftConverter : bin2segs 
    port map ( ... );
    
  rigthConverter : bin2segs 
    port map ( ... );
    
  halfPeriodROM :
  with code select
    halfPeriod <=
      CLKFREQ/(2*262) when X"1c",  -- A = Do
          ...         when X"1d",  -- W = Do#
          ...
      0 when others;    
    
  cycleCounter :
  process (rst_n, clk)
    variable count : natural;
  begin
    if rst_n='0' then
      speakerTFF <= ...;
      count := ...;
    elsif rising_edge(clk) then
      ...
    end if; 
  end process;
  
  fsm:
  process (rst_n, clk, dataRdy, data, code)
    type states is (S0, S1, S2, S3); 
    variable state: states;
  begin 
    ...
  end process;  
  
  speaker <= 
    speakerTFF when ... else ...;
  
end syn;
