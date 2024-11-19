library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


 -- T2 SHIFTER implemented in 32 bits, where the masks generated are M8R,M16R,M24R,M0,M8L,M16L,M24L

 -- conf : "00" = LEFT LOGICAL, "01" = RIGHT LOGICAL, "10" = RIGHT ARITHMETIC
 
entity SHIFTER is

  port (
    data_in     : in std_logic_vector(31 downto 0);  -- Input data to be shifted
    R           : in std_logic_vector(4 downto 0);      
    conf        : in std_logic_vector(1 downto 0);       
    data_out    : out std_logic_vector(31 downto 0) -- Shifted output data
  );
end SHIFTER;


architecture Behavioral of SHIFTER is

    type masks is array (0 to 3) of std_logic_vector(39 downto 0);     -- PRE-GENERATED MASKS, DEPENDING ON THE CONFIG
    signal mask : masks;
    signal out_mask : std_logic_vector(39 downto 0);    -- SELECTED MASK FROM THE 2ND PHASE
    signal coarse_sel : std_logic_vector(1 downto 0);
    signal fine_sel : std_logic_vector(2 downto 0);


    begin
    coarse_sel <= R(4 downto 3);
    fine_sel <= R(2 downto 0);

    --STAGE 1 WHERE THE MASKS ARE GENERATED BASED ON THE 'conf' SIGNALS RECEIVED AS INPUT
    mask_gen : process(conf,data_in)

    begin
        case conf is
            --LOGIC LEFT
            when "00" => mask(0) <= data_in & "00000000";
            mask(1) <= data_in(23 downto 0) & "0000000000000000";                   --M8LL
            mask(2) <= data_in(15 downto 0) & "000000000000000000000000";           --M16LL
            mask(3) <= data_in(7 downto 0) & "00000000000000000000000000000000";       --M24LL
            
            --LOGIC RIGHT
            when "01" => mask(0) <= "00000000" & data_in;
            mask(1) <= "0000000000000000" & data_in(31 downto 8);                   --M8RL
            mask(2) <= "000000000000000000000000" & data_in(31 downto 16);           --M16RL
            mask(3) <= "00000000000000000000000000000000" & data_in(31 downto 24);    --M24RL

            --ARITHMETIC RIGHT
            when "10" => if data_in(31) = '1' then
                        mask(0) <= "11111111" & data_in;
                        mask(1) <= "1111111111111111" & data_in(31 downto 8);                   --M8RL
                        mask(2) <= "111111111111111111111111" & data_in(31 downto 16);           --M16RL
                        mask(3) <= "11111111111111111111111111111111" & data_in(31 downto 24);    --M24RL

                        else mask(0) <= "00000000" & data_in;
                        mask(1) <= "0000000000000000" & data_in(31 downto 8);                   --M8RL
                        mask(2) <= "000000000000000000000000" & data_in(31 downto 16);           --M16RL
                        mask(3) <= "00000000000000000000000000000000" & data_in(31 downto 24);    --M24RL
                        end if;
            
            when others => --do nothing
        end case;
    end process mask_gen;

    --STAGE 2 WHERE THE RIGHT MASK IS CHOSEN
    coarse_grained : process(conf,fine_sel,coarse_sel,mask)
    begin
        case coarse_sel is
            when "00" => out_mask <= mask(0);
            when "01" => out_mask <= mask(1);
            when "10" => out_mask <= mask(2);
            when "11" => out_mask <= mask(3);
            when others => --do nothing
        end case;
    end process;
    
    --STAGE 3 WHERE A FINE GRAINED SELECTION OCCURS
    --AFTER THE GENERATION AND SELECTION OF THE PROPER MASK, IN THIS LAST PART WE SELECT THE PROPER SHIFT AMOUNT
    --BY LOOKING AT THE LEAST SIGNIFICANT PART OF THE 2ND OPERAND
    fine_grained : process(conf, fine_sel, out_mask,coarse_sel)
    begin
        if (conf = "00")then --SHIFT LEFT
             case fine_sel is

                when "000" => data_out <= out_mask(39 downto 8);
            
                when "001" => data_out <= out_mask(38 downto 7);
            
                when "010" => data_out <= out_mask(37 downto 6);
            
                when "011" => data_out <= out_mask(36 downto 5);
            
                when "100" => data_out <= out_mask(35 downto 4);
            
                when "101" => data_out <= out_mask(34 downto 3);
            
                when "110" => data_out <= out_mask(33 downto 2);
            
                when "111" => data_out <= out_mask(32 downto 1);
            
                when others => --do nothing
            end case;
        
        else  --SHIFT RIGHT
            case fine_sel is

                when "000" => data_out <= out_mask(31 downto 0);
        
                when "001" => data_out <= out_mask(32 downto 1);
        
                when "010" => data_out <= out_mask(33 downto 2);
        
                when "011" => data_out <= out_mask(34 downto 3);
        
                when "100" => data_out <= out_mask(35 downto 4);
        
                when "101" => data_out <= out_mask(36 downto 5);
        
                when "110" => data_out <= out_mask(37 downto 6);
        
                when "111" => data_out <= out_mask(38 downto 7);
        
                when others => --do nothing
            end case;
        end if;
                
    end process;
end Behavioral;
