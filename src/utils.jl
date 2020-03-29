const TRAN = GrB_Descriptor()
GrB_Descriptor_new(TRAN)
GrB_Descriptor_set(TRAN, GrB_INP0, GrB_TRAN)
GrB_Descriptor_set(TRAN, GrB_INP1, GrB_TRAN)

const int_div = (a, b) -> if a == 0 || b == 0 0 else a ÷ b end

@inline function DIV(T)
    DIV_OP = GrB_BinaryOp()
    GrB_BinaryOp_new(DIV_OP, int_div, GrB_type(T), GrB_type(T), GrB_type(T))
    return DIV_OP
end

const db2 = x -> x÷2

@inline function DIV_BY_TWO(T)
    DIV_BY_TWO_OP = GrB_UnaryOp()
    GrB_UnaryOp_new(DIV_BY_TWO_OP, db2, GrB_type(T), GrB_type(T))
    return DIV_BY_TWO_OP
end

function __type_suffix(T::DataType)
    if T == Bool
        return "BOOL"
    elseif T == Int8
        return "INT8"
    elseif T == UInt8
        return "UINT8"
    elseif T == Int16
        return "INT16"
    elseif T == UInt16
        return "UINT16"
    elseif T == Int32
        return "INT32"
    elseif T == UInt32
        return "UINT32"
    elseif T == Int64
        return "INT64"
    elseif T == UInt64
        return "UINT64"
    elseif  T == Float32
        return "FP32"
    end
    return "FP64"
end

@inline function GrB_type(T)
    return eval(Symbol("GrB_", __type_suffix(T)))
end

@inline function GrB_op(fun_name, T)
    return eval(Symbol("GrB_", fun_name, "_", __type_suffix(T)))
end

@inline function GxB_op(fun_name, T)
    return eval(Symbol("GxB_", fun_name, "_", __type_suffix(T)))
end

@inline function GxB_monoid(fun_name, T)
    return eval(Symbol("GxB_", fun_name, "_", __type_suffix(T), "_MONOID"))
end
