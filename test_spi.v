module test_spi();
reg sclk,sen,count,reset;
reg sdio_test;
wire sdio;
integer k;
reg rd;
reg decide=1;
reg [7:0] memory[4095:0];
spi dut(sdio,sclk,sen,reset);

always #5 sclk=~sclk;

reg[23:0]in=24'b000010101010101110101011;
//reg[23:0]in=24'b100010101010101110101011;
assign sdio=(decide)?sdio_test:1'hz;

initial 
 begin
  decide<=1;
  //dut.memory[2731]=8'b10101011;
  sclk=1'b0;
  sen=1'b1;
  #12 sen=1'b0;
 end

initial 
 begin
  $dumpfile("spi.vcd");
  $dumpvars(0,dut);
 end

 
initial
 begin
  reset=1'b0;
  #10 reset=1'b1;
  #3 reset=1'b0;
 end
 
initial
 begin
  sdio_test<=0;
  for(k=23;k>7;k=k-1) 
  #10 sdio_test<=in[k];
   
  #8 decide<=0; 

  #90 $finish;
 end


endmodule