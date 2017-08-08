module memory;
reg [15:0]Cinput;
wire [15:0]Aoutput;

reg [3:0] Aaddrmem,Caddrmem;
reg load,clear,clock;

// generate the clock

initial
 clock=1'b0;
always
 #5 clock=~clock;
initial
 #100 $finish;

Register Myregfile(Aoutput,Cinput,Caddrmem,Aaddrmem,load,clear,clock);

initial
begin
load=1'b1;
clear=1'b0;

#5 Caddr <=4'b0001;
#5 C <=16'b0100101111000101;
#6 $display ("C = %b  \n",C);

#5 Caddr <=4'b0010;
#5 C <=16'b0100101111000111;
#7 $display ("C = %b  \n",C);

#15 load=0;
Aaddr=4'b0010;

   
end


endmodule




module Register(A,C,Caddr,Aaddr,load,clear,clock);
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
    always @(clear == 1)
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
