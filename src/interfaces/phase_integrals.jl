####################
# The abstract phase integral interface
#
# In this file, the abstract interface for different copmutation methods of
# phase integrals is defined.
####################
"""
Abstract base type for defining a method for phase integral computation.
"""
abstract type Method end

"""
Analytic method for phase integral computation.

Requires an existing implementation of analytic formulas for computing the
entities in the phase integrals.
"""
struct Analytic <: Method end

"""
Fully numerical method for phase integral computation based on QuadGK.
"""
struct QuadGK <: Method end

"""
Struct holding setup specific information to compute phase integrals.

ToDo: We mix physical and numerical aspects in this class.
This does not seem ideal to me (Klaus).
"""
struct PhaseIntegral{P<:AbstractPulsedPlaneWaveField, M<:Method}
    pulse::P
    method::M
end

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
