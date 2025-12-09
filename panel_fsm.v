module panel_fsm(
    input  wire [23:0] pix_top,
    input  wire [23:0] pix_bottom,
    output wire r0, g0, b0,
    output wire r1, g1, b1
);

    assign r0 = pix_top[23];  // Bit Verde
    assign g0 = pix_top[15];   // Bit Azul
    assign b0 = pix_top[7];  // Bit Rojo

    // Parte Inferior
    assign r1 = pix_bottom[23];
    assign g1 = pix_bottom[15];
    assign b1 = pix_bottom[7];

endmodule
