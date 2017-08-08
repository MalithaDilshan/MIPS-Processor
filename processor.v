/* conected models

regfile
alu 
controler and alu controler
memory */

module Processor;
reg [15:0]C;
wire [15:0]A,B;

reg [3:0] Aaddr,Baddr,Caddr;
reg load,clear,clock;

// inputs for the ALU
reg C_in;        // carray in
reg [2:0]control;  // contral the operation of ALU
reg [3:0]opcode; // here use the register for the opcode
wire [8:0]control_bits;  // get the nine bit control output and this one can input to the alu control unit module

wire [15:0] result;
wire C_out;      // carray out
wire Overflow;   // overflow
wire [2:0] Comparison ; // comparison indicator bits 
wire set_on_less ; // update this wire when slt(set on less than) is is true-signed arithmatic
// when the output, 100=lt , 010=eq  , 001=gt

wire regdes,branch,memred,memtoreg,aluop,memwr,alusrc,regwr,jump; // to get the control path

reg [15:0]Cinput;
wire [15:0]Aoutput;
reg [3:0] Aaddrmem,Caddrmem; // memeory address
// generate the clock

initial
 clock=1'b0;
always
 #5 clock=~clock;
initial
 #100 $finish;


// call the modules
control My_controller(regdes,branch,memred,memtoreg,aluop,memwr,alusrc,regwr,jump,opcode); // update the control lines
register Myregfile1(A,B,C,Caddr,Aaddr,Baddr,load,clear,clock);// get the output from register file
// give that input to the ALU and update the above output wires
arithmatic res1(set_on_less,Comparison,Overflow,C_out,result,A,B,C_in,control,aluop); // call to the arithmatic model which is doing all arithmatic compitations
Register_memory mem1(Aoutput,Cinput,Caddrmem,Aaddrmem,load,clear,clock);
//mem_to_reg mem2reg(A,B,Aoutput,Caddr,Aaddr,Baddr,load,clear,clock,memtoreg);// move the date again into the regiater file accordimg to the memtoreg bit
     
      
initial
begin
// for register file
load=1'b1;  // load the register file with inputs
clear=1'b0;  // not clear initiate

C_in=16'b1;  // unsign addtion with carray bit=0
opcode=4'b0000;
control=opcode[2:0];
// update the register file with fillowing addresses
#5 Caddr <=4'b0001;
#5 C <=16'b0100101111000101;

#5 Caddr <=4'b0010;
#5 C <=16'b0100101111000111;


#15 load=0;  // load signal is closed and get the output form the register file
    Aaddr=4'b0010;
    Baddr=4'b0001;

#15  $display("result :%b,comparison :%b \n",result,Comparison);// display the output of AND
    load=1'b1;
    Cinput=result;
    Caddrmem=4'b0111;
  
    Aaddrmem=Caddrmem;
//#22 $display("the output from memeory :%b", Aoutput);
//    Caddr <=4'b0110;

 opcode=4'b0001; 
 control=opcode[2:0];   
#4  $display("result :%b ,comparison :%b \n",result,Comparison); // display the output of OR 


 opcode=4'b0010;
 control=opcode[2:0];   
#4  $display("result :%b ,overflow :%b,carry out: %b,comparison :%b \n",result,Overflow,C_out,Comparison); // display the output of ADD 

 opcode=4'b0011;
 control=opcode[2:0];   
#4  $display("result :%b ,overflow :%b,carry out: %b,comparison :%b \n",result,Overflow,C_out,Comparison); // display the output of SUBTRACT 

   
 opcode=4'b0111; 
 control=opcode[2:0];  
#4  $display("set on less than bit: %b\n", set_on_less ); // display the output of SLT







   
/*load=0;
clear=1;
#5 $display("A =%b , B= %b \n",A,B);
*/   

end


endmodule




module register(A,B,C,Caddr,Aaddr,Baddr,load,clear,clock);
input [15:0]C;  // input
input [3:0]Caddr;  // input address
input [3:0]Aaddr,Baddr;
	
input load,clear;
input clock;
	
output reg[15:0] A,B;

reg [15:0] mem [15:0]; // to implement the 
integer i;

always @(clear )
        if (clear ==1) 
            for (i=0; i<16; i=i+1) 
                begin    
                mem[i] <= 0;
	        end
	            
always @(posedge clock)
	if (load)
	begin
            mem[Caddr] <= C;
        end
	
