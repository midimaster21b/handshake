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

   always #10 clk = ~clk;

   initial begin
      #500ns;

      dut_master.put_simple_beat(8'hA1);
      dut_master.put_simple_beat(8'hB2);
      #100ns;
      dut_master.put_simple_beat(8'hC3);
      @(posedge clk)
      @(posedge clk)
      @(posedge clk)
      @(posedge clk)
      dut_master.put_simple_beat(8'hD4);
      #100ns;
      dut_master.put_simple_beat(8'hAB);
      dut_master.put_simple_beat(8'hCD);
      dut_master.put_simple_beat(8'hEF);
      dut_master.put_simple_beat(8'h12);

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
