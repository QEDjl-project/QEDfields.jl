#################
# polarization vectors
# 
# In this file, we provide an extension of the Polarizations of Photons from
# QEDbase to define polarization states of background fields
################
#
# TODO:
#   * implement elliptical/circular polarisation

"""

    polarization_vector(pol::AbstractPolarization, mom::QEDbase.AbstractFourMomentum)

Return the polarization vector for a given polarization and four-momentum `mom`.
For a definite polarization, the respective `LorentzVector` is returned, 
where as for an indefinite polarization, a tuple of polarization vectors is returned.

!!! note "Convention"

    In the current implementation, we use the `base_state` function for `Photon` provided by `QEDcore.jl`.

"""
@inline function polarization_vector(pol::QEDbase.AbstractPolarization, mom)
    return QEDbase.base_state(QEDbase.Photon(), QEDbase.Incoming(), mom, pol)
end

"""

    oscillator(pol::AbstractPolarizaion, phi::Real)

Return the value of the base oscillator associated with a given polarization `pol` at a given point `phi`.

!!! note "Convention"

    The current default implementation are 

    ```Julia
    PolX() -> cos(phi)
    PolY() -> sin(phi)
    AllPol() -> (cos(phi), sin(phi))
    ```

"""
function oscillator end

@inline oscillator(::QEDbase.PolX, phi) = cos(phi)
@inline oscillator(::QEDbase.PolY, phi) = sin(phi)
@inline function oscillator(::QEDbase.AbstractIndefinitePolarization, phi)
    sincos_res = sincos(phi)
    @inbounds cossin_res = (sincos_res[2], sincos_res[1])
    return cossin_res
end
