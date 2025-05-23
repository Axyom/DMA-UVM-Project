library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- DMA Controller (Coordinator)
entity dma_controller is
  generic (
    REG_WIDTH : integer := 32;
    BURST_LEN  : integer := 16
  );
  port (
    -- Clock and Reset
    clk      : in  std_logic;
    rst_n   : in  std_logic;
    
    -- AXI4-Lite Register Interface signals (simplified)
    start        : in  std_logic;
    irq_enable   : in  std_logic;
    src_addr     : in  std_logic_vector(REG_WIDTH-1 downto 0);
    dst_addr     : in  std_logic_vector(REG_WIDTH-1 downto 0);
    length       : in  std_logic_vector(31 downto 0);
    
    -- signals reporting state outside of module
    busy         : out std_logic;
    done         : out std_logic; 
    
    -- control signals for axi engines
    start_read   : out std_logic;
    start_write  : out std_logic;
    axi_rd_addr : out std_logic_vector(REG_WIDTH-1 downto 0);
    axi_wr_addr : out std_logic_vector(REG_WIDTH-1 downto 0);
    data_ready : in std_logic;
    write_done : in std_logic
  );
end entity;

architecture rtl of dma_controller is

type state_t is (IDLE, READ, WRITE);

signal state, state_next : state_t;
signal burst_count, burst_count_next, rd_addr, rd_addr_next, wr_addr, wr_addr_next : unsigned(REG_WIDTH-1 downto 0);

begin

    fsm_reg : process(clk, rst_n)
    begin
        if rst_n = '1' then
            state <= IDLE;
            burst_count <= (others => '0');
            rd_addr <= (others => '0');
            wr_addr <= (others => '0');
        elsif rising_edge(clk) then
            state <= state_next;
            burst_count <= burst_count_next;
            rd_addr <= rd_addr_next;
            wr_addr <= wr_addr_next;
        end if;
    end process;
    
    fsm_comb : process(all)
    begin
        -- defaults
        state_next <= state;
        done <= '0';
        busy <= '0';
        start_read <= '1';
        rd_addr_next <= rd_addr;
        wr_addr_next <= wr_addr;
    
        case state is  
            when IDLE =>
                if start = '1' then
                    state_next <= READ;
                    burst_count_next <= unsigned(length);
                    start_read <= '1';
                    busy <= '1';
                    rd_addr_next <= unsigned(src_addr);
                    wr_addr_next <= unsigned(dst_addr);
                end if;
            when READ =>
                busy <= '1';
                if data_ready = '1' then
                    state_next <= WRITE;
                    start_write <= '1';
                end if;
            when WRITE =>
                busy <= '1';
                
                if write_done = '1' then
                    burst_count_next <= burst_count - 1;


                    if to_integer(burst_count) = 1 then -- transfer of one beat completed
                        state_next <= IDLE;
                        done <= '1';
                    else
                        state_next <= READ;
                    end if;
                end if;
            when others =>
                state_next <= IDLE;
        end case;
    end process;
    

end architecture;