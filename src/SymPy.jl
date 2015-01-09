module SymPy

using PyCall
@pyimport sympy

## These are temporary. Jewel is in plot.jl. Docile is for @doc macro
using Jewel
if VERSION < v"0.4.0-dev"
    using Docile
end

import Base.getindex
import Base: show, writemime
import Base.convert, Base.complex
import Base: sin, cos, tan, sinh, cosh, tanh, asin, acos,
       atan, asinh, acosh, atanh, sec, csc, cot, asec,
       acsc, acot, sech, csch, coth, asech, acsch, acoth,
       sinc, cosc, cosd, cotd, cscd, secd, sind, tand,
       acosd, acotd, acscd, asecd, asind, atand, atan2,
       radians2degrees, degrees2radians, log, log2,
       log10, log1p, exponent, exp, exp2, expm1, cbrt, sqrt,
       erf, erfc, erfcx, erfi, dawson, ceil, floor,
       trunc, round, significand,
       abs, max, min, maximum, minimum,
       sign, dot,
       besseli, besselj, besselk, bessely,
       airyai, airybi,
       zero, one
import Base: transpose
import Base: factorial, gcd, lcm, isqrt
import Base: gamma, beta
import Base: length,  size
import Base: factor, expand, collect
import Base: !=, ==
import Base:  LinAlg.det, LinAlg.inv, LinAlg.conj,
              cross, eigvals, eigvecs, rref, trace, norm
import Base: promote_rule
import Base: match, replace, round
import Base: ^, .^
import Base: &, |, !, >, >=, ==, <=, <
## poly.jl
import Base: div
import Base: trunc
import Base: isinf, isnan
import Base: real, imag

export sympy, sympy_meth, object_meth, call_matrix_meth
export Sym, @sym_str, @syms, symbols
export pprint,  jprint
export SymFunction, SymMatrix,
       n,  subs,
       simplify, nsimplify, 
       expand, factor, trunc,
       collect, separate, 
       fraction,
       primitive, sqf, resultant, cancel,
       together, square,
       solve,
       limit, diff, 
       series, integrate, 
       summation,
       I, oo,
       dsolve,
#       plot,
       poly,  nroots, real_roots,
       ∨, ∧
export relation, piecewise
export members, doc, _str

export PI, E

include("types.jl")
include("utils.jl")
include("mathops.jl")
include("math.jl")
include("core.jl")
include("simplify.jl")
include("functions.jl")
include("series.jl")
include("integrate.jl")
include("assumptions.jl")
include("poly.jl")
include("matrix.jl")
include("ntheory.jl")
include("plot.jl")


## create some methods

for meth in union(core_sympy_methods,
                  simplify_sympy_meths,
                  functions_sympy_methods,
                  series_sympy_meths,
                  integrals_sympy_methods,
                  summations_sympy_methods,
                  logic_sympy_methods,
                  polynomial_sympy_methods,
                  ntheory_sympy_methods
                  )

    meth_name = string(meth)
    @eval ($meth)(ex::Sym, args...; kwargs...) = sympy_meth(symbol($meth_name), ex, args...; kwargs...)
    eval(Expr(:export, meth))
end


for meth in union(core_object_methods,
                  integrals_instance_methods,
                  summations_instance_methods,
                  polynomial_instance_methods)

    meth_name = string(meth)
    @eval ($meth)(ex::Sym, args...; kwargs...) = object_meth(ex, symbol($meth_name), args...; kwargs...)
    eval(Expr(:export, meth))
end



for prop in union(core_object_properties,
                  summations_object_properties,
                  polynomial_predicates)
    
    prop_name = string(prop)
    @eval ($prop)(ex::Sym) = ex[symbol($prop_name)]
    eval(Expr(:export, prop))
end


end
