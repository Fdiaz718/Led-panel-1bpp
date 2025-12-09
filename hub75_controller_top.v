module hub75_controller_top(
    input  wire clk,
    input  wire rst,

    output wire r0, g0, b0,
    output wire r1, g1, b1,
    output wire [4:0] addr, // A, B, C, D, E
    output wire clk_out,
    output wire latch,
    output wire oe
);

    // ============ WIRES ============
    wire [5:0] col;
    wire [4:0] scan_row;      // Fila que lee la memoria (Futuro)
    wire [4:0] display_row;   // Fila que se muestra en el panel (Presente)
    wire [5:0] row_top;
    wire [5:0] row_bottom;

    // ============ 1. CONTADORES (Con Sync Fix) ============
    scan_counters SC(
        .clk(clk),
        .rst(rst),
        .col(col),
        .scan_row(scan_row),
        .addr_out(display_row), // Usamos la dirección estable
        .row_top(row_top),
        .row_bottom(row_bottom)
    );

    // Conectamos la dirección estable a los pines físicos
    assign addr = display_row;

    // ============ 2. MEMORIA ============
    // Usamos scan_row para leer el dato de la memoria con antelación
    wire [11:0] addr_top    = {row_top,    col};
    wire [11:0] addr_bottom = {row_bottom, col};
    wire [23:0] pix_top;
    wire [23:0] pix_bottom;

    panel_memory MEM(
        .clk(clk),
        .addr_top(addr_top),
        .addr_bottom(addr_bottom),
        .pix_top(pix_top),
        .pix_bottom(pix_bottom)
    );

    // ============ 3. FSM (Mapeo de Colores Corregido) ============
    panel_fsm FSM(
        .pix_top(pix_top),
        .pix_bottom(pix_bottom),
        .r0(r0), .g0(g0), .b0(b0),
        .r1(r1), .g1(g1), .b1(b1)
    );

    // ============ 4. TIMING ============
    delay_unit DU(
        .clk(clk),
        .rst(rst),
        .col(col),
        .clk_out(clk_out),
        .latch(latch),
        .oe(oe)
    );

endmodule
