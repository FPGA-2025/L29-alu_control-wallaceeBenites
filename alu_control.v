module ALU_Control (
    input wire is_immediate_i,
    input wire [1:0] ALU_CO_i,
    input wire [6:0] FUNC7_i,
    input wire [2:0] FUNC3_i,
    output reg [3:0] ALU_OP_o
);

localparam AND             = 4'b0000; 
localparam OR              = 4'b0001;
localparam SUM             = 4'b0010;
localparam SUB             = 4'b1010;
localparam GREATER_EQUAL   = 4'b1100;
localparam GREATER_EQUAL_U = 4'b1101;
localparam SLT             = 4'b1110;
localparam SLT_U           = 4'b1111;
localparam SHIFT_LEFT      = 4'b0100;
localparam SHIFT_RIGHT     = 4'b0101;
localparam SHIFT_RIGHT_A   = 4'b0111;
localparam XOR             = 4'b1000;
localparam NOR             = 4'b1001;
localparam EQUAL           = 4'b0011;
localparam FUNCT3_BEQ = 3'b000;
localparam FUNCT3_BNE = 3'b001;
localparam FUNCT3_SLT = 3'b100;
localparam FUNCT3_GREATER_EQUAL = 3'b101;
localparam FUNCT3_SLT_U = 3'b110;
localparam FUNCT3_GREATER_EQUAL_U = 3'b111;

always @(*) begin
    case(ALU_CO_i)
        2'b00: begin 
            ALU_OP_o = SUM;
        end
        2'b01: begin 
            case(FUNC3_i)
                FUNCT3_BEQ : ALU_OP_o = SUB;
                FUNCT3_BNE : ALU_OP_o = EQUAL;
                FUNCT3_SLT: ALU_OP_o = GREATER_EQUAL;
                FUNCT3_GREATER_EQUAL: ALU_OP_o = SLT;
                FUNCT3_SLT_U: ALU_OP_o = GREATER_EQUAL_U;
                FUNCT3_GREATER_EQUAL_U: ALU_OP_o = SLT_U;
                default: ALU_OP_o = SUB; 
            endcase
        end
        2'b10: begin 
            case(FUNC3_i) 
                3'b000: begin 
                    if(!is_immediate_i) begin
                        if(FUNC7_i == 7'b0100000) begin 
                            ALU_OP_o = SUB;
                        end else begin 
                            ALU_OP_o = SUM;
                        end
                    end else begin 
                        ALU_OP_o = SUM;
                    end
                end
                3'b111: begin 
                    ALU_OP_o = AND;
                end
                3'b110: begin 
                    ALU_OP_o = OR;
                end
                3'b100: begin 
                    ALU_OP_o = XOR;
                end
                3'b001: begin 
                    ALU_OP_o = SHIFT_LEFT;
                end
                3'b101: begin 
                    if(FUNC7_i == 7'b0100000) begin 
                        ALU_OP_o = SHIFT_RIGHT_A;
                    end else begin 
                        ALU_OP_o = SHIFT_RIGHT;
                    end
                end
                3'b010: begin
                    ALU_OP_o = SLT; 
                end
                3'b011: begin
                    ALU_OP_o = SLT_U; 
                end
                default: ALU_OP_o = 4'bxxxx; 
            endcase
        end
    default: ALU_OP_o = 4'bxxxx; 
    endcase     
end

endmodule