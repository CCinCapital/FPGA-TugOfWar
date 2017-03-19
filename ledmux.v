module ledmux(score, leds_ctrl, leds_out);
  `define OFF 7'b0000000
  `define ON 7'b1111111
  
  input wire[6:0] score;
  input wire[1:0] leds_ctrl;
  
  output reg[6:0] leds_out;
  
  always@(leds_ctrl or score)
  begin
    case(leds_ctrl)
      2'b00:  leds_out = `OFF;
      2'b01:  leds_out = 7'b0001001;
      2'b11:  leds_out = `ON;
      2'b10:  leds_out = score;
      default: leds_out = 7'b1010101;
    endcase
  end  
 endmodule