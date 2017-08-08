// Title : Verilog lab1-02
// Author : E/13/200


module Testbench;

reg I0,I1;
reg con;
 wire s1,s2,s3,s4;  // outputs
 

demux2to4 mydmux(s1,s2,s3,s4,I0,I1,con); 
// Stimulate the inputs

initial
begin

I0=0;I1=0;con=0;
#1 $display("I0=%b,I1=%b,con=%b,s1=%b,s2=%b,s3=%b,s4=%b \n",I0,I1,con,s1,s2,s3,s4);

I0=0;I1=0;con=1;
#1 $display("I0=%b,I1=%b,con=%b,s1=%b,s2=%b,s3=%b,s4=%b \n",I0,I1,con,s1,s2,s3,s4);

I0=0;I1=1;con=0;
#1 $display("I0=%b,I1=%b,con=%b,s1=%b,s2=%b,s3=%b,s4=%b \n",I0,I1,con,s1,s2,s3,s4);

I0=0;I1=0;con=1;
#1 $display("I0=%b,I1=%b,con=%b,s1=%b,s2=%b,s3=%b,s4=%b \n",I0,I1,con,s1,s2,s3,s4);

I0=1;I1=0;con=0;
#1 $display("I0=%b,I1=%b,con=%b,s1=%b,s2=%b,s3=%b,s4=%b \n",I0,I1,con,s1,s2,s3,s4);

I0=1;I1=0;con=1;
#1 $display("I0=%b,I1=%b,con=%b,s1=%b,s2=%b,s3=%b,s4=%b \n",I0,I1,con,s1,s2,s3,s4);

I0=1;I1=1;con=0;
#1 $display("I0=%b,I1=%b,con=%b,s1=%b,s2=%b,s3=%b,s4=%b \n",I0,I1,con,s1,s2,s3,s4);

I0=1;I1=1;con=1;
#1 $display("I0=%b,I1=%b,con=%b,s1=%b,s2=%b,s3=%b,s4=%b \n",I0,I1,con,s1,s2,s3,s4);


end


endmodule




// module for the DMUX

module demux2to4(s0,s1,s2,s3,i0,i1,a);

input i0,i1;
input a;
output s0,s1,s2,s3;
// temporery register to behavioral modelling
reg temp1=0;
reg temp2=0;
reg temp3=0;
reg temp4=0; // to store the internal states and initiate to zer0

always @(i0,i1,a)
begin
if (i0==1'b0 && i1==1'b0 && a==1)
     temp1=1;
else if (i0==1'b1 && i1==1'b0 && a==1)
     temp2=1;
else if (i0==1'b0 && i1==1'b1 && a==1)
     temp3=1;
else if (i0==1'b1 && i1==1'b1 && a==1)
     temp4=1;
else temp1=0;
     temp2=0;
     temp3=0;
     temp4=0;
end
      
 assign s0=temp1;
 assign s1=temp2;
 assign s2=temp3;
 assign s3=temp4;

endmodule  

