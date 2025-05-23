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

module axi_lite_reg_interface_tb;

    localparam REG_WIDTH = 32;
    localparam WRITE_REG_COUNT = 4;
    localparam READ_REG_COUNT = 1;
    
    logic busy;
    logic start;
    logic done;
    logic irq_enable;

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
        .busy(busy),
        .done(done),
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
        repeat (2) @(posedge axi_if.ACLK);
        axi_if.ARESETn = 1;
    end

    // Task to write register
    task automatic write_reg
    (
        input logic [REG_WIDTH-1:0] address,
        input logic [REG_WIDTH-1:0] data, 
        output logic[1:0] bresp,
        input logic [REG_WIDTH/8-1:0] strb = {(REG_WIDTH/8){1'b1}},
        input int delay_write = 0, 
        input int delay_bready = 0
    );
        axi_if.AWADDR = address;
        axi_if.WDATA = data;
        axi_if.WSTRB = strb;
        axi_if.AWVALID = 1;
        @(posedge axi_if.ACLK);
        // Wait for AWREADY and WREADY
        wait (axi_if.AWREADY == 1);
        axi_if.AWVALID = 0;
        
        repeat (delay_write) @(posedge axi_if.ACLK);
        axi_if.WVALID = 1;
        
        
        wait (axi_if.WREADY == 1);
        @(posedge axi_if.ACLK);
        axi_if.WVALID = 0;
        
        repeat (delay_bready) @(posedge axi_if.ACLK);
        axi_if.BREADY = 1;
        
        // Wait for BVALID
        wait (axi_if.BVALID == 1);
        bresp = axi_if.BRESP;
        
        @(posedge axi_if.ACLK);
        axi_if.BREADY = 0;
    endtask

    // Task to read a register
    task automatic read_reg
    (
        input logic [REG_WIDTH-1:0] address, 
        output logic [REG_WIDTH-1:0] data, 
        output logic [1:0] rresp, 
        input int delay_rready=0
    );
        axi_if.ARVALID = 1;
        axi_if.RREADY = 0;
        axi_if.ARADDR = address;
        @(posedge axi_if.ACLK);
        
        wait(axi_if.ARREADY);
        axi_if.ARVALID = 0;
        
        wait(axi_if.RVALID == 1);
        data = axi_if.RDATA;
        rresp = axi_if.RRESP;
        
        repeat(delay_rready) @(posedge axi_if.ACLK);
        
        axi_if.RREADY = 1;
        @(posedge axi_if.ACLK);
        axi_if.RREADY = 0;
    endtask
    // Initial test sequence
    initial begin
        integer bresp, rdata, rresp;
        
        done = 0;
        busy = 0;
        
        wait (axi_if.ARESETn == 1);
        @(posedge axi_if.ACLK);
        
        // Example write
        write_reg(32'h0, 32'hDEADBEEF, bresp);
        assert (bresp == 2'b00);
        write_reg(32'h4, 32'h12345678, bresp, 4'h7);
        assert (bresp == 2'b00);
        write_reg(32'h8, 32'hCAFEBABE, bresp, 4'hf, 8, 1);
        assert (bresp == 2'b00);
        write_reg(32'hC, 32'hBAADF00D, bresp, 4'hf, 1, 3);
        assert (bresp == 2'b00);
        write_reg(32'h10, 32'hDEADC0DE, bresp, 4'hf, 10, 5); // error, write in read-only space
        assert (bresp == 2'b11);
        
        read_reg(32'h0, rdata, rresp);
        assert (rdata == 32'hDEADBEEE);
        assert (rresp == 2'b00);
        read_reg(32'h4, rdata, rresp);
        assert (rdata == 32'h00345678);
        assert (rresp == 2'b00);
        read_reg(32'h8, rdata, rresp);
        assert (rdata == 32'hCAFEBABE);
        assert (rresp == 2'b00);
        read_reg(32'hC, rdata, rresp);
        assert (rdata == 32'hBAADF00D);
        assert (rresp == 2'b00);
        read_reg(32'h20, rdata, rresp); // error
        assert (rresp == 2'b11);
        
        done = 1;
        busy = 1;
        
        read_reg(32'h10, rdata, rresp); // error
        assert (rdata == 32'h00000003);
        assert (rresp == 2'b00);

        // Add more stimulus as needed
        @(posedge axi_if.ACLK);
        $finish;
    end

endmodule
