interface axi_lite_if #(parameter REG_WIDTH = 32);
    logic ACLK, ARESETn;
    logic [31:0] AWADDR;
    logic AWVALID, AWREADY;
    logic [REG_WIDTH-1:0] WDATA;
    logic [(REG_WIDTH/8)-1:0] WSTRB;
    logic WVALID, WREADY;
    logic BVALID, BREADY;
    logic [1:0] BRESP;
    logic [31:0] ARADDR;
    logic ARVALID, ARREADY;
    logic [REG_WIDTH-1:0] RDATA;
    logic RVALID, RREADY;
    logic [1:0] RRESP;
endinterface

module tb_axi_lite_reg_interface;

    localparam REG_WIDTH = 32;
    localparam WRITE_REG_COUNT = 4;
    localparam READ_REG_COUNT = 2;

    axi_lite_if #(REG_WIDTH) axi_if();

    axi_lite_reg_interface #(
        .REG_WIDTH(REG_WIDTH),
        .WRITE_REG_COUNT(WRITE_REG_COUNT),
        .READ_REG_COUNT(READ_REG_COUNT)
    ) dut (
        .ACLK(axi_if.ACLK),
        .ARESETn(axi_if.ARESETn),
        .AWADDR(axi_if.AWADDR),
        .AWVALID(axi_if.AWVALID),
        .AWREADY(axi_if.AWREADY),
        .WDATA(axi_if.WDATA),
        .WSTRB(axi_if.WSTRB),
        .WVALID(axi_if.WVALID),
        .WREADY(axi_if.WREADY),
        .BVALID(axi_if.BVALID),
        .BREADY(axi_if.BREADY),
        .BRESP(axi_if.BRESP),
        .ARADDR(axi_if.ARADDR),
        .ARVALID(axi_if.ARVALID),
        .ARREADY(axi_if.ARREADY),
        .RDATA(axi_if.RDATA),
        .RVALID(axi_if.RVALID),
        .RREADY(axi_if.RREADY),
        .RRESP(axi_if.RRESP),
        .start(),
        .irq_enable(),
        .busy(1'b0),
        .done(1'b0),
        .src_addr(),
        .dst_addr(),
        .length()
    );

    // Clock generation
    initial axi_if.ACLK = 0;
    always #5 axi_if.ACLK = ~axi_if.ACLK;

    // Reset logic
    initial begin
        axi_if.ARESETn = 0;
        repeat (5) @(posedge axi_if.ACLK);
        axi_if.ARESETn = 1;
    end

    // Task to write register
    task automatic write_reg(input int address, input logic [REG_WIDTH-1:0] data);
        begin
            @(posedge axi_if.ACLK);
            axi_if.AWADDR = address * 8;
            axi_if.AWVALID = 1;
            axi_if.WDATA = data;
            axi_if.WSTRB = {(REG_WIDTH/8){1'b1}};
            axi_if.WVALID = 1;
            axi_if.BREADY = 1;

            // Wait for AWREADY and WREADY
            wait (axi_if.AWREADY == 1);
            wait (axi_if.WREADY == 1);

            @(posedge axi_if.ACLK);
            axi_if.AWVALID = 0;
            axi_if.WVALID = 0;

            // Wait for BVALID
            wait (axi_if.BVALID == 1);
            @(posedge axi_if.ACLK);
            axi_if.BREADY = 0;
        end
    endtask

    // Initial test sequence
    initial begin
        wait (axi_if.ARESETn == 1);
        
        axi_if.AWVALID = 1;
        // Example write
        write_reg(0, 32'hDEADBEEF);
        write_reg(1, 32'h12345678);

        // Add more stimulus as needed

        #1000 $finish;
    end

endmodule
