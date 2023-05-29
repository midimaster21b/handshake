// TODO: Implement ALWAYS_READY=0 behavior
// TODO: Implement reset behavior
module handshake_slave #(parameter
			 ALWAYS_READY=1
			 ) (conn);
   handshake_if conn;

   typedef struct {
      logic [$bits(conn.data)-1:0] data;
   } handshake_beat_t;

   typedef mailbox		   #(handshake_beat_t) handshake_inbox_t;

   handshake_inbox_t handshake_inbox = new();

   // handshake_beat_t empty_beat = '{default: '0};
   handshake_beat_t empty_beat = '{'0};

   /**************************************************************************
    * Read a single valid beat from the bus and insert it into the mailbox.
    **************************************************************************/
   task read_beat;
      handshake_beat_t temp;

      begin
	 $timeformat(-9, 2, " ns", 20);

	 // Set ready signal
	 conn.ready <= '1;

	 while (conn.valid != '1 || conn.ready != '1) begin
	    @(posedge conn.clk);
	 end

	 // Write output beat
	 temp.data  = conn.data;

	 $display("%t: Handshake Slave - Getting Data - '%x'", $time, temp.data);
	 handshake_inbox.put(temp);

	 @(posedge conn.clk);
	 // Set ready signal
	 conn.ready <= '0;

      end
   endtask // read_beat


   /**************************************************************************
    * Get a beat from the mailbox when one is available. [Blocking]
    **************************************************************************/
   task get_beat;
      output logic [$bits(conn.data)-1:0] data;

      handshake_beat_t temp;

      begin
	 handshake_inbox.get(temp);

	 // Write output beat
	 data  = temp.data;
      end
   endtask


   initial begin
      conn.ready  = '0;
      #1;

      forever begin
	 if(ALWAYS_READY==0) begin
	    wait(conn.valid == '1);
	    @(posedge conn.clk);
	    // @(posedge conn.clk && conn.valid == '1);

	    while(conn.valid == '1) begin
	       read_beat();
	    end

	 end else begin
	    read_beat();

	 end
      end
   end

endmodule // handshake_slave_bfm
