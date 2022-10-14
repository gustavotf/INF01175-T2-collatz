
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;



entity tb_col is

end tb_col;

architecture Behavioral of tb_col is

component col1
port(
start: in std_logic;
  clk: in std_logic;
  rst: in std_logic;
  entradaX: in std_logic_vector(7 downto 0);
  pronto: out std_logic;
  passos_out: out std_logic_vector(7 downto 0);
  t_out: out std_logic_vector(15 downto 0);
  maior_out: out std_logic_vector(15 downto 0)
  
   );
end component;

signal starts: std_logic;
signal clks: std_logic;
signal rsts: std_logic;
signal entradaXs: std_logic_vector(7 downto 0):= "00000011";
signal prontos: std_logic;
signal passos_outs:  std_logic_vector(7 downto 0);
signal  maior_outs:  std_logic_vector(15 downto 0);
signal  t_outs:  std_logic_vector(15 downto 0);


constant clk_period : time := 20ns;



begin

uut: col1 port map(
entradaX => entradaXs,
start => starts,
clk => clks,
rst => rsts,
pronto => prontos,
passos_out => passos_outs,
maior_out => maior_outs,
t_out => t_outs
);

process
begin
clks <= '0';
wait for clk_period/2;
clks <= '1';
wait for clk_period/2;
end process;



-- Stimulus process
   stim_proc: process
   begin       
      wait for 100 ns;   
      rsts <= '1';
      starts <= '0';
      
      wait for clk_period*10;
      rsts <= '0';
      starts <='0';
      
      wait for clk_period*2;
      rsts <= '0';     
      starts <= '1';
 
      
      wait;
   end process;



END;



