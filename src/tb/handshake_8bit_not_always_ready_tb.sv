// This testbench is one of the slightly difficult test cases with a slave that
// is not always ready and the master is sending simple data.
module handshake_8bit_not_always_ready_tb;

   logic clk  = 0;
   logic rst  = 0;

   logic valid;
   logic ready;
   logic [31:0] data;

   handshake_if #(.DATA_BITS(8)) connector(.clk(clk), .rst(rst));

   assign valid = connector.valid;
   assign ready = connector.ready;
   assign data  = connector.data;

   initial begin
      #1us;

      dut_master.put_simple_beat(8'hA5);
      dut_master.put_simple_beat(8'hC4);
   end


   initial begin
      forever begin
	 #10 clk = ~clk;
      end
   end


   initial begin
      #1ms;

      $display("============================");
      $display("======= TEST TIMEOUT =======");
      $display("============================");
      $finish;
   end


   handshake_master dut_master(connector);
   handshake_slave  #(.ALWAYS_READY(0)) dut_slave(connector);
endmodule // handshake_8bit_not_always_ready_tb
