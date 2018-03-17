-------------------------------------------------------------------
--
--  Fichero:
--    rs232Transmitter.vhd  15/7/2015
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Conversor elemental de paralelo a una linea serie RS-232 con 
--    protocolo de strobe
--
--  Notas de diseño:
--    - Parity: NONE
--    - Num data bits: 8
--    - Num stop bits: 1
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity rs232Transmitter is
  generic (
    FREQ     : natural;  -- frecuencia de operacion en KHz
    BAUDRATE : natural   -- velocidad de comunicacion
  );
  port (
    -- host side
    rst_n   : in  std_logic;   -- reset asíncrono del sistema (a baja)
    clk     : in  std_logic;   -- reloj del sistema
    dataRdy : in  std_logic;   -- se activa durante 1 ciclo cada vez que hay un nuevo dato a transmitir
    data    : in  std_logic_vector (7 downto 0);   -- dato a transmitir
    busy    : out std_logic;   -- se activa mientras esta transmitiendo
    -- RS232 side
    TxD     : out std_logic    -- salida de datos serie del interfaz RS-232
  );
end rs232Transmitter;

-------------------------------------------------------------------

use work.common.all;

architecture syn of rs232Transmitter is

  -- Registros
  signal bitPos : natural range 0 to 10;   
  signal TxDShf : std_logic_vector(9 downto 0);
  -- Señales
  signal baudCntCE, writeTxD : std_logic;

begin

  baudCnt:
  process (rst_n, clk)
    constant numCycles : natural := (FREQ*1000)/BAUDRATE;
    constant maxValue  : natural := numCycles-1;
    variable count     : natural range 0 to maxValue;
  begin
    writeTxD <= '0';
    if count=maxValue then
      writeTxD <= '1';
    end if;
    if rst_n='0' then
      count := 0;
    elsif rising_edge(clk) then
      if baudCntCE='0' then
        count := 0;
      else
        ...
      end if;
    end if;
  end process;
  
  fsmd :
  process (rst_n, clk, bitPos, TxDShf)
  begin
    TxD       <= TxDShf(0);
    baudCntCE <= '1';
    busy      <= '1';
    if bitPos=0 then
      baudCntCE <= '0';
      busy      <= '0';
    end if;
    if rst_n='0' then
      TxDShf <= (others =>'1'); 
      bitPos <= 0;
    elsif rising_edge(clk) then
      case bitPos is
        when 0 =>                              -- Esperando solicitud de envio
          ...
        when 10 =>                             -- Desplaza                             
          ...
        when others =>                         -- Desplaza
          ...
      end case;
    end if;
  end process;
  
end syn;

