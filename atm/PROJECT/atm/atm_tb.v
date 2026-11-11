module atm_controller_tb;

reg clk, reset;
reg card, pin_valid, withdraw, balance_ok;

wire card_accept, pin_check;
wire dispense_cash, insufficient_balance;

atm_controller uut (
    .clk(clk),
    .reset(reset),
    .card(card),
    .pin_valid(pin_valid),
    .withdraw(withdraw),
    .balance_ok(balance_ok),
    .card_accept(card_accept),
    .pin_check(pin_check),
    .dispense_cash(dispense_cash),
    .insufficient_balance(insufficient_balance)
);

// Clock generation
always #5 clk = ~clk;

initial begin

    clk = 0;
    reset = 1;
    card = 0;
    pin_valid = 0;
    withdraw = 0;
    balance_ok = 0;

    #10 reset = 0;

    // Insert ATM card
    #10 card = 1;
    #10 card = 0;

    // Correct PIN
    #20 pin_valid = 1;
    #10 pin_valid = 0;

    // Select withdrawal
    #10 withdraw = 1;
    balance_ok = 1;

    // Cash dispensing
    #20 withdraw = 0;

    // Reset
    #30 reset = 1;
    #10 reset = 0;

    // Second transaction: insufficient balance
    #10 card = 1;
    #10 card = 0;

    #20 pin_valid = 1;
    #10 pin_valid = 0;

    #10 withdraw = 1;
    balance_ok = 0;

    #20 withdraw = 0;

    #30 $finish;

end

initial begin
    $monitor("Time=%0t Card=%b PIN=%b Withdraw=%b Balance=%b Cash=%b Error=%b",
    $time, card, pin_valid, withdraw, balance_ok,
    dispense_cash, insufficient_balance);
end

endmodule