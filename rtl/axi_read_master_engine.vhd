library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

-- AXI Read Master Engine
entity axi_read_master_engine is
  generic (
    REG_WIDTH : integer := 32;
    BURST_LEN  : integer := 16
  );
  port (
    -- Clock and Reset
    ACLK      : in  std_logic;
    ARESETN   : in  std_logic;
    
    -- Control
    start         : in  std_logic;
    read_addr     : in  std_logic_vector(REG_WIDTH-1 downto 0);
    read_length   : in  std_logic_vector(7 downto 0); -- length in beats
    
    -- AXI4 Read Address Channel
    M_AXI_ARADDR  : out std_logic_vector(REG_WIDTH-1 downto 0);
    M_AXI_ARLEN   : out std_logic_vector(7 downto 0);
    M_AXI_ARSIZE  : out std_logic_vector(2 downto 0);
    M_AXI_ARBURST : out std_logic_vector(1 downto 0);
    M_AXI_ARVALID : out std_logic;
    M_AXI_ARREADY : in  std_logic;
    
    -- AXI4 Read Data Channel
    M_AXI_RDATA   : in  std_logic_vector(REG_WIDTH-1 downto 0);
    M_AXI_RRESP   : in  std_logic_vector(1 downto 0);
    M_AXI_RLAST   : in  std_logic;
    M_AXI_RVALID  : in  std_logic;
    M_AXI_RREADY  : out std_logic;
    
    -- Data output interface (custom internal protocol)
    data_out      : out std_logic_vector(REG_WIDTH-1 downto 0);
    data_valid    : out std_logic;
    receive_data_ready    : in  std_logic;
    
    -- Status
    busy          : out std_logic;
    done          : out std_logic
    --error         : out std_logic
  );
end entity;

architecture rtl of axi_read_master_engine is

    type State_t is (IDLE, SEND_ADDR, RECEIVE_DATA);
    signal state, state_next : State_t;

    signal addr, addr_next : std_logic_vector(REG_WIDTH-1 downto 0);
    signal burst_count, burst_count_next : std_logic_vector(7 downto 0);

begin
    M_AXI_ARSIZE <= std_logic_vector( to_unsigned(integer(ceil(log2(real(REG_WIDTH/8)))), 3) );
    M_AXI_ARBURST <= "01"; -- incremental burst always
    data_out <= M_AXI_RDATA;

    fsm_reg : process (ACLK, ARESETN)
    begin
        if ARESETN = '0' then
            state <= IDLE;
            burst_count <= (others => '0');
            addr <= (others => '0');
        elsif rising_edge(ACLK) then
            state <= state_next;
            burst_count <= burst_count_next;
            addr <= addr_next;
        end if;
    end process;

    fsm_comb : process (all)
    begin
        -- defaults
        state_next <= state;
        burst_count_next <= burst_count;
        addr_next <= addr;
        busy <= '0';
        done <= '0';
        M_AXI_ARADDR <= (others => '0');
        M_AXI_ARLEN <= (others => '0');
        M_AXI_ARVALID <= '0';
        M_AXI_RREADY <= '0';
        data_valid <= '0';

        case state is
            when IDLE =>
                if start = '1' then
                    state_next <= SEND_ADDR;
                    burst_count_next <= read_length;
                    addr_next <= read_addr;
                end if;
            when SEND_ADDR =>
                busy <= '1';

                M_AXI_ARADDR <= addr;
                M_AXI_ARLEN <= burst_count;
                M_AXI_ARVALID <= '1';
                
                if M_AXI_ARREADY = '1' then
                    state_next <= RECEIVE_DATA;
                end if;

            when RECEIVE_DATA =>
                busy <= '1';

                M_AXI_RREADY <= receive_data_ready;
                data_valid <= M_AXI_RVALID;

                if M_AXI_RLAST = '1' and receive_data_ready = '1' then
                    state_next <= IDLE;
                    done <= '1';
                end if;
                
            when others =>
                state_next <= IDLE;
        end case;
    end process;

end architecture;
