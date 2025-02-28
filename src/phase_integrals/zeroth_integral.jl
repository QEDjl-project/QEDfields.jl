#######################
# Zeroth phase integral
#######################

# Is actually diverging, therefore not implmented by now.
function phase_integral_0 end
# The expected signature would be
#phase_integral_0(
#    field::AbstractPulsedPlaneWaveField,
#    pol::AbstractPolarization,
#    p_in::T,
#    p_out::T,
#    pnum::T
#) where {T<:Real}
# and the questions remains, whether T has to be the same for all arguments.


# Implementation of above function for a vector of photon numbers
#function phase_integral_0(
#    field::AbstractPulsedPlaneWaveField,
#    pol::AbstractPolarization,
#    p_in::T,
#    p_out::T,
#    photon_number_parameter::AbstractVector{T}
#) where {T<:Real}
#    # TODO: maybe use broadcasting here
#    return map(x -> phase_integral_0(field, pol, p_in, p_out, x), photon_number_parameter)
#end
