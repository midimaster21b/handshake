// This testbench is one of the most basic testcases with the slave always
// being ready and the master sending simple data.
module handshake_8bit_always_ready_tb;

   logic clk  = 0;
   logic rstn = 0;

   logic valid;
   logic ready;
   logic [31:0] data;

   handshake_if #(.DATA_BITS(8)) conn(.clk(clk), .arstn(rstn));

   assign valid = conn.valid;
   assign ready = conn.ready;
   assign data  = conn.data;

   ////////////////////////////////////////////
   // Stimulus
   ////////////////////////////////////////////
   initial begin
      wait(rstn == '1);
      @(posedge clk);

      dut_master.put_simple_beat(8'hA5);
      dut_master.put_simple_beat(8'hC4);
   end


   ////////////////////////////////////////////
   // Testbench basics
   ////////////////////////////////////////////
   // Clock signal control
   always #5 clk = ~clk;

   // Deassert reset signal
   initial #105 rstn = 1'b1;

   initial begin
      #1ms;

      $display("============================");
      $display("======= TEST TIMEOUT =======");
      $display("============================");
      $finish;
   end

   handshake_master dut_master(conn);
   handshake_slave  #(.ALWAYS_READY(1)) dut_slave(conn);
endmodule // handshake_8bit_always_ready_tb
