module scan_counters(
    input  wire clk,
    input  wire rst,

    output reg [5:0] col,        
    output reg [4:0] scan_row,   // Para leer memoria
    output reg [4:0] addr_out,   // Para pines A-E (Dirección estable)
    
    output wire [5:0] row_top,      
    output wire [5:0] row_bottom    
);

    always @(posedge clk) begin
        if (rst) begin
            col <= 0;
            scan_row <= 0;
            addr_out <= 0;
        end else begin
            // 1. Contador de Columnas
            col <= col + 1;
            
            // Reinicio de columna
            if (col == 63) begin
                col <= 0;
            end

            // 2. Sincronización de Fila
            // IMPORTANTE: Actualizamos la dirección del panel (addr_out) 
            // solo cuando estamos en col == 0 (durante el Latch).
            if (col == 0) begin
                addr_out <= scan_row; 
            end

            // 3. Avance de Lectura
            // Avanzamos el lector de memoria un poco después (col == 1)
            // para ir preparando los datos de la siguiente línea.
            if (col == 1) begin
                scan_row <= scan_row + 1;
                if (scan_row == 31) 
                    scan_row <= 0;
            end
        end
    end

    // Direccionamiento para memoria (1/32 scan para 64x64)
    assign row_top    = {1'b0, scan_row}; // 0..31
    assign row_bottom = {1'b1, scan_row}; // 32..63

endmodule
