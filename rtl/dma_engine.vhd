library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dma_engine is
    generic (
        DATA_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 32;
        BURST_LEN  : integer := 16
    );
    port (
        ACLK      : in  std_logic;
        ARESETN   : in  std_logic;
    
        -- AXI4-Lite Control Interface (to/from axi_lite_reg_interface)
        start      : in  std_logic;
        irq_enable : in  std_logic;
        busy       : out std_logic;
        done       : out std_logic;
        src_addr   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        dst_addr   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        length     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        
        -- Interruption signal
        irq        : out std_logic;
        
        -- AXI4 Master Interface (Write Address Channel)
        M_AXI_ACLK    : in  std_logic;
        M_AXI_ARESETN : in  std_logic;
        
        M_AXI_AWID    : out std_logic_vector(3 downto 0);
        M_AXI_AWADDR  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        M_AXI_AWLEN   : out std_logic_vector(7 downto 0);
        M_AXI_AWSIZE  : out std_logic_vector(2 downto 0);
        M_AXI_AWBURST : out std_logic_vector(1 downto 0);
        M_AXI_AWLOCK  : out std_logic_vector(0 downto 0);
        M_AXI_AWCACHE : out std_logic_vector(3 downto 0);
        M_AXI_AWPROT  : out std_logic_vector(2 downto 0);
        M_AXI_AWVALID : out std_logic;
        M_AXI_AWREADY : in  std_logic;
        
        -- AXI4 Master Interface (Write Data Channel)
        M_AXI_WDATA   : out std_logic_vector(DATA_WIDTH-1 downto 0);
        M_AXI_WSTRB   : out std_logic_vector((DATA_WIDTH/8)-1 downto 0);
        M_AXI_WLAST   : out std_logic;
        M_AXI_WVALID  : out std_logic;
        M_AXI_WREADY  : in  std_logic;
        
        -- AXI4 Master Interface (Write Response Channel)
        M_AXI_BID     : in  std_logic_vector(3 downto 0);
        M_AXI_BRESP   : in  std_logic_vector(1 downto 0);
        M_AXI_BVALID  : in  std_logic;
        M_AXI_BREADY  : out std_logic;
        
        -- AXI4 Master Interface (Read Address Channel)
        M_AXI_ARID    : out std_logic_vector(3 downto 0);
        M_AXI_ARADDR  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        M_AXI_ARLEN   : out std_logic_vector(7 downto 0);
        M_AXI_ARSIZE  : out std_logic_vector(2 downto 0);
        M_AXI_ARBURST : out std_logic_vector(1 downto 0);
        M_AXI_ARLOCK  : out std_logic_vector(0 downto 0);
        M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
        M_AXI_ARPROT  : out std_logic_vector(2 downto 0);
        M_AXI_ARVALID : out std_logic;
        M_AXI_ARREADY : in  std_logic;
        
        -- AXI4 Master Interface (Read Data Channel)
        M_AXI_RID     : in  std_logic_vector(3 downto 0);
        M_AXI_RDATA   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        M_AXI_RRESP   : in  std_logic_vector(1 downto 0);
        M_AXI_RLAST   : in  std_logic;
        M_AXI_RVALID  : in  std_logic;
        M_AXI_RREADY  : out std_logic
    );
end entity dma_engine;
