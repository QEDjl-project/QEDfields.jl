# TODO:
# - consider extenting the interface for quadrature rules (e.g. order(::AbstractQuadratureMethod),...)

"""

    GaussLegendreQuadrature(order)

Integration method using Gauss-Legendre nodes provided by `FastGaussQuadrature.jl`
"""
struct GaussLegendreQuadrature{P, W} <: AbstractQuadratureMethod
    order::Int
    nodes::P
    weights::W

    function GaussLegendreQuadrature(order::Int; dtype = nothing)

        x, w = gausslegendre(order)
        #x, w = legendre(order)
        if dtype != nothing
            x = convert(Vector{dtype}, x)
            w = convert(Vector{dtype}, w)
        end
        return new{typeof(x), typeof(w)}(order, x, w)
    end
end
function Base.show(io::IO, method::GaussLegendreQuadrature)
    return print(io, "GaussLegendreQuadrature(order = $(method.order))")
end
function quadrature_nodes(method::GaussLegendreQuadrature, low, high)
    slope = (high - low) / 2
    shift = (low + high) / 2
    return @. slope * method.nodes + shift
end

function quadrature_weights(method::GaussLegendreQuadrature, low, high)
    fac = (high - low) / 2
    return @. fac * method.weights
end

function integrate(meth::GaussLegendreQuadrature, func::Function, low::Real, high::Real)
    n = quadrature_nodes(meth, low, high)
    w = quadrature_weights(meth, low, high)
    return LinearAlgebra.dot(w, func.(n))
end
