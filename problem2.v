// title : Verilog Lab-1

module MytestBench1;

	reg[7:0] IN;
	wire[7:0] OUT;
	reg clock;
    //reg reset
	
	reg S0,S1;
	reg ENABLE;
	reg Left_shift,Right_shift;
     
	// apply the clock
	initial
		clock = 1'b0;
	always
		#5 clock = ~clock;  // invert the clock
	initial
		#100 $finish;
	
    // calling to the module ShiftReg4
	ShiftReg8 shiftreg(OUT,IN,S0,S1,ENABLE,clock,Left_shift,Right_shift);
	
	initial
	begin
		//initiate the inputs
		IN=8'b01011011;
		ENABLE=1'b1;
		
		Left_shift=1'b0;
		Right_shift=1'b0;
		
		// display the input,clock and enable state
		#5 $display("Clock=%b IN= %b\n Enable= %b",clock,IN,ENABLE);
		
		// parallel loading when 
		S1 =1'b0 ;S0 =1'b0;
		#10 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n", clock,S1, S0, OUT);
		
		// shift right
		S1 =1'b0; S0 =1'b1;
		Right_shift=1'b1;
		#10 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n", clock,S1, S0, OUT);
		
		// shift left
		S1 =1'b1; S0 =1'b0;
		Left_shift=1'b1;
		#10 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n",clock, S1, S0, OUT);
		
		// hold the state not do anything it hold the value of the particuler state
		S1 =1'b1; S0 =1'b1;
		#10 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n",clock, S1, S0, OUT);
	end
	
endmodule


module ShiftReg8(OUT,In, S0, S1,enable,clock,left_shift,right_shift);

	input [7:0] In;
	input S0,S1;
        input clock,enable;
        input left_shift,right_shift;

    // output asign as the register
	output reg [7:0] OUT;
    // connecting wires to conect two 4-bit registers
	wire[3:0] least4bit=In[3:0];
	wire[3:0] most4bit=In[7:4];

	wire[3:0] least4new;
	wire[3:0] most4new;


    // take the input for 4-bit registers
	ShiftReg4 left(least4new,least4bit,S0,S1,enable,clock,left_shift,In[4]);
	ShiftReg4 right(most4new,most4bit,S0,S1,enable,clock,In[3],left_shift);

	always
		#1 OUT<={most4new,least4new};

endmodule


module ShiftReg4(out, in, s0, s1,enable,clock,left_shift,right_shift);

	
	input [3:0] in;  // get the input
	input s0,s1;
	input clock,enable;
	input left_shift,right_shift;
	
	// internal output
	output reg[3:0] out;
	//reg [3:0]temp;   // get a temporery register

	always @(posedge clock)  // always sensitive at the positive edge
	begin
		if(enable==1'b1)   // enable 1
			begin
			if (s1==1'b0 && s0==1'b0)
				out <=in; 
				
			else if (s1==1'b0 && s0==1'b1)
				//shift right using concategation method
				out <= {right_shift,out[3:1]}; 
				
			else if (s1==1'b1 && s0==1'b0)
				//shift_left using concategation method
				out <= {out[2:0],left_shift}; 

			end
			
			//assign out=temp;  // assign to the register
	end
	
endmodule

