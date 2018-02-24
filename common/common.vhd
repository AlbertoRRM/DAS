---------------------------------------------------------------------
--
--  Fichero:
--    common.vhd  22/3/2017
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Contiene definiciones de constantes, funciones de utilidad
--    y componentes reusables
--
--  Notas de diseño:
--
---------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package common is

  constant YES  : std_logic := '1';
  constant NO   : std_logic := '0';
  constant HI   : std_logic := '1';
  constant LO   : std_logic := '0';
  constant ONE  : std_logic := '1';
  constant ZERO : std_logic := '0';
  
  -- Calcula el logaritmo en base-2 de un numero.
  function log2(v : in natural) return natural;
  -- Selecciona un entero entre dos.
  function int_select(s : in boolean; a : in integer; b : in integer) return integer;
  -- Convierte un real en un signed en punto fijo con qn bits enteros y qm bits decimales. 
  function toFix( d: real; qn : natural; qm : natural ) return signed; 
  
  -- Convierte codigo binario a codigo 7-segmentos
  component bin2segs
    port
    (
      -- host side
      bin  : in  std_logic_vector(3 downto 0);   -- codigo binario
      dp   : in  std_logic;                      -- punto
      -- leds side
      segs : out std_logic_vector(7 downto 0)    -- codigo 7-segmentos
    );
  end component;
 
end package common;

-------------------------------------------------------------------

package body common is

  function log2(v : in natural) return natural is
    variable n    : natural;
    variable logn : natural;
  begin
    n := 1;
    for i in 0 to 128 loop
      logn := i;
      exit when (n >= v);
      n := n * 2;
    end loop;
    return logn;
  end function log2;
  
  function int_select(s : in boolean; a : in integer; b : in integer) return integer is
  begin
    if s then
      return a;
    else
      return b;
    end if;
    return a;
  end function int_select;
  
  function toFix( d: real; qn : natural; qm : natural ) return signed is 
  begin 
    return to_signed( integer(d*(2.0**qm)), qn+qm );
  end function; 
  
end package body common;
