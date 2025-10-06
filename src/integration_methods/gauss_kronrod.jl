# TODO:
# - pass kwargs to GaussKronrodQuadrature type
# - consider extenting the interface for quadrature rules (e.g. order(::AbstractQuadratureMethod),...)

"""

    GaussKronrodQuadrature()

Integration method using `QuadGK.quadgk`.
"""
struct GaussKronrodQuadrature <: AbstractQuadratureMethod end

function integrate(meth::GaussKronrodQuadrature, func::Function, low::Real, high::Real)
    res, _ = quadgk(func, low, high)
    return res
end
