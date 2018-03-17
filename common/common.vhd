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

  -- Sincroniza una entrada binaria
  component synchronizer
	  generic (
		 STAGES  : in natural;      -- número de biestables del sincronizador
		 INIT    : in std_logic     -- valor inicial de los biestables
	  );
	  port (
		 rst_n : in  std_logic;   -- reset asíncrono de entrada (a baja)
		 clk   : in  std_logic;   -- reloj del sistema
		 x     : in  std_logic;   -- entrada binaria a sincronizar
		 xSync : out std_logic    -- salida sincronizada que sique a la entrada
	  );
	end component;

	-- Elimina los rebotes de una línea binaria mediante la espera
	-- tras cada flanco detectado
	component debouncer
	  generic(
		 FREQ   : natural;  -- frecuencia de operacion en KHz
		 BOUNCE : natural   -- tiempo de rebote en ms
	  );
	  port (
		 rst_n  : in  std_logic;   -- reset asíncrono del sistema (a baja)
		 clk    : in  std_logic;   -- reloj del sistema
		 x_n    : in  std_logic;   -- entrada binaria a la que deben eliminarse los rebotes (a baja en reposo)
		 xdeb_n : out std_logic    -- salida que sique a la entrada pero sin rebotes
	  );
	end component;

	-- Detecta flancos en una entrada binaria lenta
	component edgeDetector
	  port (
		 rst_n : in  std_logic;   -- reset asíncrono del sistema (a baja)
		 clk   : in  std_logic;   -- reloj del sistema
		 x_n   : in  std_logic;   -- entrada binaria con flancos a detectar (a baja en reposo)
		 xFall : out std_logic;   -- se activa durante 1 ciclo cada vez que detecta un flanco de subida en x
		 xRise : out std_logic    -- se activa durante 1 ciclo cada vez que detecta un flanco de bajada en x
	  );
	end component;

	-- Genera una señal de reloj de cierta frecuencia
	component frequencySynthesizer
	  generic (
		 FREQ     : natural;                 -- frecuencia del reloj de entrada en KHz
		 MODE     : string;                  -- modo del sintetizador de frecuencia "LOW" o "HIGH"
		 MULTIPLY : natural range 2 to 32;   -- factor por el que multiplicar la frecuencia de entrada
		 DIVIDE   : natural range 1 to 32    -- divisor por el que dividir la frecuencia de entrada
	  );
	  port (
		 clkIn  : in  std_logic;   -- reloj de entrada
		 ready  : out std_logic;   -- indica si el reloj de salida es válido
		 clkOut : out std_logic    -- reloj de salida
	  );
	end component;

	-- Conversor elemental de una linea serie PS2 a paralelo con
	-- protocolo de strobe de 1 ciclo
	component ps2Receiver
	  generic (
		  REGOUTPUTS : boolean   -- registra o no las salidas
	  );
	  port (
  		-- host side
  		rst_n      : in  std_logic;   -- reset asíncrono del sistema (a baja)
  		clk        : in  std_logic;   -- reloj del sistema
  		dataRdy    : out std_logic;   -- se activa durante 1 ciclo cada vez que hay un nuevo dato recibido
  		data       : out std_logic_vector (7 downto 0);  -- dato recibido
  		-- PS2 side
  		ps2Clk     : in  std_logic;   -- entrada de reloj del interfaz PS2
  		ps2Data    : in  std_logic    -- entrada de datos serie del interfaz PS2
	  );
	end component;

  -- Buffer de tipo FIFO
  component fifo
    generic (
      WIDTH : natural;   -- anchura de la palabra de fifo
      DEPTH : natural    -- numero de palabras en fifo
    );
    port (
      rst_n   : in  std_logic;   -- reset asíncrono del sistema (a baja)
      clk     : in  std_logic;   -- reloj del sistema
      wrE     : in  std_logic;   -- se activa durante 1 ciclo para escribir un dato en la fifo
      dataIn  : in  std_logic_vector(WIDTH-1 downto 0);   -- dato a escribir
      rdE     : in  std_logic;   -- se activa durante 1 ciclo para leer un dato de la fifo
      dataOut : out std_logic_vector(WIDTH-1 downto 0);   -- dato a leer
      full    : out std_logic;   -- indicador de fifo llena
      empty   : out std_logic    -- indicador de fifo vacia
    );
  end component;

  -- Conversor elemental de una linea serie RS-232 a paralelo con
  -- protocolo de strobe
  component rs232Receiver
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
  end component;

  -- Conversor elemental de paralelo a una linea serie RS-232 con
  -- protocolo de strobe
  component rs232Transmitter
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
