
// Title : Verilog Lab 01

module MytestBench;

	reg[3:0] IN;
	wire[3:0] OUT;
        wire [3:0] OUT1;
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
		#50 $finish;
	
    // calling to the module ShiftReg4
	ShiftReg4 shiftreg(OUT,IN,S0,S1,ENABLE,clock,Left_shift,Right_shift);
        ShiftReg4_1 shiftreg1(OUT1,IN,S0,S1,ENABLE,clock,Left_shift,Right_shift);
	
	initial
	begin
		//initiate the inputs
		IN=4'b0110;
		ENABLE=1'b1;
		
		Left_shift=1'b0;
		Right_shift=1'b0;
		
		// display the input,clock and enable state
		//#2 $display(" IN= %b\n Enable= %b",IN,ENABLE);
		
		// parallel loading when 
		S1 =1'b0 ;S0 =1'b0;
		 $display("Clock=%b \n", clock); 
		#5  $display("Clock=%b S1 = %b, S0 = %b, OUTPUTedge = %b \n", clock,S1, S0, OUT); 
                  //  $display("Clock=%b S1 = %b, S0 = %b, OUTPUTlevel = %b \n", clock,S1, S0, OUT1);
                #2 $display("Clock=%b S1 = %b, S0 = %b, OUTPUTedge = %b \n", clock,S1, S0, OUT);  
                #6 $display("Clock=%b S1 = %b, S0 = %b, OUTPUTlevel = %b \n", clock,S1, S0, OUT1);
		
		// shift right that the bit array in the register
		S1 =1'b0; S0 =1'b1;
		Right_shift=1'b1;
		#5 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n", clock,S1, S0, OUT);
                #6 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n", clock,S1, S0, OUT1);
                
		
		// shift left
		S1 =1'b1; S0 =1'b0;
		Left_shift=1'b1;
		#5 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n",clock, S1, S0, OUT);
                #6 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n",clock, S1, S0, OUT1);
		
		// hold the state not do anything it hold the value of the particuler state
		S1 =1'b1; S0 =1'b1;
		#5 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n",clock, S1, S0, OUT);
                #6 $display("Clock=%b S1 = %b, S0 = %b, OUTPUT = %b \n",clock, S1, S0, OUT1);

       	end
	
endmodule



module ShiftReg4(out, in, s0, s1,enable,clock,left_shift,right_shift);  // this register will work as the level trigle in the clock pulse
	
	input [3:0] in;  // get the input
	input s0,s1;
	input clock,enable;
	input left_shift,right_shift;
	
	// internal output
	output reg[3:0] out;
	//reg [3:0]temp;   // get a temporery register

	always @( posedge clock)  // always sensitive at the positive edge
	begin
		if(enable==1'b1)   // enable 1
			begin
			if (s1==1'b0 && s0==1'b0)
				out =in; 
				
			else if (s1==1'b0 && s0==1'b1)
				//shift right using concategation method
				out = {right_shift,out[3:1]}; 
				
			else if (s1==1'b1 && s0==1'b0)
				//shift_left using concategation method
				out = {out[2:0],left_shift}; 

			end
			
			//assign out=temp;  // assign to the register
	end
	
endmodule



module ShiftReg4_1(out, in, s0, s1,enable,clock,left_shift,right_shift);  // this register will work as the positive edge clock
	
	input [3:0] in;  // get the input
	input s0,s1;
	input clock,enable;
	input left_shift,right_shift;
	
	// internal output
	output reg[3:0] out;
	//reg [3:0]temp;   // get a temporery register

	always @(clock ==1)  // always sensitive at the level trigered
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