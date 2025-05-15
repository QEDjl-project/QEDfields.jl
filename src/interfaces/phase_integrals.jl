####################
# The abstract phase integral interface
#
# In this file, the abstract interface for different computation methods of
# phase integrals is defined.
####################
"""
Abstract base type for defining a method for phase integral computation.
"""
abstract type ComputeMethod end

"""
Analytic method for phase integral computation.

Requires an existing implementation of analytic formulas for computing the
entities in the phase integrals.
"""
struct Analytic <: ComputeMethod end

"""
Fully numerical method for phase integral computation.
"""
struct Numeric <: ComputeMethod end

"""
Struct holding setup specific information to compute phase integrals.

ToDo: We mix physical and numerical aspects in this class.
This does not seem ideal to me (Klaus).
"""
struct PhaseIntegral{F<:AbstractBackgroundField, C<:ComputeMethod}
    bgfield::F
    method::C

    function PhaseIntegral(bgfield::F, method::C) where {F<:AbstractBackgroundField, C<:ComputeMethod}
        _assert_compatibility(bgfield, method)
        new(bgfield, method)
end


"""

    _assert_compatibility(::AbstractBackgroundField, ::ComputeMethod)

Interface function enforcing essential error check whether the respective functions exist that compute the phase integrals of the provided background field by the required method.
This function represents the default case stating that compute method and background field are not compatible.

It must be specialized for compatible types as
    _assert_compatibility(::CompatibleField, ::CompatibleComputeMethod) = nothing
"""
function _assert_compatibility(<:AbstractBackgroundField, <:ComputeMethod)
    throw(ArgumentError("phase integral of provided background field cannot be computed with required method!"))
end


"""

    compute(pi::PhaseIntegral, vi::VertexInput)

Interface function for [`PhaseIntegral`](@ref), which returns the result of the computation.

Need to be specialized? I need to check on what the computation of phase integrals actually depends.
"""
function compute end


"""
Interface function returning background field.
All interface functions of background field, e.g. [`reference_momentum()`](@ref) can then be called on it.
"""
background_field(pi::PhaseIntegral) = pi.bgfield


"""
Composite type providing all (kinematic) information, required for dressed vertex computation and physe integral computation further down the line, via interface functions

TODO: Should pnum become an explicit dependence of compute(pi, vi) in order to not construct a new VertexInput for every l, which is probably very slow. Because in the end we want to integrate the dressed vertex function Gamma^\mu over pnum.
"""
struct VertexInput{M<:QEDbase.AbstractFourMomentum,T<:Real}
    pin::M
    pout::M
    pnum::T
end


"""
Interface functions of VertexInput
"""
in_momentum(vi::VertexInput) = vi.pin
out_momentum(vi::VertexInput) = vi.pout
photon_number_parameter(vi::VertexInput) = vi.pnum



# TODO: The follwing is old stuff from 2024 and should be removed if not required in the implementation started in May 2025
# phase integrals B_i(l)
#
# TODO: Up to now, all of this is just copy paste and needs to be adapted to phase integrals
"""

    computeB1(ph_int_stp::PhaseIntegral, pol::AbstractPolarization, a0, pnum, alpha1x, alpha1y, alpha2)

Return the first phase integral for the given setup `ph_Int_stp`, background field strength `a0`, photon number parameter `pnum`, components of the kinematic vector factor ``\\alpha_1^\\mu``, and kinematic scalar factor ``\\alpha_2``.

!!! note "Convention"

    The first phase integral is defined as:

    ```math
    \\begin{align*}
        B_1^\\mu(l, p, p^\\prime)& = \\int \\mathrm{d}\\varphi A^\\mu(\\varphi)\\exp[\\imath l \\varphi + \\imath G(\\varphi)] \\\\
    \\end{align*}
    ```
    where ``A^\\mu(\\varphi)`` is the background field, ``G(\\varphi,p, p^\\prime)`` is the [`phase function`](@ref), ``(p,p^\\prime)`` the given phase space point, and ``l`` the photon number parameter.
"""
function computeB1 end

# TODO: REWORK THE FOLLOWING DOCUMENTATION
"""

    computeB2()

Return the second phase integral.

!!! note "Convention"

    The second phase integral is defined as:

    ```math
    \\begin{align*}
        B_2(l, p, p^\\prime)& = \\int \\mathrm{d}\\varphi A(\\varphi)^2 \\exp[\\imath l \\varphi + \\imath G(\\varphi)] \\\\
    \\end{align*}
    ```
"""
function computeB2 end
