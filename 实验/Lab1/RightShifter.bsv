import RightShifterTypes::*;
import Gates::*;

function Bit#(1) multiplexer1(Bit#(1) sel, Bit#(1) a, Bit#(1) b);
	// Part 1: Re-implement this function using the gates found in the Gates.bsv file
    return orGate(andGate(a,notGate(sel)), andGate(b,sel));
	// return (sel == 0)?a:b; 
endfunction

function Bit#(32) multiplexer32(Bit#(1) sel, Bit#(32) a, Bit#(32) b);
	// Part 2: Re-implement this function using static elaboration (for-loop and multiplexer1)
    Bit#(32) aggregate = 0;
        for (Integer i = 0; i < 8; i=i+1)
            begin
                aggregate[i] = multiplexer1(sel, a[i], b[i]);
            end
    return aggregate;
	//return (sel == 0)?a:b; 
endfunction

function Bit#(n) multiplexerN(Bit#(1) sel, Bit#(n) a, Bit#(n) b);
	// Part 3: Re-implement this function as a polymorphic function using static elaboration
    // return (sel == 0)?a:b;
    Bit#(n) aggregate = 0;
    for (Integer i = 0; i < valueOf(n); i = i+1)
        begin
            aggregate[i] = multiplexer1(sel, a[i], b[i]);
        end
    return aggregate;
endfunction

function Bit#(n) fill(Bit#(1) sign, Integer num);
    Bit#(n) result = 0;
    for (Integer i = 0; i < num; i = i+1)
        begin
            result[i] = sign;
        end
    return result;
endfunction

module mkRightShifter (RightShifter);
    method Bit#(32) shift(ShiftMode mode, Bit#(32) operand, Bit#(5) shamt);
	// Parts 4 and 5: Implement this function with the multiplexers you implemented
        // Bit#(32) result = 0;
        // if (mode == LogicalRightShift) begin
        //    result = operand >> shamt;
        // end

        // if(mode == ArithmeticRightShift) 
        // begin
	    // Int#(32) signedOperand = unpack(operand);
        //     result = pack(signedOperand >> shamt);
        // end
        // return result;

        Bit#(32) result = 0;
        Bit#(1) flag = 0;
        Bit#(1) sign_bit = operand[31];
        if (mode == ArithmeticRightShift) begin
            flag = 1;
        end
        let fill_bit = multiplexerN(flag, 0, sign_bit);
        result = multiplexerN(shamt[0], operand, {fill(fill_bit, 1), operand[31:1]});
        result = multiplexerN(shamt[1], result, {fill(fill_bit, 2), operand[31:2]});
        result = multiplexerN(shamt[2], result, {fill(fill_bit, 4), operand[31:4]});
        result = multiplexerN(shamt[3], result, {fill(fill_bit, 8), operand[31:8]});
        result = multiplexerN(shamt[4], result, {fill(fill_bit, 16), operand[31:16]});
        return result;
    endmethod
endmodule

