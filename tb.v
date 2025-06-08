`timescale 1ns/1ps

module tb();

reg is_immediate_i;
reg [1:0] ALU_CO_i;
reg [6:0] FUNC7_i;
reg [2:0] FUNC3_i;
wire [3:0] ALU_OP_o;

    reg [16:0] test_mem [0:11];
    reg [3:0] expected_ALU_OP;
    integer i;

    ALU_Control uut(
        .is_immediate_i(is_immediate_i),
        .ALU_CO_i(ALU_CO_i),
        .FUNC7_i(FUNC7_i),
        .FUNC3_i(FUNC3_i),
        .ALU_OP_o(ALU_OP_o)
    );

    initial begin
        $dumpfile("saida.vcd");
        $dumpvars(0, tb);

        $readmemb("teste.txt", test_mem);

        for (i = 0; i < 12; i = i + 1) begin
            
            is_immediate_i  = test_mem[i][16];
            ALU_CO_i        = test_mem[i][15:14];
            FUNC7_i         = test_mem[i][13:7];
            FUNC3_i         = test_mem[i][6:4];
            expected_ALU_OP = test_mem[i][3:0];

            #1; // aguarda propagação

            if (ALU_OP_o === expected_ALU_OP) begin
                $display("=== OK  [%0d] is_immediate_i:%b ALU_CO_i:%b FUNC7_i:%b FUNC3_i:%b => ALU_OP_o:%b (esperado)", i, is_immediate_i, ALU_CO_i, FUNC7_i, FUNC3_i, ALU_OP_o);
            end else begin
                $display("=== ERRO[%0d] is_immediate_i:%b ALU_CO_i:%b FUNC7_i:%b FUNC3_i:%b => ALU_OP_o:%b (esperado: %b)", i, is_immediate_i, ALU_CO_i, FUNC7_i, FUNC3_i, ALU_OP_o, expected_ALU_OP);
            end
        end

        $finish;
    end

endmodule