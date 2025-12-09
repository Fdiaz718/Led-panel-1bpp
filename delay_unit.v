module delay_unit (
    input  wire clk,
    input  wire rst,
    input  wire [5:0] col,

    output wire clk_out,
    output reg latch,
    output reg oe
);

    // Invertimos el reloj para centrar los datos (estabilidad)
    assign clk_out = ~clk;

    always @(posedge clk) begin
        if (rst) begin
            latch <= 0;
            oe    <= 1; // Apagado por defecto
        end else begin
            // Por defecto:
            latch <= 0;
            oe    <= 0; // Pantalla encendida

            // Al inicio de la línea (col 0): LATCH
            if (col == 0) begin
                latch <= 1; 
                oe    <= 1; // Apagar durante el latch para evitar ruido
            end
            
            // Al final de la línea (col 63): Apagar preventivamente
            else if (col == 63) begin
                oe <= 1;
            end
        end
    end
endmodule
