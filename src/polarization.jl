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

@inline polarization_vector(pol::AbstractDefinitePolarization, mom) = base_state(Photon(),Incoming(), mom, pol)

@inline oscillator(::PolX, x) = cos(x)
@inline oscillator(::PolY, x) = sin(x)  
@inline function oscillator(::AbstractIndefinitePolarization,x) 
    sincos_res = sincos(x)
    @inbounds cossin_res = (sincos_res[2], sincos_res[1])
    return cossin_res
end

