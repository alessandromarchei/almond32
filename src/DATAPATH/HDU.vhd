library IEEE;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


-- Hazard Detection Unit: in charge of detection and correction of RAW hazards and Control hazards

--THIS MODULE IS SIMILAR TO THE FORWARDING DETECTION UNIT (FWDU). IT CHECKS COMMONALITIES AMONG SOURCE AND DESTINATION REGISTERS
--OF THE INSTRUCTIONS THAT ARE CURRENTLY WITHIN THE PIPELINE STAGES.

--MOREOVER, THE UNIT IS CAPABLE OF GENERATING STALLS OF THE PIPELINE WHEN RAW HAZARDS OCCUR (EXAMPLE LD INSTRUCTION FOLLOWED BY AN ADDITION
--THAT USES THE OPERAND FROM THE MEMORY)

--IN MULTICYCLE OPERATIONS SUCH AS MULTIPLICATION, IT STALLS THE PIPELINE UNTIL THE RESULT IS PRODUCED, AFTER 4 CLOCK CYCLES.
entity HDU is
generic(IR_SIZE: integer:=32);
    port (
      clk   : in std_logic;      
      rst   : in std_logic;
      IR : in std_logic_vector(31 downto 0);      -- address contained by the PC
      STALL_CODE: out std_logic_vector(1 downto 0);
      IF_STALL, ID_STALL, EX_STALL, MEM_STALL, WB_STALL:    out std_logic -- stall signals
    );

end HDU;

architecture behavioural of HDU is

constant latency_mul : integer := 3;
signal STALL_RAW, STALL_MUL: std_logic := '0'; 
signal IR_EX: std_logic_vector(IR_SIZE-1 downto 0);    --used to store the previous instruction wrt the current one
signal DESTINATION_DEC, DESTINATION_EX: integer := 0;     --used to be compared to the 2 operands
signal IR_OP1I, IR_OP1R, IR_OP2R, IR_EX_OP1I, IR_EX_OP1R, IR_EX_OP2R : integer := 0 ;
signal OP_DEC, OP_EX: std_logic_vector(5 downto 0);
signal cnt_raw : integer := 1;
signal cnt_mul : integer := latency_mul;
     
begin

INS_PIPE: process (Clk, Rst)
begin  -- process Clk
  if Rst = '1' then                   -- asynchronous reset (active high)
    IR_EX <= (others => '0');
    
  elsif Clk'event and Clk = '1' then  -- rising clock edge
    if (STALL_MUL) = '0' then
      IR_EX <= IR;
    end if;

  end if;
end process INS_PIPE;

-- RAW hazard: dest. reg of old ins. = source reg. of new ins. Since we are using forwarding,
-- the only case in which we should stall is when an instruction needs a register which is
-- loaded by a previous instruction

-- WAR hazard: doesn't happen without multicycle ops

-- WAW hazard: doesn't happen without multicycle ops

DESTINATION_EX <= conv_integer(unsigned(IR_EX(15 downto 11))) when IR_EX(31 downto 26) = "000000" else
    conv_integer(unsigned(IR_EX(20 downto 16)));

IR_OP1I <= conv_integer(unsigned(IR(25 downto 21))); --OPERAND OF INSTRUCTION I-TYPE IN DECODE STAGE
IR_OP1R <= conv_integer(unsigned(IR(25 downto 21))); --1st OPERAND OF INSTRUCTION R-TYPE IN DECODE STAGE
IR_OP2R <= conv_integer(unsigned(IR(20 downto 16))); --2nd OPERAND OF INSTRUCTION R-TYPE IN DECODE STAGE
OP_DEC <= IR(31 downto 26);
OP_EX <= IR_EX(31 downto 26);

INS_CMP: process(IR_EX)

begin

