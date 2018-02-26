---------------------------------------------------------------------
--
--  Fichero:
--    modcounter.vhd  14/7/2015
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Contador ascendente genérico (en núm. de bits y valor máximo)
--
--  Notas de diseño:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity modCounter is
  generic
  (
    MAXVALUE : natural   -- valor maximo alcanzable
  );
  port
  (
    rst_n : in  std_logic;   -- reset asíncrono del sistema (a baja)
    clk   : in  std_logic;   -- reloj del sistema
    clear : in  std_logic;   -- puesta a 0 sincrona
    ce    : in  std_logic;   -- capacitacion de cuenta
    tc    : out std_logic;   -- fin de cuenta
    count : out std_logic_vector(log2(MAXVALUE)-1 downto 0)   -- cuenta
  );
end modCounter;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;

architecture syn of modCounter is

  signal cs : unsigned(count'range);

begin

  stateReg:
  process (rst_n, clk)
  begin
    if rst_n = '0' then
      cs <= 0;
    elsif rising_edge(clk) then
      if clear = '1' then
        cs <= 0;
      elsif clear = '0' then
        if cs = MAXVALUE then
          cs <= 0;
        else 
          cs <= cs + 1;
        end if;
      end if;
    end if;
  end process;

  count <= cs;
  
  tc <= 
    '1' when ce && (cs = MAXVALUE) else
    '0'; 

end syn;
