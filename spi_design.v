module spi_design(sdio,sclk,sen,reset);
input sclk,sen,reset;
inout sdio;
integer count=0;           // for count posedge clock
integer i=0;               // count negedge to read data from slave
reg [7:0] memory[4095:0];  // 4096 location each have 8 bit space
reg [23:0]shift_reg=0;     // for stroring incoming data 
reg rd=1'b0;               //showing read data from master
reg [11:0] address=0;      //for showing which address to store 8 bit
reg [7:0]data;	           //which data will be store 
reg sdio_out=0;            // for read data we use because sdio is wire and it is not use in always block

always @(posedge sclk,posedge reset)
begin

 if(reset) begin                      //if reset is coming then reset all 
    count <= 0;
    shift_reg <= 0;
    data<=0;
    address<=0;
    i<=0;
  end

else if(sen) count<=0;                 //if sen is high then slave is not working

else if(count<=15) 
 begin
  shift_reg[count]<=sdio;               //store incoming bit into shift_reg upto 15 bit 
  count<=count+1;
  if(count==15 && shift_reg[0])         // for decide rd or write operation
  rd<=1;
 end

else if(count<=23 && (~shift_reg[0]))  // if write detect then data is coming from master
 begin  
  rd<=0;
  shift_reg[count]<=sdio;
  count<=count+1;
 end

else if(count<=23) begin       // if read detect then data is store from address which is already coming through master
 shift_reg[count]<=sdio;
 count<=count+1;
 end
 
else begin                     // end of operation all is set to zero
 count<=0;
 shift_reg<=0;
 data<=0;
 address<=0;
 i<=0;
end     
end

always @(posedge sclk)           // parallely that bit store in address or data variable
begin
 if(count>3 && count<16)         //for address store 
  address[15-count]<=sdio;
 if(count>15 && count<24)        // for data store
  data[23-count]<=sdio;
 if(count==24)             
 memory[address]<=data;          // after coming all bit data will be store in address which is give by master 
end

assign sdio=rd?sdio_out:1'bz;    //sdio_out is reg varible for give value to sdio wire variabe which using continuous assign 

always @(negedge sclk)           // if read operation is detect then we need to transfer data to master at negedge
begin
if(rd && i<8) begin              
 sdio_out<=memory[address][7-i]; //sdio_out is extra reg variable to take 8 bit data from memory at every negedge
 i<=i+1;
end
end
endmodule


 

 


  
 
 



