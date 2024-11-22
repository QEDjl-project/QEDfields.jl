#######################
# Second phase integral
#######################

# Does it need to be the same T for all arguments?
function phase_integral_2(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    p_in::T,
    p_out::T,
    pnum::T
) where {T<:Real}
    return quadgk(t -> , endpoints(domain(field))...)[1]
end

function phase_integral_2(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    p_in::T,
    p_out::T,
    photon_number_parameter::AbstractVector{T}
) where {T<:Real}
    # TODO: maybe use broadcasting here
    return map(x -> phase_integral_2(field, p_in, p_out, x), photon_number_parameter)
end

