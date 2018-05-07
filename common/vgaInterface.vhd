---------------------------------------------------------------------
--
--  Fichero:
--    vgaInterface.vhd  15/7/2015
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Genera las señales de color y sincronismo de un interfaz VGA
--    con resolución 640x420 px
--
--  Notas de diseño:
--    - Para frecuencias a partir de 50 Mhz en multiplos de 25 MHz 
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity vgaInterface is
  generic(
    FREQ      : natural;  -- frecuencia de operacion en KHz
    SYNCDELAY : natural   -- numero de pixeles a retrasar las señales de sincronismo respecto a las de posición
  );
  port ( 
    -- host side
    rst_n : in  std_logic;   -- reset asíncrono del sistema (a baja)
    clk   : in  std_logic;   -- reloj del sistema
    line  : out std_logic_vector(9 downto 0);   -- numero de linea que se esta barriendo
    pixel : out std_logic_vector(9 downto 0);   -- numero de pixel que se esta barriendo
    R     : in  std_logic_vector(2 downto 0);   -- intensidad roja del pixel que se esta barriendo
    G     : in  std_logic_vector(2 downto 0);   -- intensidad verde del pixel que se esta barriendo
    B     : in  std_logic_vector(2 downto 0);   -- intensidad azul del pixel que se esta barriendo
    -- VGA side
    hSync : out std_logic;   -- sincronizacion horizontal
    vSync : out std_logic;   -- sincronizacion vertical
    RGB   : out std_logic_vector(8 downto 0)   -- canales de color
  );
end vgaInterface;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;

architecture syn of vgaInterface is
  
  constant CYCLESxPIXEL : natural := FREQ/25_000;
  constant PIXELSxLINE  : natural  := 800; 
  constant LINESxFRAME  : natural  := 525;
  
  signal hSyncInt, vSyncInt : std_logic;

  signal pixelCnt : unsigned(pixel'range);
  signal lineCnt  : unsigned(line'range);
  signal blanking : boolean;
  
  signal cycleCntTC : std_logic;
  signal pixelCntTC : std_logic;

begin

  cycleCounter:
  process (rst_n, clk)
    variable cycleCnt : natural range 0 to CYCLESxPIXEL-1;
  begin
    ...
  end process;

  pixelCounter:
  process (rst_n, clk)
  begin
    ...
  end process;

  lineCounter:
  process (rst_n, clk)
  begin
    ...
  end process;

  pixel <= ...;
  line  <= ...;
  
  hSyncInt <= ...;
  vSyncInt <= ...;     
  
  blanking <= ...;
   
  outputRegisters:
  process (rst_n, clk)
  begin
   ...
  end process;
    
end syn;

