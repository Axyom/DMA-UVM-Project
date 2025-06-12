module axi_lite_reg_interface #(
    parameter REG_WIDTH = 32,
    parameter WRITE_REG_COUNT = 4,
    parameter READ_REG_COUNT = 2
)(
    input  wire                     ACLK,
    input  wire                     ARESETn,

    // Write Address Channel
    input  wire [31:0]              AWADDR,
    input  wire                     AWVALID,
    output reg                      AWREADY,

    // Write Data Channel
    input  wire [REG_WIDTH-1:0]    WDATA,
    input  wire [(REG_WIDTH/8)-1:0] WSTRB,
    input  wire                     WVALID,
    output reg                      WREADY,

    // Write Response Channel
    output reg                      BVALID,
    input  wire                     BREADY,
    output reg [1:0]                BRESP,

    // Read Address Channel
    input  wire [31:0]              ARADDR,
    input  wire                     ARVALID,
    output reg                      ARREADY,

    // Read Data Channel
    output reg [REG_WIDTH-1:0]     RDATA,
    output reg                     RVALID,
    input  wire                    RREADY,
    output reg [1:0]               RRESP,

    // DMA engine signals
    output wire                   start,
    output wire                   irq_enable,
    input  wire                   busy,
    input  wire                   done,
    output reg [REG_WIDTH-1:0]   src_addr,
    output reg [REG_WIDTH-1:0]   dst_addr,
    output reg [REG_WIDTH-1:0]   length
);

// State encoding
localparam IDLE       = 2'd0;
localparam WRITE_DATA = 2'd1;
localparam WRITE_RESP = 2'd2;
localparam READ_DATA  = 2'd3;

reg [1:0] state, state_next;
reg [$clog2(WRITE_REG_COUNT+READ_REG_COUNT)-1:0] address_reg, address_next;

reg [REG_WIDTH-1:0] reg_space [0:WRITE_REG_COUNT+READ_REG_COUNT-1];
reg [REG_WIDTH-1:0] reg_space_next [0:WRITE_REG_COUNT+READ_REG_COUNT-1];

// Output assignments for control bits (start and irq_enable)
assign start = reg_space[0][0];
assign irq_enable = reg_space[0][1];

// Sequential logic
integer i;
always @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        state <= IDLE;
        address_reg <= 0;
        for (i=0; i < WRITE_REG_COUNT + READ_REG_COUNT; i=i+1) begin
            reg_space[i] <= 0;
        end
    end else begin
        state <= state_next;
        address_reg <= address_next;
        for (i=0; i < WRITE_REG_COUNT + READ_REG_COUNT; i=i+1) begin
            reg_space[i] <= reg_space_next[i];
        end
    end
end

// Combinational logic
always @* begin
    // Defaults
    state_next = state;
    address_next = address_reg;
    AWREADY = 0;
    WREADY = 0;
    BVALID = 0;
    BRESP = 2'b00;
    ARREADY = 0;
    RVALID = 0;
    RDATA = {REG_WIDTH{1'b0}};
    RRESP = 2'b00;

    // Default reg_space_next is current values except:
    for (i=0; i < WRITE_REG_COUNT + READ_REG_COUNT; i=i+1) begin
        reg_space_next[i] = reg_space[i];
    end

    // Clear start bit automatically
    reg_space_next[0][0] = 1'b0;

    // Update status bits buffered in read register space
    if ((WRITE_REG_COUNT) < (WRITE_REG_COUNT + READ_REG_COUNT))
        reg_space_next[WRITE_REG_COUNT][1:0] = {done, busy};

    case(state)
        IDLE: begin
            if (AWVALID) begin
                state_next = WRITE_DATA;
                AWREADY = 1;
                address_next = AWADDR[REG_WIDTH-1:2];
            end else if (ARVALID) begin
                state_next = READ_DATA;
                ARREADY = 1;
                address_next = ARADDR[REG_WIDTH-1:2];
            end
        end

        WRITE_DATA: begin
            if (WVALID) begin
                WREADY = 1;

                if (address_reg < WRITE_REG_COUNT) begin
                    // Byte enable write strobes
                    for (i = 0; i < REG_WIDTH/8; i = i + 1) begin
                        if (WSTRB[i]) begin
                            reg_space_next[address_reg][8*i +: 8] = WDATA[8*i +: 8];
                        end
                    end
                end

                state_next = WRITE_RESP;
            end
        end

        WRITE_RESP: begin
            BVALID = 1;
            if (address_reg >= WRITE_REG_COUNT) begin
                BRESP = 2'b11; // error response
            end else begin
                BRESP = 2'b00; // OKAY
            end

            if (BREADY) begin
                state_next = IDLE;
            end
        end

        READ_DATA: begin
            RVALID = 1;
            if (address_reg < WRITE_REG_COUNT + READ_REG_COUNT) begin
                RDATA = reg_space[address_reg];
                RRESP = 2'b00;
            end else begin
                RRESP = 2'b11; // error response
            end

            if (RREADY) begin
                state_next = IDLE;
            end
        end

        default: begin
            state_next = IDLE;
        end
    endcase
end

// Map register space outputs to signals
always @* begin
    src_addr = reg_space[1];
    dst_addr = reg_space[2];
    length = reg_space[3];
end

endmodule
