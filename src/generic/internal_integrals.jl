### internal integrals

@inline function _internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractIntegrationMethod, phi::T) where {T <: Real, P <: AbstractDefinitePolarization}
    tmp_func1 = t -> _amplitude(field, t)
    tmp_func2 = t -> _amplitude(field, t)^2

    res1 = integrate(method, tmp_func1, zero(T), phi)
    res2 = integrate(method, tmp_func2, zero(T), phi)
    return InternalIntegrals(res1, res2)
end

# TODO: this needs to be tested
@inline function _internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractIntegrationMethod, phi::T) where {T <: Real, P <: AbstractIndefinitePolarization}
    tmp_func11 = t -> _amplitude(field, t, PolX())
    tmp_func12 = t -> _amplitude(field, t, PolY())
    tmp_func2 = t -> _amplitude(field, t, PolX())^2 + _amplitude(field, t, PolY())^2

    res11 = integrate(method, tmp_func11, zero(T), phi)
    res12 = integrate(method, tmp_func12, zero(T), phi)
    res2 = integrate(method, tmp_func2, zero(T), phi)
    return InternalIntegrals(res12, res12, res2)
end

function internal_integrals(field::AbstractPlaneWaveField{P}, method::AbstractIntegrationMethod, phi::T)::InternalIntegrals{T} where {T <: Real, P <: AbstractDefinitePolarization}

    dom = domain(field)

    phi_eval = phi <= minimum(dom) ? minimum(dom) : min(phi, maximum(dom))
    return _internal_integrals(field, method, phi_eval)

end
