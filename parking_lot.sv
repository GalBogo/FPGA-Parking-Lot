module parking_lot #(
    parameter lot_capacity = 3
)(
    input logic clk,
    input logic rst,        
    input logic car_enter,  
    input logic car_exit,   

    output logic gate_open, 
    output logic lot_full   
);

    // Variables
    logic car_enter_prev;
    logic car_exit_prev;
    logic enter_pulse;
    logic exit_pulse;
    logic [1:0] count;

    typedef enum logic [1:0]{
        idle,
        open_gate,
        full
    } state_t;

    state_t current_state, next_state;

    // --- Block 1: Edge Detection ---
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            car_enter_prev <= 0;
            car_exit_prev <= 0;
        end else begin
            car_enter_prev <= car_enter;
            car_exit_prev <= car_exit;
        end
    end

    assign enter_pulse = (car_enter == 1 && car_enter_prev == 0);
    assign exit_pulse  = (car_exit == 1  && car_exit_prev == 0);

    // --- Block 2: Counter ---
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
        end else begin
            if (enter_pulse == 1 && count < lot_capacity) begin
                count <= count + 1;
            end
            else if (exit_pulse == 1 && count > 0) begin
                count <= count - 1;
            end
        end
    end

    // --- Block 3: State Memory ---
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= idle;
        end else begin
            current_state <= next_state;
        end
    end

    // --- Block 4: FSM Logic ---
    always_comb begin
        // Defaults
        next_state = current_state;
        gate_open = 0;
        lot_full = 0;

        case (current_state)
            idle: begin
                if (count == lot_capacity) begin
                    next_state = full;
                end else if (enter_pulse || (exit_pulse && count > 0)) begin
                    next_state = open_gate;
                end
            end

            open_gate: begin
                gate_open = 1;
                if (count == lot_capacity) begin
                    next_state = full;
                end else begin
                    next_state = idle;
                end 
            end

            full: begin
                lot_full = 1;
                if (exit_pulse) begin
                    next_state = open_gate;
                end
            end 

            default: next_state = idle;
        endcase 
    end

endmodule