-- Compare the instruction in the mem stage with the instruction in the decode
case OP_EX is
    when "100000" => -- i type: lb
      case OP_DEC is
        when "000000" => if (DESTINATION_EX = IR_OP1R) or (DESTINATION_EX = IR_OP2R) then STALL_RAW <= '1'; 
                         else STALL_RAW <= '0';
                         end if;
        when "000010" => STALL_RAW <= '0'; -- j type 
        when "000011" => STALL_RAW <= '0'; -- j type
        when "000100" => STALL_RAW <= '0'; -- j type
        when "000101" => STALL_RAW <= '0'; -- j type    
        when "010010" => STALL_RAW <= '0'; -- j type     
        when "010011" => STALL_RAW <= '0'; -- j type
        when "010101" => STALL_RAW <= '0'; -- NOP
        when "000001" => STALL_RAW <= '0'; -- Mult., managed by stall_mul
        when others =>  if (DESTINATION_EX = IR_OP1I) then STALL_RAW <= '1';
                        else STALL_RAW <= '0';
                        end if;
	    end case;  

    when "100001" => -- i type: lh
      case OP_DEC is
        when "000000" => if (DESTINATION_EX = IR_OP1R) or (DESTINATION_EX = IR_OP2R) then STALL_RAW <= '1'; 
                         else STALL_RAW <= '0';
                         end if;
        when "000010" => STALL_RAW <= '0'; -- j type 
        when "000011" => STALL_RAW <= '0'; -- j type
        when "000100" => STALL_RAW <= '0'; -- j type
        when "000101" => STALL_RAW <= '0'; -- j type    
        when "010010" => STALL_RAW <= '0'; -- j type     
        when "010011" => STALL_RAW <= '0'; -- j type
        when "010101" => STALL_RAW <= '0'; -- NOP
        when "000001" => STALL_RAW <= '0'; -- Mult., managed by stall_mul
        when others =>  if (DESTINATION_EX = IR_OP1I) then STALL_RAW <= '1';
                        else STALL_RAW <= '0';
                        end if;
	    end case;  
    
    when "100011" => -- i type: lw
      case OP_DEC is
        when "000000" => if (DESTINATION_EX = IR_OP1R) or (DESTINATION_EX = IR_OP2R) then STALL_RAW <= '1'; 
                         else STALL_RAW <= '0';
                         end if;
        when "000010" => STALL_RAW <= '0'; -- j type 
        when "000011" => STALL_RAW <= '0'; -- j type
        when "000100" => STALL_RAW <= '0'; -- j type
        when "000101" => STALL_RAW <= '0'; -- j type    
        when "010010" => STALL_RAW <= '0'; -- j type     
        when "010011" => STALL_RAW <= '0'; -- j type
        when "010101" => STALL_RAW <= '0'; -- NOP
        when "000001" => STALL_RAW <= '0'; -- Mult., managed by stall_mul
        when others =>  if (DESTINATION_EX = IR_OP1I) then STALL_RAW <= '1';
                        else STALL_RAW <= '0';
                        end if;
	    end case; 
    
    when "100100" => -- i type: lbu
      case OP_DEC is
        when "000000" => if (DESTINATION_EX = IR_OP1R) or (DESTINATION_EX = IR_OP2R) then STALL_RAW <= '1'; 
                         else STALL_RAW <= '0';
                         end if;
        when "000010" => STALL_RAW <= '0'; -- j type 
        when "000011" => STALL_RAW <= '0'; -- j type
        when "000100" => STALL_RAW <= '0'; -- j type
        when "000101" => STALL_RAW <= '0'; -- j type    
        when "010010" => STALL_RAW <= '0'; -- j type     
        when "010011" => STALL_RAW <= '0'; -- j type
        when "010101" => STALL_RAW <= '0'; -- NOP
        when "000001" => STALL_RAW <= '0'; -- Mult., managed by stall_mul
        when others =>  if (DESTINATION_EX = IR_OP1I) then STALL_RAW <= '1';
                        else STALL_RAW <= '0';
                        end if;
	    end case; 

    when "100101" => -- i type: lhu
      case OP_DEC is
        when "000000" => if (DESTINATION_EX = IR_OP1R) or (DESTINATION_EX = IR_OP2R) then STALL_RAW <= '1'; 
                         else STALL_RAW <= '0';
                         end if;
        when "000010" => STALL_RAW <= '0'; -- j type 
        when "000011" => STALL_RAW <= '0'; -- j type
        when "000100" => STALL_RAW <= '0'; -- j type
        when "000101" => STALL_RAW <= '0'; -- j type    
        when "010010" => STALL_RAW <= '0'; -- j type     
        when "010011" => STALL_RAW <= '0'; -- j type
        when "010101" => STALL_RAW <= '0'; -- NOP
        when "000001" => STALL_RAW <= '0'; -- Mult., managed by stall_mul
        when others =>  if (DESTINATION_EX = IR_OP1I) then STALL_RAW <= '1';
                        else STALL_RAW <= '0';
                        end if;
	    end case; 
    when others => STALL_RAW <= '0'; 
end case;  

end process;

MULT: process(clk)

begin
  if (clk='1' and clk'event) then
   if (OP_DEC = "000001" and IR(10 downto 0) = "00000001110") then --MULT
      cnt_mul <= cnt_mul - 1;
      STALL_MUL <= '1';
    elsif STALL_MUL = '1' then
      if (cnt_mul > 0) then
        cnt_mul <= cnt_mul - 1;
        STALL_MUL <= '1';
      else
        cnt_mul <= latency_mul;
        STALL_MUL <= '0';
      end if;
    end if;
  end if;
end process;

IF_STALL <= STALL_RAW or STALL_MUL;
ID_STALL <= STALL_RAW or STALL_MUL;
EX_STALL <= STALL_MUL;
MEM_STALL <= STALL_MUL;
WB_STALL <= STALL_MUL;

STALL_CODE <= "01" when STALL_RAW = '1' else
              "10" when STALL_MUL = '1' else
              "00";

end behavioural;