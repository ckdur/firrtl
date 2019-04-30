;buildInfoPackage: chisel3, version: 3.1.7, scalaVersion: 2.11.12, sbtVersion: 1.1.1, builtAtString: 2019-03-20 22:15:13.399, builtAtMillis: 1553120113399
circuit arbiter : 
  module arbiter : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip i_a_req : UInt<1>, flip i_a_data : UInt<1>, o_a_busy : UInt<1>, flip i_b_req : UInt<1>, flip i_b_data : UInt<1>, o_b_busy : UInt<1>, o_req : UInt<1>, o_data : UInt<1>, flip i_busy : UInt<1>}
    
    reg a_is_the_owner : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[arbiter.scala 29:31]
    node _T_26 = eq(io.i_b_req, UInt<1>("h00")) @[arbiter.scala 30:23]
    node _T_27 = and(io.i_a_req, _T_26) @[arbiter.scala 30:20]
    when _T_27 : @[arbiter.scala 30:37]
      a_is_the_owner <= UInt<1>("h01") @[arbiter.scala 31:20]
      skip @[arbiter.scala 30:37]
    else : @[arbiter.scala 32:44]
      node _T_30 = eq(io.i_a_req, UInt<1>("h00")) @[arbiter.scala 32:30]
      node _T_31 = and(io.i_b_req, _T_30) @[arbiter.scala 32:27]
      when _T_31 : @[arbiter.scala 32:44]
        a_is_the_owner <= UInt<1>("h00") @[arbiter.scala 33:20]
        skip @[arbiter.scala 32:44]
    node _T_34 = eq(a_is_the_owner, UInt<1>("h00")) @[arbiter.scala 36:19]
    node _T_35 = or(_T_34, io.i_busy) @[arbiter.scala 36:35]
    io.o_a_busy <= _T_35 @[arbiter.scala 36:15]
    node _T_36 = or(a_is_the_owner, io.i_busy) @[arbiter.scala 37:35]
    io.o_b_busy <= _T_36 @[arbiter.scala 37:15]
    node _T_37 = mux(a_is_the_owner, io.i_a_req, io.i_b_req) @[arbiter.scala 38:18]
    io.o_req <= _T_37 @[arbiter.scala 38:12]
    node _T_38 = mux(a_is_the_owner, io.i_a_data, io.i_b_data) @[arbiter.scala 39:19]
    io.o_data <= _T_38 @[arbiter.scala 39:13]
    
    ; FORMAL CONSTRUCTS (Manually inserted)
    
    ; The past valid. This is just a register with specific initialization
    reg f_past_valid : UInt<1>, clock
    init f_past_valid : UInt<1>("h00")
    f_past_valid <= UInt<1>("h01")
    
    ; The past indicator. Enables the $past in verilog
    reg past_reset : UInt<1>, global_clock()
    past_reset <= past(reset, 1)

    printf(clock, UInt<1>("h01"), "f_past_valid: %x, past_reset: %x\n", f_past_valid, past_reset)
    ; The assume and reset indicators.
    node _T_41 = and(f_past_valid, past_reset)
    node _T_42 = not(io.i_busy)
    node _T_43 = not(io.i_a_req)
    node _T_44 = not(io.i_b_req)
    node _T_45 = not(io.o_req)
    when _T_41:
      assert(_T_42)
      assert(_T_43)
      assert(_T_44)
      assume(_T_45)
      cover(_T_45)

