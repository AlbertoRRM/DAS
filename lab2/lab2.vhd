---------------------------------------------------------------------
--
--  Fichero:
--    lab2.vhd  14/7/2015
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Laboratorio 2
--
--  Notas de diseño:
--
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity lab2 is
port
(
  rstPb_n     : in  std_logic;

  osc         : in  std_logic;
  startStop_n : in  std_logic;
  clear_n     : in  std_logic;
  lap_n       : in  std_logic;
  leftSegs    : out std_logic_vector(7 downto 0);
  rightSegs   : out std_logic_vector(7 downto 0)
);
end lab2;

---------------------------------------------------------------------

use work.common.all;

architecture syn of lab2 is

  component modCounter
    ... 
  end component;

  signal startStopSync_n, clearSync_n, lapSync_n : std_logic;
  signal startStopDeb_n,  clearDeb_n,  lapDeb_n  : std_logic;
  signal startStopFall,   clearFall,   lapFall   : std_logic;
  
  signal lapTFF, startStopTFF : std_logic;
  
  signal cycleCntTC, decCntTC, secLowCntTC : std_logic;
    
  signal decCnt, secLowCnt : std_logic_vector(3 downto 0); 
  signal secHighCnt        : std_logic_vector(2 downto 0);
    
  signal secLowReg  : std_logic_vector(3 downto 0); 
  signal secHighReg : std_logic_vector(2 downto 0);
  
  signal secLowMux, secHighMux : std_logic_vector(3 downto 0); 

begin

  clk   <= osc;
  
  rst_n <= rstPb_n;

  

  ------------------  

  
  startStopSynchronizer : synchronizer
    generic map ( STAGES => 2, INIT => '1' )
    port map ( ... );

  startStopDebouncer : debouncer
    generic map ( FREQ => 50_000, BOUNCE => 50 )
    port map ( ... );
	 
  startStopEdgeDetector : edgeDetector
    port map ( ..., xRise => open );
	 
  clearSynchronizer : synchronizer
    generic map ( ... );
    port map ( ... );

  clearDebouncer : debouncer
    generic map ( ... )
    port map ( ... );
	 
  clearEdgeDetector : edgeDetector
    port map ( ... );
	
  lapSynchronizer : synchronizer
    generic map ( ... );
    port map ( ... );

  lapDebouncer : debouncer
    generic map ( ... )
    port map ( ... );
	 
  lapEdgeDetector : edgeDetector
    port map ( ... );
  
  ------------------  


  toggleFF :
  process (rst_n, clk)
  begin
    if rst_n='0' then
      startStopTFF <= ...;
      lapTFF       <= ...;
    elsif rising_edge(clk) then
      if ... then
        startStopTFF <= ...;
      end if;
      if ... then
        lapTFF <= ...;
      end if;
    end if;
  end process;
	
  cycleCounter : modCounter 
    generic map ( MAXVALUE => 5_000_000-1 )
    port map ( ... );
  
  decCounter : modCounter 
    generic map ( MAXVALUE => 9 )
    port map ( ... );
    
  secLowCounter : modCounter 
    generic map ( ... )
    port map ( ... );
	
  secHighCounter : modCounter 
    generic map ( ... )
    port map ( ... );
  
  lapRegister :
  process (rst_n, clk)
  begin
    if rst_n='0' then
      secLowReg  <= ...;
      secHighReg <= ...;
    elsif rising_edge(clk) then
      if ... then
        secLowReg  <= ...;
        secHighReg <= ...;       
      elsif ... then
        secLowReg <= ...;
        secHighReg <= ...;        
      end if;
    end if;
  end process;

  leftConverterMux :
    secHighMux <= ... when ... else ...;
  
  rigthConverterMux :
    secLowMux <= ... when ... else ...;
  
  leftConverter : bin2segs 
    port map ( ... );
  
  rigthConverter : bin2segs 
    port map ( ... );
  
end syn;
