module atm_controller (
    input clk,
    input reset,
    input card,
    input pin_valid,
    input withdraw,
    input balance_ok,
    output reg card_accept,
    output reg pin_check,
    output reg dispense_cash,
    output reg insufficient_balance
);

parameter IDLE = 3'b000,
          CARD = 3'b001,
          PIN  = 3'b010,
          MENU = 3'b011,
          CASH = 3'b100,
          ERROR = 3'b101;

reg [2:0] state, next_state;

// State register
always @(posedge clk or posedge reset)
begin
    if (reset)
        state <= IDLE;
    else
        state <= next_state;
end

// Next state logic
always @(*)
begin
    next_state = state;

    case(state)

        IDLE:
            if (card)
                next_state = CARD;

        CARD:
            next_state = PIN;

        PIN:
            if (pin_valid)
                next_state = MENU;
            else
                next_state = ERROR;

        MENU:
            if (withdraw)
                if (balance_ok)
                    next_state = CASH;
                else
                    next_state = ERROR;

        CASH:
            next_state = IDLE;

        ERROR:
            next_state = IDLE;

        default:
            next_state = IDLE;

    endcase
end

// Output logic
always @(*)
begin
    card_accept = 0;
    pin_check = 0;
    dispense_cash = 0;
    insufficient_balance = 0;

    case(state)

        CARD:
            card_accept = 1;

        PIN:
            pin_check = 1;

        CASH:
            dispense_cash = 1;

        ERROR:
            insufficient_balance = 1;

    endcase
end

endmodule