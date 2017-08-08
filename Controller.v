
module Tes;

reg [3:0] opcode;
wire regdes,branch,memred,memtoreg,aluop,memwr,alusrc,regwr,jump;

control My_controller(regdes,branch,memred,memtoreg,aluop,memwr,alusrc,regwr,jump,opcode);

initial
begin

  // declare the inputs(data from register) opcode
  opcode = 4'b0000;	// AND opration
  #5 $display("opcode = %b => regdes= %b, branch= %b, memred= %b, memtoreg =%b,ALUop =%b, memwr=%b, ALUsrc=%b ,regwr =%b,jump=%b\n",opcode,regdes,branch,memred,memtoreg,aluop,memwr,alusrc,regwr,jump );
 
  
end

endmodule





module control(regdes,branch,memred,memtoreg,aluop,memwr,alusrc,regwr,jump,code);


output reg regdes,branch,memred,memtoreg,aluop,memwr,alusrc,regwr,jump;

input [3:0] code;


begin
// initialy gives all wires as zero
// regdes ,alusrc and memtoreg gives its defalut value (0,1 or x)

branch    <= 1'b0;
memred    <= 1'b0;
aluop     <= 1'b0;
memwr     <= 1'b0;
regwr     <= 1'b0;
jump      <= 1'b0;

// use the case method to get the relavent result
case (code)

// these are R-type instructions
   // 1. AND
  4'b0000 : begin
        regdes  <=1'b1;
        aluop   <=1'b1;
	regwr   <=1'b1;
        memtoreg<=1'b0;
        alusrc  <=1'b0;
    end
   // 2. OR
  4'b0001 : begin 
	    
        regdes  <=1'b1;
        aluop   <=1'b1;
	regwr   <=1'b1;
	memtoreg<=1'b0;
    end
   // 3. ADD
  4'b0010 : begin 
	    
        regdes  <=1'b1;
        aluop   <=1'b1;
	regwr   <=1'b1;
	memtoreg<=1'b0;
    end
   // 4. LOAD
  4'b0011 : begin 
	    
        regdes  <=1'b1;
        aluop   <=1'b1;
	regwr   <=1'b1;
	memtoreg<=1'b0;
    end
   // 5. SLT
  4'b0100 : begin 
	    
        regdes  <=1'b1;
        aluop   <=1'b1;
	regwr   <=1'b1;
	memtoreg<=1'b0;
    end
   // LOAD
  4'b0101 : begin 
	
	regdes    <= 1'b0;   
        memred   <= 1'b1;
	memtoreg <= 1'b1;
	memwr    <= 1'b1;
	alusrc   <= 1'b1;
	regwr    <= 1'b1;
	memtoreg <=1'b0;
    end
    // STORE
   4'b0110 : begin 
	
	memwr  <= 1'b1;
 	alusrc <= 1'b1;
    end
   // BRANCH
   4'b0111 : begin 
	
	branch  <= 1'b0;
	aluop   <= 1'b0; 
        alusrc  <= 1'b0;   
        
    end
    // JUMP
   4'b1000 : begin 
	
	jump    <= 1'b0;  
        
    end

  endcase

end
endmodule