always	
        begin
	 #1 A <= mem[Aaddr];
         #1 B <= mem[Baddr];
	end
 endmodule   


module arithmatic(slt,comp,overflow,C_out,sum,x,y,C_in,control,aluop);
input [15:0]x,y;
input C_in;
input [2:0]control;
input aluop; // if this is one alu should work

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


always @(control,x,y,C_in,comp,aluop)  // depends always only control
begin
if(aluop==1'b1)begin
 if(control==3'b010)
	assign{C_out,sum}=x+y;  // unsign addition


 if(control==3'b011)    // sign addition
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


module control(regdes,branch,memred,memtoreg,aluop,memwr,alusrc,regwr,jump,code);

input [3:0] code;
output reg regdes,branch,memred,memtoreg,aluop,memwr,alusrc,regwr,jump;

// initialy gives all wires as zero
// regdes ,alusrc and memtoreg gives its defalut value (0,1 or x)


// use the case method to get the relavent result
always @(code)
begin

assign branch    = 1'b0;
assign memred    = 1'b0;
assign aluop     = 1'b0;
assign memwr     = 1'b0;
assign regwr     = 1'b0;
assign jump      = 1'b0;

// these are R-type instructions
   // 1. AND
 if(code==4'b0000) begin
       assign regdes  =1'b1;
       assign aluop   =1'b1;
       assign regwr   =1'b1;
       assign memtoreg=1'b0;
       assign alusrc  =1'b0;
    end
   // 2. OR
 else if(code==4'b0001) begin 
	    
       assign regdes  =1'b1;
       assign  aluop   =1'b1;
       assign regwr   =1'b1;
       assign memtoreg=1'b0;
    end
   // 3. ADD
 else if(code==4'b0010) begin
	    
       assign regdes  =1'b1;
       assign  aluop   =1'b1;
       assign regwr   =1'b1;
       assign memtoreg=1'b0;
    end
    
   // 4. SUBTRACT
 else if(code==4'b0011)begin  
	    
       assign regdes  =1'b1;
       assign  aluop   =1'b1;
       assign regwr   =1'b1;
       assign memtoreg=1'b0;
    end
   // 5. SLT
 else if(code==4'b0111)begin 
	    
       assign  regdes  =1'b1;
       assign  aluop   =1'b1;
       assign regwr   =1'b1;
       assign memtoreg =1'b0;
    end
    
   // LOAD
  else if(code==4'b0101) begin
	
       assign regdes    = 1'b0;   
       assign  memred   = 1'b1;
       assign memtoreg = 1'b1;
       assign memwr    = 1'b1;
       assign alusrc   = 1'b1;
       assign regwr    = 1'b1;
       assign memtoreg =1'b0;
    end
   
    // STORE
   else if(code==4'b0110)  begin
	
       assign memwr  = 1'b1;
       assign alusrc = 1'b1;
    end
   // BRANCH
   else if(code==4'b0100)begin 
	
       assign branch  = 1'b0;
       assign aluop   = 1'b0; 
       assign  alusrc  = 1'b0;
    end   
        
    else
    // JUMP
       assign jump    = 1'b0;  
        
    end
endmodule



module Register_memory(A,C,Caddr,Aaddr,load,clear,clock);
	input [15:0]C;
	input [3:0]Caddr; // get the input address
	input [3:0]Aaddr;  // get the output address
	
	input load,clear;
	input clock;
	
	output reg[15:0] A;
     //to take the memory for the input data 
    reg [15:0] mem [15:0];
    integer i;
     // implement the clear
    always @(clear)
        if (clear ==1) 
            for (i=0; i<16; i=i+1) 
                begin    
                mem[i] <= 0;
	        end
	          

	always @(posedge clock)
		if (load)
		begin
            mem[Caddr] <= C; // load the data (from the alu out) into the memory file
        end
	
    always	
		begin
		#1 A <= mem[Aaddr];  // according to the relevent output adddress out the data form the memory file
		end
 endmodule   


/*
module mem_to_reg (A,B,Aoutput,Caddr,Aaddr,Baddr,load,clear,clock,memtoreg);
  input memtoreg,clock,clear,load,Baddr,Aaddr,Caddr,Aoutput;
  output A,B;
  if (memtoreg==1'b1)begin   
  register Myregfile2(A,B,Aoutput,Caddr,Aaddr,Baddr,load,clear,clock); // again write  the register
  end
endmodule
*/





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
