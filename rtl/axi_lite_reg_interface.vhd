library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity axi_lite_reg_interface is
    generic (
        REG_WIDTH : integer := 32;
        REG_COUNT : integer := 4
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

        -- Read Address Channel
        ARADDR   : in  std_logic_vector(31 downto 0);
        ARVALID  : in  std_logic;
        ARREADY  : out std_logic;

        -- Read Data Channel
        RDATA    : out std_logic_vector(REG_WIDTH-1 downto 0);
        RVALID   : out std_logic;
        RREADY   : in  std_logic
    );
end entity;

architecture RTL of axi_lite_reg_interface is

    type state_t is (IDLE, WRITE_ADDR, WRITE_DATA, WRITE_RESP, READ_ADDR, READ_DATA);
    signal state_reg, state_next : state_t;

    signal reg_file : array(0 to REG_COUNT-1) of std_logic_vector(REG_WIDTH-1 downto 0);
    signal addr_idx_reg, addr_idx_next : integer range 0 to REG_COUNT-1;
    signal rdata_reg, rdata_next : std_logic_vector(REG_WIDTH-1 downto 0);

    signal awready_i, wready_i, bvalid_i, arready_i, rvalid_i : std_logic;
    signal rdata_i : std_logic_vector(REG_WIDTH-1 downto 0);

begin
    -- Register mappings
    start            <= reg_file(0)(0);       -- CONTROL bit 0 : START
    irq_enable       <= reg_file(0)(1);       -- CONTROL bit 1 : IRQ_ENABLE
    reg_file(1)(0)   <= busy;                 -- STATUS bit 0 : BUSY
    reg_file(1)(1)   <= done;                 -- STATUS bit 1 : DONE
    src_addr         <= reg_file(2);          -- SRC_ADDR full 32 bits
    dst_addr         <= reg_file(3);          -- DST_ADDR full 32 bits
    length           <= reg_file(4);          -- LENGTH full 32 bits

    -- Output assignments
    AWREADY <= awready_i;
    WREADY  <= wready_i;
    BVALID  <= bvalid_i;
    ARREADY <= arready_i;
    RVALID  <= rvalid_i;
    RDATA   <= rdata_reg;

    -- Sequential process: registers
    process (ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETn = '0' then
                state_reg     <= IDLE;
                addr_idx_reg  <= 0;
                rdata_reg     <= (others => '0');
            else
                state_reg     <= state_next;
                addr_idx_reg  <= addr_idx_next;
                rdata_reg     <= rdata_next;
            end if;
        end if;
    end process;

    -- Combinatorial process: next state and outputs
    process (state_reg, AWVALID, AWADDR, WVALID, WDATA, WSTRB, BREADY,
             ARVALID, ARADDR, RREADY, reg_file, addr_idx_reg)
        variable reg_tmp : std_logic_vector(REG_WIDTH-1 downto 0);
        variable reg_file_next : array(0 to REG_COUNT-1) of std_logic_vector(REG_WIDTH-1 downto 0) := reg_file;
        variable idx : integer;
    begin
        -- Default values
        state_next   <= state_reg;
        addr_idx_next <= addr_idx_reg;
        rdata_next   <= rdata_reg;

        awready_i <= '0';
        wready_i  <= '0';
        bvalid_i  <= '0';
        arready_i <= '0';
        rvalid_i  <= '0';

        case state_reg is

            when IDLE =>
                if AWVALID = '1' then
                    awready_i <= '1';
                    idx := to_integer(unsigned(AWADDR(3 + integer(log2(real(REG_COUNT))) - 1 downto 2)));
                    addr_idx_next <= idx;
                    state_next <= WRITE_ADDR;
                elsif ARVALID = '1' then
                    arready_i <= '1';
                    idx := to_integer(unsigned(ARADDR(3 + integer(log2(real(REG_COUNT))) - 1 downto 2)));
                    addr_idx_next <= idx;
                    state_next <= READ_ADDR;
                end if;

            when WRITE_ADDR =>
                awready_i <= '0';
                wready_i <= '1';
                if WVALID = '1' then
                    for i in 0 to (REG_WIDTH/8 - 1) loop
                        if WSTRB(i) = '1' then
                            reg_tmp := reg_file(addr_idx_reg);
                            reg_tmp(8*i+7 downto 8*i) := WDATA(8*i+7 downto 8*i);
                            reg_file_next(addr_idx_reg) := reg_tmp;
                        end if;
                    end loop;
                    state_next <= WRITE_DATA;
                end if;

            when WRITE_DATA =>
                wready_i <= '0';
                bvalid_i <= '1';
                if BREADY = '1' then
                    state_next <= IDLE;
                end if;

            when READ_ADDR =>
                arready_i <= '0';
                rdata_next <= reg_file(addr_idx_reg);
                rvalid_i <= '1';
                state_next <= READ_DATA;

            when READ_DATA =>
                rvalid_i <= '1';
                if RREADY = '1' then
                    rvalid_i <= '0';
                    state_next <= IDLE;
                end if;

            when WRITE_RESP =>
                null;

        end case;

        -- Update register file
        for i in 0 to REG_COUNT-1 loop -- TODO do not update done and busy TODO change register map to include first the writable ones then read only ones
            reg_file(i) <= reg_file_next(i);
        end loop;
    end process;

end architecture;
