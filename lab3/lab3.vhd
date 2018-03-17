---------------------------------------------------------------------
--
--  Fichero:
--    lab3.vhd  15/7/2015
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Laboratorio 3
--
--  Notas de dise�o:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab3 is
port
(
  rstPb_n    : in  std_logic;
  osc        : in  std_logic;
  enter_n    : in  std_logic;
  switches_n : in  std_logic_vector(7 downto 0);
  leds       : out std_logic_vector(7 downto 0);
  upSegs     : out std_logic_vector(7 downto 0)
);
end lab3;

---------------------------------------------------------------------

use work.common.all;

architecture syn of lab3 is

  signal clk, rst_n : std_logic;
  signal ready, rstInit_n : std_logic;

  signal enterSync_n, enterDeb_n, enterFall : std_logic;
  signal switchesSync_n : std_logic_vector(7 downto 0);
  signal ldCode, eq, lock : std_logic;
  signal code : std_logic_vector(7 downto 0);
  signal tries : std_logic_vector(3 downto 0);

begin

  rstInit_n <= rstPb_n and ready;

  resetSyncronizer : synchronizer
    generic map ( STAGES => 2, INIT => '0' )
    port map ( rst_n => rstInit_n, clk => clk, x => '1', xSync => rst_n );

  clkGenerator : frequencySynthesizer
    generic map ( FREQ => 50_000, MODE => "LOW", MULTIPLY => 3, DIVIDE => 5 )
    port map ( clkIn => osc, ready => ready, clkOut => clk );

  ------------------

  enterSynchronizer : synchronizer
    generic map ( STAGES => 2, INIT => '0' )
    port map ( rst_n => rst_n, clk => clk, x => enter_n, xSync => enterSync_n );

  enterDebouncer : debouncer
    generic map ( FREQ => 30_000, BOUNCE => 50 )
    port map ( rst_n => rst_n, clk => clk, x_n => enterSync_n, xdeb_n => enterDeb_n );

  enterEdgeDetector : edgeDetector
    port map ( rst_n => rst_n, clk => clk, x_n => enterDeb_n, xFall => enterFall, xRise => open );

  switchesSynchronizer :
  for i in switches_n'range generate
  begin
    switchsynchronizer : synchronizer
      generic map ( STAGES => 2, INIT => '0' )
      port map ( rst_n => rst_n, clk => clk, x => switches_n(i downto 0), xSync => switchesSync_n(i downto 0) );
  end generate;

  ------------------

  fsm:
  process (rst_n, clk, enterFall)
    type states is (initial, S3, S2, S1, S0);
    variable state: states;
  begin
    if enterFall = HIGH and state = initial then
      ldCode <= '1';
    else
      ldCode <= '0';
    if state = initial then
      lock <= '0';
    else
      lock <= '1';
    end if;
    case state is
      when initial =>
        tries <= "1010"; -- A
		when S3 =>
        tries <= "0011"; -- 3
		when S2 =>
        tries <= "0010"; -- 2
		when S1 =>
        tries <= "0001"; -- 1
		when S0 =>
        tries <= "1100"; -- C
    end case;
    if rst_n='0' then
      state := initial;
    elsif rising_edge(clk) then
      case state is
        when initial =>
          if enterFall = '1' then
            state <= S3;
        when S3 =>
          if enterFall = '1' and eq = '0' then
            state <= S2;
          elsif enterFall = '1' and eq = '1' then
            state <= initial;
        when S2 =>
          if enterFall = '1' and eq = '0' then
            state => S1;
          elsif enterFall = '1' and eq = '1' then
            state <= initial;
        when S1 =>
          if enterFall = '1' and eq = '0' then
            state <= S0;
          elsif enterFall = '1' and eq = '1' then
            state = initial;
      end case;
    end if;
  end process;

  codeRegister :
  process (rst_n, clk)
  begin
    if rst_n='0' then
      code <= (others=>'0');
    elsif rising_edge(clk) then
      code <= switchesSync_n;
  end process;

  comparator:
  eq <= switchesSync_n and code;

  rigthConverter : bin2segs
    port map( bin => tries, dp => NO, segs => upSegs );

  leds <= lock;

end syn;
