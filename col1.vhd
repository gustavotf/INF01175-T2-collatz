
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity col1 is
  Port (
  start: in std_logic;
  clk: in std_logic;
  rst: in std_logic;
  entradaX: in std_logic_vector(7 downto 0);
  pronto: out std_logic;
  t_out: out std_logic_vector(15 downto 0);
  acc_out: out std_logic_vector(15 downto 0);
  passos_out: out std_logic_vector(7 downto 0);
  maior_out: out std_logic_vector(15 downto 0)
  
   );
end col1;

architecture Behavioral of col1 is


signal LD_T: std_logic;
signal SHR_T: std_logic;
signal LD_ACC_T: std_logic;
signal LD_MAIOR: std_logic;
signal INC_P: std_logic;


signal  regT: std_logic_vector(15 downto 0);
signal  regACC: std_logic_vector(15 downto 0);
signal  regMAIOR: std_logic_vector(15 downto 0);
signal regPassos: std_logic_vector(7 downto 0);



type t_estado is (s0, s1, s2, s3, s4, s5, sf);
signal estado, prox_estado: t_estado;

begin

--OPERATIVA
--regT
process(clk, LD_T, SHR_T, rst, LD_ACC_T)
begin
    if(rising_edge(clk)) then
    
    if(rst = '1') then
        regT <= "0000000000000000";
    end if;
    
    if (LD_T = '1') then
        regT(7 downto 0) <= entradaX;
    end if;
    
    if (LD_ACC_T = '1') then
        regT <= std_logic_vector(unsigned(regT) +unsigned(regT)+ unsigned(regT) + 1 );
    end if;

    if (SHR_T = '1') then
        regT(14 downto 0) <= regT(15 downto 1);
        regT(15) <= '0';
     end if;
     
     
     end if; 
end process;


--regPassos
process(clk, INC_P, rst)
begin
    if(rising_edge(clk)) then
    
    if(rst = '1') then
        regPassos <= "00000000";
    end if;
    
    if(INC_P = '1') then
        regPassos <= regPassos + '1';
    end if;
    
    end if;
end process;

--regMAIOR
process(clk, LD_MAIOR, rst)
begin
    if (rising_edge(clk)) then
    
    if(rst = '1') then
        regMAIOR <= "0000000000000000";
    end if;
    if(LD_MAIOR = '1') then
        regMAIOR <= regT;
    end if;
    
    
    end if;
end process;
    

--regACC <= std_logic_vector(unsigned(regT) +unsigned(regT)+ unsigned(regT) + 1 );


--CONTROLE
process (clk,rst)
begin   
        
    if(rst = '1') then
        estado <= s0;
    elsif (rising_edge(clk)) then
        estado <= prox_estado;
    end if;
end process;
     
process(estado, start)
begin
            
            case estado is
                when s0 =>
                    pronto <= '0';
                    
                    LD_T <= '0';
                    SHR_T <= '0';
                    LD_ACC_T <= '0';
                    LD_MAIOR <= '0';
                    INC_P <= '0';

                    if (start = '1') then
                        prox_estado <= s1;
                        
                     else 
                        prox_estado <= s0;
                     end if;
                
                when s1 =>
                    pronto <= '0';
                
                    LD_T <= '1';
                    SHR_T <= '0';                    
                    LD_ACC_T <= '0';
                    LD_MAIOR <= '0';
                    INC_P <= '0';
                    
                    prox_estado <= s2;
                
                when s2 =>
                    
                    pronto <= '0';
                
                    LD_T <= '0';
                    SHR_T <= '0';                    
                    LD_ACC_T <= '0';
                    LD_MAIOR <= '0';
                    INC_P <= '0';
                    
                    if(regMAIOR < regT) then
                    LD_MAIOR <= '1';
                    end if;
                   
                    if(regT = "0000000000000001") then
                    prox_estado <= sf;
                    
                    elsif(regT(0)= '0') then --  eh divisivel por 2
                     
                     prox_estado <= s3;
                     elsif(regT(0) = '1') then
                     prox_estado <= s4;
                     
                     end if;
                    
                when s3 =>
                    
                    LD_T <= '0';                    
                    SHR_T <= '1';
                    LD_ACC_T <= '0';
                    LD_MAIOR <= '0';                                        
                    INC_P <= '1';                    

                    pronto <= '0';

                     if(regMAIOR < regT) then
                     
                     prox_estado <= s5;
                     
                     else
                        prox_estado <= s2;
                     
                     end if;

                when s4 =>
                    
                    LD_T <= '0';
                    SHR_T <= '0';
                    LD_ACC_T <= '1'; 
                    LD_MAIOR <= '0';                   
                    INC_P <= '1';                

                    if(regMAIOR < regT) then
                     
                     prox_estado <= s5;
                     
                     else
                        prox_estado <= s2;
                     end if;
                
               
                
                when s5 =>
            
                    LD_MAIOR <= '1';
                    LD_ACC_T <= '0';
                    LD_T <= '0';
                    INC_P <= '0';
                    SHR_T <= '0';
                  

                    prox_estado <= s2;
                  
                when sf =>
                    pronto <= '1';

        end case;
     end process;

maior_out <= regMAIOR;
passos_out <= regPassos;
t_out <= regT;
acc_out <= regACC;

end Behavioral;