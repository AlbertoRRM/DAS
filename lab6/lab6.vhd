---------------------------------------------------------------------
--
--  Fichero:
--    lab6.vhd  15/7/2015
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Laboratorio 6
--
--  Notas de diseño:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab6 is
  port ( 
    rstPb_n : in  std_logic;
    osc     : in  std_logic;
    ps2Clk  : in  std_logic;
    ps2Data : in  std_logic;
    hSync   : out std_logic;
    vSync   : out std_logic;
    RGB     : out std_logic_vector(8 downto 0)
  );
end lab6;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of lab6 is

  constant CLKFREQ : natural := 50_000_000;  -- frecuencia del reloj en MHz

  signal clk, rst_n : std_logic;

  signal data: std_logic_vector(7 downto 0);
  signal dataRdy: std_logic;
  signal qP, aP, pP, lP, spcP: boolean;
  
  signal color : std_logic_vector(2 downto 0);
  
  signal campoJuego, raquetaDer, raquetaIzq, pelota: std_logic;
  
  signal mover, finPartida, reiniciar: boolean;

  signal lineAux, pixelAux : std_logic_vector(9 downto 0);
  
  signal line, yRight, yLeft, yBall: unsigned(7 downto 0);
  signal pixel, xBall: unsigned(7 downto 0);
  
begin

  clk <= osc;
  
  resetSyncronizer : synchronizer
    generic map ( STAGES => 2, INIT => '0' )
    port map ( rst_n => rstPb_n, clk => clk, x => '1', xSync => rst_n );

  ------------------  

  ps2KeyboardInterface : ps2Receiver
    generic map ( REGOUTPUTS => false )
    port map ( rst_n => rst_n, clk => clk, dataRdy => dataRdy, data => data, ps2Clk => ps2Clk, ps2Data => ps2Data);
   
  keyScanner:
  process( rst_n, clk )
    type states is (keyON, keyOFF);
    variable state : states;
    if rst_n='0' then
      state := keyON;
      qP <= false;
      ...
    elsif rising_edge(clk) then
      if dataRdy='1' then
        case state is
          when keyON =>
            case data is
              when X"F0" => state := keyOFF;
              when X"15" => qP <= true;
              ...   
            end case;
          when keyOFF =>
            state := keyON;
            case data is
              when X"15" => qP <= false; 
              ...              
          end case;
        end case;
      end if;
    end if;
  end process;        

------------------  

  screenInteface: vgaInterface
    generic map ( FREQ => 50_000, SYNCDELAY => 0 )
    port map ( rst_n => rst_n, clk => clk, line => lineAux, pixel => pixelAux, R => color, G => color, B => color, hSync => hSync, vSync => vSync, RGB => RGB );

  pixel <= ...;
  line <= ...;
  
  color <= ...;

------------------
  
  campoJuego <= ...;
  raquetaIzq <= ...;
  raquetaDer <= ...;
  pelota     <= ...;

------------------

  finPartida <= ...;
  reiniciar <= ...;   
  
------------------
  
  pulseGen:
  process (rst_n, clk)
    constant maxValue : natural := CLKFREQ/50-1;
    variable count: natural range 0 to maxValue;
  begin
    ...
  end process;    
        
------------------

  yRightRegister:
  process (rst_n, clk)
  begin
    ...
  end process;
  
  yLeftRegister:
  process (rst_n, clk)
  begin
    ...
  end process;
  
------------------
  
  xBallRegister:
  process (rst_n, clk)
    type sense is (left, right);
    variable dir: sense;
  begin
    ...
  end process;

  yBallRegister:
  process (rst_n, clk)
    type sense is (up, down);
    variable dir: sense;
  begin
    ...      
  end process;

end syn;

