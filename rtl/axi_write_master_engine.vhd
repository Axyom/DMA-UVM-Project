library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- AXI Write Master Engine
entity axi_write_master_engine is
  generic (
    DATA_WIDTH : integer := 32;
    ADDR_WIDTH : integer := 32;
    BURST_LEN  : integer := 16
  );
  port (
    -- Clock and Reset
    ACLK      : in  std_logic;
    ARESETN   : in  std_logic;
    
    -- Control
    start         : in  std_logic;
    write_addr    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    write_length  : in  std_logic_vector(31 downto 0);  -- length in bytes
    
    -- AXI4 Write Address Channel
    M_AXI_AWADDR  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    M_AXI_AWLEN   : out std_logic_vector(7 downto 0);
    M_AXI_AWSIZE  : out std_logic_vector(2 downto 0);
    M_AXI_AWBURST : out std_logic_vector(1 downto 0);
    M_AXI_AWVALID : out std_logic;
    M_AXI_AWREADY : in  std_logic;
    
    -- AXI4 Write Data Channel
    M_AXI_WDATA   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    M_AXI_WSTRB   : out std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    M_AXI_WLAST   : out std_logic;
    M_AXI_WVALID  : out std_logic;
    M_AXI_WREADY  : in  std_logic;
    
    -- AXI4 Write Response Channel
    M_AXI_BRESP   : in  std_logic_vector(1 downto 0);
    M_AXI_BVALID  : in  std_logic;
    M_AXI_BREADY  : out std_logic;
    
    -- Data input interface (custom internal protocol)
    data_in       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    data_valid    : in  std_logic;
    data_ready    : out std_logic;
    
    -- Status
    busy          : out std_logic;
    done          : out std_logic;
    error         : out std_logic
  );
end entity;
