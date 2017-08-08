// project 2
// building a ALU for 16 bit numbers
// addition(unsign),addtion(sign),logical operations(and,or,slt(set on less than),branch if not equal)

module MyALU;
reg [15:0]a,b;  // input operands
reg C_in;        // carray in
reg [2:0]control;  // contral the operation

wire [15:0] result;
wire C_out;      // carray out
wire Overflow;   // overflow
wire [2:0] Comparison ; // comparison indicator bits 
wire set_on_less ; // update this wire when slt(set on less than) is is true-signed arithmatic
// when the output, 100=lt , 010=eq  , 001=gt


arithmatic res1(set_on_less,Comparison,Overflow,C_out,result,a,b,C_in,control); // call to the arithmatic model which is doing all arithmatic compitations

initial
begin
a=16'b1000101011001010;
b=16'b0011010111000010;
C_in=16'b1;  // unsign addtion with carray bit=0

control =3'b010; // to check the unsign addition of two operands
#5 $display("result %b, carray out: %b ,comparison :%b ,slt_bit :%b\n",result,C_out,Comparison,set_on_less);

control =3'b011; // to check the signed arithmatic(with 2'complement addition) of two operands
#5 $display("result %b, carray out: %b,overflow: %b ,comparison: %b ,slt_bit: %b\n",result,C_out,Overflow,Comparison,set_on_less); 

control =3'b000; // to check the AND operation of two operands
#5 $display("result of AND : %b \n",result);

control =3'b001; // to check the OR operation of two operands
#5 $display("result of OR  : %b \n",result);

control =3'b111; // to check the SLT operation of two operands
#5 $display("slt :%b \n",set_on_less);

end

endmodule

module arithmatic(slt,comp,overflow,C_out,sum,x,y,C_in,control);
input [15:0]x,y;
input C_in;
input [2:0]control;

output reg overflow;
output reg[15:0] sum;
output reg C_out;
output  [2:0]comp;
output reg slt;


wire [15:0]temp1,temp2;
	assign temp1= (~x+ C_in);
        assign temp2= (~y+ C_in);

// check whether the comparison result and call the module here
comparison com1(comp,x,y);


always @(control,x,y,C_in,comp)  // depends always only control
begin
if(control==3'b010)
	assign{C_out,sum}=x+y;


if(control==3'b011)
  begin
  if(x[15]==0 && y[15]==0)  // both inputs are positive
	assign{C_out,sum}=x+y;
	begin
        if(sum[15]==1)
    	      assign  overflow=1'b1;
        else
	      assign  overflow=1'b0;
	end
 if(x[15]==1 && y[15]==1)  // both inputs are negative
	assign{C_out,sum}=temp1+temp2;
	begin
        if(sum[15]==1)
    	      assign  overflow=1'b1;
        else
	      assign  overflow=1'b0;
	end 

 if(x[15]==1 && y[15]==0)begin  // first input is negative and the second input is positive
	assign{C_out,sum}=temp1+y;
	assign  overflow=1'b0;  // there are not any overflow in this situation
	end

 if(x[15]==0 && y[15]==1)begin  // second input is negative and the first input is positive
	assign{C_out,sum}=x+temp2;
	assign  overflow=1'b0;  // there are not any overflow in this situation
	end

    end    // end of the conditions of the signed addition using the 2,s complement implementation

if(control==3'b000)
/* to perform the bit -wise operations we can use the bit wise operations 
   if operand is shoter than the other one, it will be extended on the left side with zeroes.
*/
	assign sum = x & y;

if(control==3'b001)
	assign sum = x | y;

if(control==3'b111)
	begin
	if(comp == 3'b100)
	  assign slt=1;
	else
          assign slt=0;
   end 
	

end

endmodule



module comparison(compire,x,y); // to compaire the two signed operands and update the comparison bits 100 or 010 or 001
/* implementation
   100 => lt (less than)
   010 => eq (equal)
   001 => gt  (greater thean)
*/
input [15:0]x,y;
output reg [2:0]compire;

wire signed [15:0] temp1;
wire signed [15:0] temp2; // wires for converting to signed operands

assign temp1= x;
assign temp2= y;

always @(temp1,temp2)
begin
if(temp1>temp2)
   	assign compire=3'b001;
else if(temp1==temp2) 
   	assign compire=3'b010;
else 
	assign compire=3'b100;

end

endmodule

 
/* note 
	if the sum of two possitive numbers yeilds a negative result ,the sum has overflow(overflow=1)
	if the sum of two negative numbers yeilds a positive result, the sum has overflow(overflow=1)
	otherwise it will not overflowed(overflow=0)
	this will only consider when sign addition and unsign addtion gives only carray out

	implementation of operations
        000 => And
	001 => Or
	010 => Add
        011 => Substract
        111 => Set-on-less-than

*/