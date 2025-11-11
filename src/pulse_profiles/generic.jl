@inline function compact_domain(pulse::AbstractPulseProfile)
    return domain(pulse::AbstractPulseProfile)
end

function _internal_integrals(pulse::AbstractPulseProfile, pol::P, method::AbstractNumericalIntegrationMethod, phi::T) where {T <: Real, P <: AbstractDefinitePolarization}
    tmp_func1 = t -> oscillator(pol, t) * _envelope(pulse, t)
    tmp_func2 = t -> (oscillator(pol, t) * _envelope(pulse, t))^2

    res1 = integrate(method, tmp_func1, zero(T), phi)
    res2 = integrate(method, tmp_func2, zero(T), phi)
    return InternalIntegrals(res1, res2)
end

# FIXME: This is wrong! We need to insert the xi-dependent terms
@inline function _internal_integrals(pulse::AbstractPulseProfile, pol::P, method::AbstractNumericalIntegrationMethod, phi::T) where {T <: Real, P <: AbstractIndefinitePolarization}
    tmp_func11 = t -> oscillator(PolX(), phi) * _envelope(pulse, phi)
    tmp_func12 = t -> oscillator(PolY(), phi) * _envelope(pulse, phi)

    # FIXME: this one misses xi
    tmp_func2 = t -> _envelope(pulse, t)^2 * (oscillator(PolX(), t)^2 + oscillator(PolY(), t)^2)

    res11 = integrate(method, tmp_func11, zero(T), phi)
    res12 = integrate(method, tmp_func12, zero(T), phi)
    res2 = integrate(method, tmp_func2, zero(T), phi)
    return InternalIntegrals(res12, res12, res2)
end

# TODO:
# - consider using `endpoint_internal_integrals` to model the constant value of the
# internal integral for phi not in the domain. This is especially important for infinte
# domains, where simple quadrature does not work anymore, but needs to be replaced by the
# actual value of the internal integral at the endpoint, e.g., by the integal from zero to
# infinity.
function internal_integrals(pulse::AbstractPulseProfile, pol::P, method::AbstractIntegrationMethod, phi::T)::InternalIntegrals{T} where {T <: Real, P <: AbstractPolarization}

    dom = domain(pulse)
    phi_eval = phi <= infimum(dom) ? infimum(dom) : min(phi, supremum(dom))
    return _internal_integrals(pulse, pol, method, phi_eval)

end
