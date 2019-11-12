library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_level is
Port (clk, btnu, btnc : in std_logic;
      anode_out : out std_logic_vector(3 downto 0);
      seg_out : out std_logic_vector(7 downto 0));
end top_level;

architecture Behavioral of top_level is

component count_to_9999 is
port (clk, reset, enable, enable_auto_reset : in std_logic;
	  bcd_a, bcd_b, bcd_c, bcd_d : out std_logic_vector (3 downto 0));
end component;

component release_debouncer is
port (clk : in std_logic;
      button_press : in std_logic;
      output : out std_logic);
end component;

component press_debouncer is
Port (clk : in std_logic;
      button_press : in std_logic;
      output : out std_logic);
end component;

component flip_flop is
port (clk, D, R, enable : in std_logic;
      Q : out std_logic);
end component;

component delay_enable is
port (clk, reset, invert : in std_logic;
      delay_value : in natural range 0 to 1000000000;
	  enable : out std_logic);
end component;

component bcd_seven_segment_decoder is
port (input : in std_logic_vector (3 downto 0);
	  enable : in std_logic;
      seg_out : out std_logic_vector (7 downto 0));
end component;

component var_clock_divider is
port (clk : in std_logic;
	  divider : in natural range 0 to 1000000000;
      clk_out : out std_logic);
end component;

component multiplexer_seven_segment_display is
port ( clk : in std_logic;
	   input_1, input_2, input_3, input_4 : in std_logic_vector (7 downto 0);
       seg_out : out std_logic_vector (7 downto 0);
	   anode_out : out std_logic_vector (3 downto 0));
end component;

signal seg_a, seg_b, seg_c, seg_d : std_logic_vector (7 downto 0);

signal bcd_a, bcd_b, bcd_c, bcd_d : std_logic_vector (3 downto 0);

signal enable_if_nine_signal : std_logic;
signal enable_counter, delay_enable_signal, stop_disable : std_logic;
signal clk_div_out : std_logic;

signal stop_pb_signal, reset_pb_signal : std_logic;

begin

enable_counter <= '1' when delay_enable_signal = '1' and stop_disable = '0' else
                  '0';

stop_deb: press_debouncer port map (clk => clk,
                                    button_press => btnc,
                                    output => stop_pb_signal);
reset_deb: release_debouncer port map (clk => clk,
                                       button_press => btnu,
                                       output => reset_pb_signal);  

clk_div: var_clock_divider port map (clk => clk,
                                     divider => 50000,
                                     clk_out => clk_div_out);

counter: count_to_9999 port map (clk => clk_div_out,
                                 reset => btnu,
                                 enable => enable_counter,
                                 enable_auto_reset => '0',
                                 bcd_a => bcd_a,
                                 bcd_b => bcd_b,
                                 bcd_c => bcd_c,
                                 bcd_d => bcd_d);
                                
   
delay_circuit: delay_enable port map (clk => clk,
                                       reset => btnu,
                                       invert => '0',
                                       delay_value => 200000000,
                                       enable => delay_enable_signal);
                                       

stop_pb: flip_flop port map (clk => clk, 
                             D => '1',
                             enable => stop_pb_signal, 
                             R => reset_pb_signal,
                             Q => stop_disable);                
  
                            
seg_dec_a: bcd_seven_segment_decoder port map (input => bcd_a,
                                               enable => '1',
                                               seg_out => seg_a);
seg_dec_b: bcd_seven_segment_decoder port map (input => bcd_b,
                                               enable => '1',
                                               seg_out => seg_b);  
seg_dec_c: bcd_seven_segment_decoder port map (input => bcd_c,
                                               enable => '1',
                                               seg_out => seg_c);
seg_dec_d: bcd_seven_segment_decoder port map (input => bcd_d,
                                               enable => '1',
                                               seg_out => seg_d);   
                                                                                           
M1: multiplexer_seven_segment_display port map (clk => clk,
                                                input_1 => seg_d,
                                                input_2 => seg_c,
                                                input_3 => seg_b, 
                                                input_4 => seg_a,
                                                seg_out => seg_out,
                                                anode_out => anode_out);                          

end Behavioral;
