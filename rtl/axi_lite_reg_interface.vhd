library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity axi_lite_reg_interface is
    generic (
        REG_WIDTH : integer := 32;
        WRITE_REG_COUNT : integer := 4;
        READ_REG_COUNT: integer := 2
    );
    port (
        -- Clock and Reset
        ACLK     : in  std_logic;
        ARESETn  : in  std_logic;

        -- Write Address Channel
        AWADDR   : in  std_logic_vector(31 downto 0);
        AWVALID  : in  std_logic;
        AWREADY  : out std_logic;

        -- Write Data Channel
        WDATA    : in  std_logic_vector(REG_WIDTH-1 downto 0);
        WSTRB    : in  std_logic_vector((REG_WIDTH/8)-1 downto 0);
        WVALID   : in  std_logic;
        WREADY   : out std_logic;

        -- Write Response Channel
        BVALID   : out std_logic;
        BREADY   : in  std_logic;
        BRESP    : out std_logic_vector(1 downto 0);

        -- Read Address Channel
        ARADDR   : in  std_logic_vector(31 downto 0);
        ARVALID  : in  std_logic;
        ARREADY  : out std_logic;

        -- Read Data Channel
        RDATA    : out std_logic_vector(REG_WIDTH-1 downto 0);
        RVALID   : out std_logic;
        RREADY   : in  std_logic;
        RRESP    : out std_logic_vector(1 downto 0);
        
        -- Signals sent and received to and from the DMA engine
        start : out std_logic;
        irq_enable : out std_logic;
        busy : in std_logic;
        done : in std_logic;
        src_addr : out std_logic_vector(REG_WIDTH-1 downto 0);
        dst_addr : out std_logic_vector(REG_WIDTH-1 downto 0);
        length : out std_logic_vector(REG_WIDTH-1 downto 0)
    );
end entity;

architecture RTL of axi_lite_reg_interface is

    type state_t is (IDLE, WRITE_DATA, WRITE_RESP, READ_DATA);
    type reg_array_t is array(0 to READ_REG_COUNT + WRITE_REG_COUNT-1) of std_logic_vector(REG_WIDTH-1 downto 0);
    
    signal state, state_next : state_t;
    signal reg_space, reg_space_next : reg_array_t;
    signal address_reg, address_next : unsigned(REG_WIDTH-1-2 downto 0); -- divided by 8

begin

    -- register space matching
    start <= reg_space(0)(0);
    irq_enable <= reg_space(0)(1);
    src_addr <= reg_space(1);
    dst_addr <= reg_space(2);
    length <= reg_space(3);
    

    fsm_reg : process(ACLK, ARESETn)
    begin
        if ARESETn = '0' then
            state <= IDLE;
            reg_space <= (others => (others => '0'));
            address_reg <= (others => '0');
        elsif rising_edge(ACLK) then
            state <= state_next;
            reg_space <= reg_space_next;
            address_reg <= address_next;
        end if;
    end process;
    
    fsm_comb : process(all)
    begin
        -- defaults
        state_next <= state;
        address_next <= address_reg;
        AWREADY <= '0';
        WREADY <= '0';
        BVALID <= '0';
        ARREADY <= '0';
        RVALID <= '0';
        BRESP <= "00";
        RRESP <= "00";
        reg_space_next(0 to WRITE_REG_COUNT-1) <= reg_space(0 to WRITE_REG_COUNT-1);
        reg_space_next(0)(0) <= '0'; -- start bit automatically goes to 0
        reg_space_next(WRITE_REG_COUNT to WRITE_REG_COUNT + READ_REG_COUNT - 1) <= (others => (others => '0')); -- default read regs to 0
        reg_space_next(WRITE_REG_COUNT)(1 downto 0) <= done & busy; -- except those ones (buffered)
    
        case state is
            when IDLE => 
                if AWVALID = '1' then -- priority for write, abritrary decision
                    state_next <= WRITE_DATA;
                    AWREADY <= '1';  
                    address_next <= unsigned(AWADDR(REG_WIDTH-1 downto 2)); -- MSb
                elsif ARVALID = '1' then
                    state_next <= READ_DATA;
                    ARREADY <= '1'; 
                    address_next <= unsigned(ARADDR(REG_WIDTH-1 downto 2)); -- MSb
                end if;
                
            when WRITE_DATA =>            
                if WVALID = '1' then
                    wready <= '1'; 
                    
                    if to_integer(address_reg) < WRITE_REG_COUNT then -- make sure address is writable    
                        for i in 0 to REG_WIDTH/8 - 1 loop
                            if WSTRB(i) = '1' then
                                reg_space_next(to_integer(address_reg))(8*i+7 downto 8*i) <= WDATA(8*i+7 downto 8*i);
                            end if;
                        end loop;    
                    end if; 
                    
                    state_next <= WRITE_RESP;               
                    
                end if;
            when WRITE_RESP =>
                BVALID <= '1';
                if not (to_integer(address_reg) < WRITE_REG_COUNT) then
                    BRESP <= "11"; -- index error
                end if;
                
                if BREADY = '1' then
                    state_next <= IDLE;
                end if;
                
            when READ_DATA =>
                
                if to_integer(address_reg) > WRITE_REG_COUNT and to_integer(address_reg) < WRITE_REG_COUNT + READ_REG_COUNT then
                    RDATA <= reg_space(to_integer(address_reg));
                else -- index error
                    RRESP <= "11";
                end if;
            
                if RREADY = '1' then
                    state_next <= IDLE;
                end if;
            when others =>
                state_next <= IDLE;
        end case;
            
    end process;

end architecture;
