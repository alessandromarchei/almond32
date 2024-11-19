library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SHIFTER_Testbench is
end SHIFTER_Testbench;

architecture Testbench of SHIFTER_Testbench is
  signal input_data : std_logic_vector(31 downto 0);
  signal R_tb : std_logic_vector(4 downto 0);
  signal conf_tb : std_logic_vector(1 downto 0);
  signal out_data:  std_logic_vector(31 downto 0);
   --signal o0,o1,o2,o3,o4,o5,o6,o7 :std_logic_vector(31 downto 0);

component SHIFTER is

  port (
    data_in     : in std_logic_vector(31 downto 0);  -- Input data to be shifted
    R           : in std_logic_vector(4 downto 0);      
    conf        : in std_logic_vector(1 downto 0);       
    data_out    : out std_logic_vector(31 downto 0) -- Shifted output data
  );
end component;


begin
  -- Instantiate the SHIFTER entity
  UUT: SHIFTER
    port map (
    data_in => input_data,
    R => R_tb,
    conf => conf_tb,
    data_out => out_data
    );

  -- Stimulus generation
  process
  begin

    wait for 10 ns;

    
    input_data <= "10001000100010001000100010001111"; 
    R_tb <= "01010";
    conf_tb <= "10"; -- Arith right shift
    wait for 20 ns;

    input_data <= "00000000000010000000100000001111"; -- Initial data
    R_tb <= "01010"; --Shift by 10
    conf_tb <= "00"; -- Logical left shift
    wait for 20 ns;

    input_data <= "00000000000000010000000000000000"; -- Initial data
    R_tb <= "00000"; -- Shift by 0
    conf_tb <= "00"; -- Logical left shift
    wait for 10 ns;

    input_data <= "00000000000000010000000000000000"; -- Initial data
    R_tb <= "01000"; -- Shift by 8
    conf_tb <= "00"; -- Logical left shift
    wait for 10 ns;

    input_data <= "00000000000000010000000000000000"; -- Initial data
    R_tb <= "00011"; -- Shift by 3
    conf_tb <= "00"; -- Logical left shift
    wait for 10 ns;


    -- Test logical left shift by 3
    input_data <= "00000000000000010000000000000000"; -- Initial data
    R_tb <= "00011"; -- Shift by 3
    conf_tb <= "00"; -- Logical left shift
    wait for 10 ns;

    -- Test logical left shift by 10
    input_data <= "00000000000000010000000000000000"; -- Initial data
    R_tb <= "01010"; -- Shift by 10
    conf_tb <= "00"; -- Logical left shift
    wait for 10 ns;

    -- Test logical right shift by 4
    input_data <= "00000000000000010000000000000000"; -- Initial data
    R_tb <= "00100"; -- Shift by 4
    conf_tb <= "01"; -- Logical right shift
    wait for 10 ns;

     -- Test logical right shift by 9
    input_data <= "00000000000000010000000000000000"; -- Initial data
    R_tb <= "01001"; -- Shift by 9
    conf_tb <= "01"; -- Logical right shift
    wait for 10 ns;

     -- Test arith right shift by 5 (MSB = 0)
    input_data <= "00000000000000010000000000000000"; -- Initial data
    R_tb <= "00101"; -- Shift by 5
    conf_tb <= "10"; -- Arithmentical right shift
    wait for 10 ns;

     -- Test arith right shift by 17 (MSB = 1)
    input_data <= "10000001000000100000000000000000"; -- Initial data
    R_tb <= "10001"; -- Shift by 17
    conf_tb <= "10"; -- Arithmentical right shift
    wait for 10 ns;

    -- Test arith right shift by 24 (MSB = 1)
    input_data <= "10001000000000100000000000000000"; -- Initial data
    R_tb <= "11000"; -- Shift by 24
    conf_tb <= "10"; -- Arithmentical right shift
    wait for 10 ns;


    -- Add more test cases here

    wait;
  end process;

end Testbench;
