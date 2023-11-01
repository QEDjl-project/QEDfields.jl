#################
# polarization vectors
# 
# In this file, we provide an extension of the Polarizations of Photons from
# QEDbase to define polarization states of background fields
################
#
# TODO:
#   * write doc strings
#   * implement elliptical/circular polarisation

"""
    polarization_vector(pol::AbstractPolarization, mom::QEDbase.AbstractFourMomentum)

Return the polarisation vector for a given polarization and four-momentum `mom`.
For a definite polarisation, the respective `LorentzVector` is returned, 
where as for an indefinite polarisation, a tuple of polarisation vectors is returned.
"""
@inline function polarization_vector(pol::AbstractPolarization, mom)
    return base_state(Photon(), Incoming(), mom, pol)
end

"""

    oscillator(pol::AbstractPolarisaion, phi::Real)

Return the value of the base oscillator associated with a given polarisation `pol` at a given point `phi`.

!!! note "Convention"

    The current default implementation are 

    ```Julia
    PolX() -> cos(phi)
    PolY() -> sin(phi)
    AllPol() -> (cos(phi), sin(phi))
    ```

"""
function oscillator end

@inline oscillator(::PolX, phi) = cos(phi)
@inline oscillator(::PolY, phi) = sin(phi)
@inline function oscillator(::AbstractIndefinitePolarization, phi)
    sincos_res = sincos(phi)
    @inbounds cossin_res = (sincos_res[2], sincos_res[1])
    return cossin_res
end
