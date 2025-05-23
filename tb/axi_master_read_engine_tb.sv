interface axi4_read_if #(parameter REG_WIDTH = 32);
    logic ACLK, ARESETn;
    logic [REG_WIDTH-1:0] ARADDR;
    logic [7:0] ARLEN;
    logic [2:0] ARSIZE;
    logic [1:0] ARBURST;
    logic ARVALID, ARREADY;
    logic [REG_WIDTH-1:0] RDATA;
    logic [1:0] RRESP;
    logic RLAST, RVALID, RREADY;
endinterface

class axi4_read_slave_emul;
    virtual axi4_read_if vif;

    int unsigned beat_cnt;
    int unsigned burst_len;
    bit [31:0] addr_base;

    typedef enum {IDLE, RESPOND} state_t;
    state_t state;

    function new(virtual axi4_read_if vif_handle);
        this.vif = vif_handle;
        this.state = IDLE;
        this.addr_base = 32'hDEAD0000;
    endfunction

    task run();
        forever begin
            @(posedge vif.ACLK);
            if (!vif.ARESETn) begin
                reset_state();
            end else begin
                case(state)
                    IDLE: idle_state();
                    RESPOND: respond_state();
                endcase
            end
        end
    endtask

    task reset_state();
        vif.ARREADY <= 0;
        vif.RVALID <= 0;
        vif.RLAST <= 0;
        state = IDLE;
        beat_cnt = 0;
        burst_len = 0;
    endtask

    task idle_state();
        vif.ARREADY <= 1;
        vif.RVALID <= 0;
        vif.RLAST <= 0;
        if (vif.ARVALID) begin
            vif.ARREADY <= 0;
            addr_base = vif.ARADDR;
            burst_len = vif.ARLEN;
            beat_cnt = 0;
            state = RESPOND;
        end
    endtask

    task respond_state();
        vif.RVALID <= 1;
        vif.RRESP <= 2'b00;
        vif.RDATA <= addr_base + beat_cnt;
        if (vif.RREADY == 1) begin
            beat_cnt++;
            if (beat_cnt > burst_len) begin
                vif.RLAST <= 1;
                state = IDLE;
            end
        end
    endtask

endclass

module axi_read_master_engine_tb;
    localparam REG_WIDTH = 32;

    axi4_read_if #(REG_WIDTH) axi_if();

    axi4_read_slave_emul slave;

    logic start;
    logic [REG_WIDTH-1:0] read_addr;
    logic [7:0] read_length;

    logic busy;
    logic done;

    logic [REG_WIDTH-1:0] data_out;
    logic data_valid;
    logic receive_data_ready;

    axi_read_master_engine #(
        .REG_WIDTH(REG_WIDTH),
        .BURST_LEN(16)
    ) dut (
        .ACLK(axi_if.ACLK),
        .ARESETN(axi_if.ARESETn),
        .start(start),
        .read_addr(read_addr),
        .read_length(read_length),

        .M_AXI_ARADDR(axi_if.ARADDR),
        .M_AXI_ARLEN(axi_if.ARLEN),
        .M_AXI_ARSIZE(axi_if.ARSIZE),
        .M_AXI_ARBURST(axi_if.ARBURST),
        .M_AXI_ARVALID(axi_if.ARVALID),
        .M_AXI_ARREADY(axi_if.ARREADY),

        .M_AXI_RDATA(axi_if.RDATA),
        .M_AXI_RRESP(axi_if.RRESP),
        .M_AXI_RLAST(axi_if.RLAST),
        .M_AXI_RVALID(axi_if.RVALID),
        .M_AXI_RREADY(axi_if.RREADY),

        .data_out(data_out),
        .data_valid(data_valid),
        .receive_data_ready(receive_data_ready),

        .busy(busy),
        .done(done)
    );

    // Clock generation
    initial axi_if.ACLK = 0;
    always #5 axi_if.ACLK = ~axi_if.ACLK;

    // Async reset: assert low, deassert high synchronously
    initial begin
        axi_if.ARESETn = 0;
        #13;
        axi_if.ARESETn = 1;
    end

    // Slave run
    initial begin
        slave = new(axi_if);
        fork
            slave.run();
        join_none
    end
    
    task automatic read_request
    (
        input logic[REG_WIDTH-1:0] rd_addr, 
        input logic[7:0] rd_length
    );
        read_addr = rd_addr;
        read_length = rd_length;  // 4 beats total (0-based)

        @(posedge axi_if.ACLK);
        start = 1;
        @(posedge axi_if.ACLK);
        start = 0;

        wait(done == 1);
        @(posedge axi_if.ACLK);    
    endtask

    // Stimulus
    initial begin
        wait(axi_if.ARESETn == 1);
        @(posedge axi_if.ACLK);

        start = 0;
        receive_data_ready = 1;
        
        read_request(32'h1000_0000, 8'd3);
        
        read_request(32'hDEAD_0000, 8'd8);
        
        read_request(32'hCAFE_0000, 8'd1);
        
        read_request(32'hCAFE_0000, 8'd45);
        
        $finish;
    end
endmodule
