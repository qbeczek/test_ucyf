-- 2_top_encoding_lab7 [us.vhd] ASM_4

library ieee;
use ieee.std_logic_1164.all;

entity us is
	port(
		rst			: in std_logic;
		clk			: in std_logic;
		start, load	: in std_logic;	
		cnt_done	: in std_logic;		
		cnt_reset	: out std_logic;					
		cnt_count	: out std_logic;					
		x_load		: out std_logic;					
		x_update	: out std_logic;					
		result_load	: out std_logic;					
		ready		: out std_logic					
	);
end us;
architecture asm of us is
	-- Stany automatu i sygnaly rejestru stanow
	constant s0 : std_logic_vector (4 downto 0) := "00000";
	constant s1 : std_logic_vector (4 downto 0) := "00001";
	constant s2 : std_logic_vector (4 downto 0) := "00011";
	constant s3 : std_logic_vector (4 downto 0) := "00111";
	constant s4 : std_logic_vector (4 downto 0) := "01111";
	constant s5 : std_logic_vector (4 downto 0) := "11111";
	constant s6 : std_logic_vector (4 downto 0) := "10000";
	constant s7 : std_logic_vector (4 downto 0) := "11000";
	
	-- type STATE_TYPE is (s0, s1, s2, s3, s4, s5, s6, s7);
	signal state_reg, state_next	: std_logic_vector( 4 downto 0);
	signal ready_reg, ready_next	: std_logic;
	
begin
	-- Rejestr stanu automatu i sygnalu ready
	process(rst, clk)
	begin
		if rst = '1' then 
		state_reg 	<= s0;
		ready_reg 	<= '0';
	elsif rising_edge(clk) then
		state_reg 	<= state_next;
		ready_reg 	<= ready_next;
	end if;	
	end process;

-- Funkcja przej��-wyj�� automatu ASM_4

process(state_reg, start, load, cnt_done)
	
	begin
		cnt_reset	<= '0';					
		cnt_count	<= '0';					
		x_load	    <= '0';					
		x_update	<= '0';					
		result_load	<= '0';
		ready_next  <= '0';
		
	when s0 =>
		if load = '1' then
			state_next <= s1;
		else 
			state_next <= s0;
		end if;
	
	when s1 =>
		x_load <= '1';
		state_next <= s2;
	
	when s2 =>
		if start = '1' then
			state_next <= s3;
		else 
			state_next <= s2;
		end if;
	
	when s3 =>
		cnt_reset <= '1';
		state_next <= s4;
	
	when s4 =>
		x_update <= '1';
		state_next <= s5;
	
	when s5 => 
		if cnt_done = '1' then
			state_next <= s7;
		else 
			state_next <= s6;
		end if;
		
	when s6 =>
		cnt_count <= '1';
		state_next <= s4;
	
	when s7 =>
		result_load <= '1';
		ready_next <= '1';
		if load = '1' then
			state_next <= s2;
		else
			state_next <= s7;
		end if;
		
	end case;
end process;	
	ready <= ready_reg;
end;



