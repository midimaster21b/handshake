interface handshake_if #(parameter
			 DATA_BITS=8
			 ) (input clk, rst);

   logic [(DATA_BITS-1):0] data;
   logic                   valid;
   logic                   ready;

   modport master (input  ready,
		   output valid, data);

   modport slave  (output ready,
		   input  valid, data);

endinterface // handshake_if
