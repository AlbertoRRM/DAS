-------------------------------------------------------------------
--
--  Fichero:
--    rs232Receiver.vhd  15/7/2015
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Conversor elemental de una linea serie RS-232 a paralelo con
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

entity rs232Receiver is
  generic (
    FREQ     : natural;  -- frecuencia de operacion en KHz
    BAUDRATE : natural   -- velocidad de comunicacion
  );
  port (
    -- host side
    rst_n   : in  std_logic;   -- reset asíncrono del sistema (a baja)
    clk     : in  std_logic;   -- reloj del sistema
    dataRdy : out std_logic;   -- se activa durante 1 ciclo cada vez que hay un nuevo dato recibido
    data    : out std_logic_vector (7 downto 0);   -- dato recibido
    -- RS232 side
    RxD     : in  std_logic    -- entrada de datos serie del interfaz RS-232
  );
end rs232Receiver;

-------------------------------------------------------------------

use work.common.all;

architecture syn of rs232Receiver is

  -- Registros
  signal bitPos : natural range 0 to 10;
  signal RxDShf : std_logic_vector (7 downto 0);
  -- Señales
  signal RxDSync : std_logic;
  signal readRxD, baudCntCE : std_logic;

begin

  RxDSynchronizer : synchronizer
    generic map ( STAGES => 2, INIT => '0' )
    port map ( rst_n => rst_n, clk => clk, x => RxD, xSync => RxDSync );

  baudCnt:
  process (rst_n, clk)
    ...
  begin
    readRxD <= '0';
    if count = maxValue/2 then
      readRxD <= '1';
    end if;
    if rst_n='0' then
      readRxD <= '0';

    elsif rising_edge(clk) then
      ...;
    end if;
  end process;

  fsmd :
  process (rst_n, clk, bitPos, readRxD, RxDShf)
  begin
    data      <= ...;
    baudCntCE <= ...;
    dataRdy   <= ...;
    if bitPos = 0 then
      baudCntCE <= '0';
    else
      baudCntCE <= '1';
    end if;
    if bitPos = 10 and readRxD = '1' then
      dataRdy <= '1';
    else
      dataRdy <= '0';
    end if;
    if rst_n='0' then
      bitPos <= '0';
    elsif rising_edge(clk) then
      case bitPos is
        when 0 =>                              -- Esperando bit de start
          if RxDSync = '0' then
            bitPos <= 1;
        when 1 =>                              -- Ignora bit de start
          if RxDSync = '1' then
            bitPos <= 2;
        when 10 =>                             -- Ignora bit de stop
          if RxDSync = '0' then
            bitPos <= 0;
        when others =>                         -- Desplaza
          if RxDSync = '1' then
            RxDShf <= RxDSync and RxDShf(7 downto 1);
            bitPos <= bitPos + 1;
      end case;
    end if;
  end process;

end syn;
