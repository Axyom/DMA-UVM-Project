library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity axi_lite_reg_interface_tb is
end entity;

architecture behavior of axi_lite_reg_interface_tb is

    constant REG_WIDTH       : integer := 32;
    constant WRITE_REG_COUNT : integer := 4;
    constant READ_REG_COUNT  : integer := 2;

    signal ACLK      : std_logic := '0';
    signal ARESETn   : std_logic := '0';

    signal AWADDR    : std_logic_vector(31 downto 0) := (others => '0');
    signal AWVALID   : std_logic := '0';
    signal AWREADY   : std_logic;

    signal WDATA     : std_logic_vector(REG_WIDTH-1 downto 0) := (others => '0');
    signal WSTRB     : std_logic_vector((REG_WIDTH/8)-1 downto 0) := (others => '1');
    signal WVALID    : std_logic := '0';
    signal WREADY    : std_logic;

    signal BVALID    : std_logic;
    signal BREADY    : std_logic := '0';
    signal BRESP     : std_logic_vector(1 downto 0);

    signal ARADDR    : std_logic_vector(31 downto 0) := (others => '0');
    signal ARVALID   : std_logic := '0';
    signal ARREADY   : std_logic;

    signal RDATA     : std_logic_vector(REG_WIDTH-1 downto 0);
    signal RVALID    : std_logic;
    signal RREADY    : std_logic := '0';
    signal RRESP     : std_logic_vector(1 downto 0);

    signal start     : std_logic;
    signal irq_enable: std_logic;
    signal busy      : std_logic := '0';
    signal done      : std_logic := '0';
    signal src_addr  : std_logic_vector(REG_WIDTH-1 downto 0);
    signal dst_addr  : std_logic_vector(REG_WIDTH-1 downto 0);
    signal length    : std_logic_vector(REG_WIDTH-1 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    -- Write transaction procedure
    procedure write_reg ( address : in integer; data : in std_logic_vector(REG_WIDTH-1 downto 0)) is
    begin
--        -- Assert AW channel
--        AWADDR <= std_logic_vector(to_unsigned(address*8, 32));
--        AWVALID <= '1';
--        wait until rising_edge(ACLK);
--        while AWREADY /= '1' loop
--            wait until rising_edge(ACLK);
--        end loop;
--        AWVALID <= '0';

--        -- Assert W channel
--        WDATA <= data;
--        WSTRB <= (others => '1');
--        WVALID <= '1';
--        wait until rising_edge(ACLK);
--        while WREADY /= '1' loop
--            wait until rising_edge(ACLK);
--        end loop;
--        WVALID <= '0';

--        -- Wait for BVALID and assert BREADY
--        BREADY <= '1';
--        wait until rising_edge(ACLK);
--        while BVALID /= '1' loop
--            wait until rising_edge(ACLK);
--        end loop;
--        BREADY <= '0';

--        wait until rising_edge(ACLK);
    end procedure;    

begin

    uut: entity work.axi_lite_reg_interface
        generic map (
            REG_WIDTH => REG_WIDTH,
            WRITE_REG_COUNT => WRITE_REG_COUNT,
            READ_REG_COUNT => READ_REG_COUNT
        )
        port map (
            ACLK => ACLK,
            ARESETn => ARESETn,
            AWADDR => AWADDR,
            AWVALID => AWVALID,
            AWREADY => AWREADY,
            WDATA => WDATA,
            WSTRB => WSTRB,
            WVALID => WVALID,
            WREADY => WREADY,
            BVALID => BVALID,
            BREADY => BREADY,
            BRESP => BRESP,
            ARADDR => ARADDR,
            ARVALID => ARVALID,
            ARREADY => ARREADY,
            RDATA => RDATA,
            RVALID => RVALID,
            RREADY => RREADY,
            RRESP => RRESP,
            start => start,
            irq_enable => irq_enable,
            busy => busy,
            done => done,
            src_addr => src_addr,
            dst_addr => dst_addr,
            length => length
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            ACLK <= '0';
            wait for CLK_PERIOD/2;
            ACLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Reset process
    reset_process : process
    begin
        ARESETn <= '0';
        wait for 25 ns;
        ARESETn <= '1';
        wait;
    end process;
    




--    -- Read transaction procedure
--    procedure read_reg(address : in integer; variable data_out : out std_logic_vector) is
--    begin
--        ARADDR <= std_logic_vector(to_unsigned(address*8, 32));
--        ARVALID <= '1';
--        wait until rising_edge(ACLK);
--        while ARREADY /= '1' loop
--            wait until rising_edge(ACLK);
--        end loop;
--        ARVALID <= '0';

--        RREADY <= '1';
--        wait until rising_edge(ACLK);
--        while RVALID /= '1' loop
--            wait until rising_edge(ACLK);
--        end loop;
--        data_out := RDATA;
--        RREADY <= '0';

--        wait until rising_edge(ACLK);
--    end procedure;

--    stimulus : process
--        variable read_data : std_logic_vector(REG_WIDTH-1 downto 0);
--    begin
--        wait until ARESETn = '1';

--        -- Write to registers 0 to 3
--        write_reg(0, x"00000003"); -- start=1, irq_enable=1
--        write_reg(1, x"DEADBEEF");
--        write_reg(2, x"CAFEBABE");
--        write_reg(3, x"00001000");

--        -- Set busy and done signals to test read side
--        busy <= '1';
--        done <= '1';
--        wait for CLK_PERIOD * 2;

--        -- Read registers 4 and 5 (read registers)
--        read_reg(2, read_data);
--        assert read_data(REG_WIDTH-1 downto 0) = src_addr
--            report "Read src_addr mismatch" severity error;

--        read_reg(5, read_data);
--        assert read_data(REG_WIDTH-1 downto 0) = dst_addr
--            report "Read dst_addr mismatch" severity error;

--        -- Read register 3 (write reg) address out of range test (should respond error)
--        read_reg(6, read_data); -- 6 > WRITE_REG_COUNT+READ_REG_COUNT-1, expect RRESP "11"
--        assert RRESP = "11" report "Read address error not detected" severity error;

--        wait for 50 ns;
--        assert start = '0' report "Start bit not cleared automatically" severity error;

--        wait;
--    end process;

end architecture;
