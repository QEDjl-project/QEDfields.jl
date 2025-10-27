### non-linear Volkov phase

function _volkov_phase(
        field::AbstractBackgroundField{<:AbstractDefinitePolarization},
        method::AbstractIntegrationMethod,
        phi::Real,
        beta1::Real,
        beta2::Real
    )

    max_amp = maximum_amplitude(field)

    ii = _internal_integrals(field, method, phi)

    # "-" comes from eps_BG*eps_BG
    return max_amp * beta1 * ii.I1 - max_amp^2 * beta2 * ii.I2
end

function volkov_phase(
        field::AbstractPlaneWaveField,
        method::AbstractIntegrationMethod,
        phi::T,
        beta1::T,
        beta2::T
    )::T where {T <: Real}

    dom = domain(field)

    if phi in dom
        res = _volkov_phase(field, method, phi, beta1, beta2)
    else
        res = phi <= minimum(dom) ? _volkov_phase(field, method, minimum(dom), beta1, beta2) : _volkov_phase(field, method, maximum(dom), beta1, beta2)
    end

    return res
end

function _volkov_phase(
        field::AbstractBackgroundField{AbstractIndefinitePolarization},
        method::AbstractIntegrationMethod,
        phi::Real,
        beta11::Real,
        beta12::Real,
        beta2::Real
    )
    # add volkov phase for indefinite polarization

end
