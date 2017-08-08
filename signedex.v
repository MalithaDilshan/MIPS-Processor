
module Regfile;
reg [3:0]C;
wire [15:0]A;
reg clock;

initial
 clock=1'b0;
always
 #5 clock=~clock;
initial
 #100 $finish;

signExtends mytest(C,A);

initial
begin
C=4'b0101;
	
$display("adhgajdf %d",A);

end


endmodule

module signExtends(inputX,outputY);

input  [3:0]inputX;
output reg[15:0]outputY;
integer i;

  
  for(i=0;i<4;i=i+1)begin
     outputY[i]<=inputX[i];
  end

  for(i=4;i<16;i=i+1)begin
     outputY[i]<=inputX[3];
  end


endmodule

