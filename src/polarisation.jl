#################
# polarisation vectors
# 
# In this file, we provide an extension of the Polarisations of Photons from
# QEDbase to define polarisation states of background fields
################
#
# TODO:
#   * write doc strings
#   * implement elliptical/circular polarisation

@inline polarisation_vector(pol::AbstractDefinitePolarization, mom) = base_state(Photon(),Incoming(), mom, pol)

@inline _oscillator(::PolX, x) = cos(x)
@inline _oscillator(::PolY, x) = sin(x)  
@inline function _oscillator(::AbstractIndefinitePolarization,x) 
    sincos_res = sincos(x)
    @inbounds cossin_res = (sincos_res[2], sincos_res[1])
    return cossin_res
end

