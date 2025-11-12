function _groundtruth_phase_integrals(
        field::AbstractPlaneWaveField{P},
        internal_integral_method::QEDfields.AbstractIntegrationMethod,
        phase_integral_method::QEDfields.AbstractIntegrationMethod,
        pnum::T,
        beta1::T,
        beta2::T
    ) where {T, P}
    dom = compact_domain(field)
    max_amp = maximum_amplitude(field)
    function vphase(x)
        ii = internal_integrals(field, internal_integral_method, x)
        return max_amp * beta1 * ii.I1.value - max_amp^2 * beta2 * ii.I2.value
    end

    # TODO: make max_amp factors global
    integrand1 = x -> max_amp * QEDfields._amplitude(field, x) * exp(1im * pnum * x + 1im * vphase(x))
    integrand2 = x -> (max_amp * QEDfields._amplitude(field, x))^2 * exp(1im * pnum * x + 1im * vphase(x))

    res1 = integrate(phase_integral_method, integrand1, dom)
    res2 = integrate(phase_integral_method, integrand2, dom)

    return PhaseIntegrals(
        PhaseIntegralResult(QEDfields._tuple_pack(res1)...),
        PhaseIntegralResult(QEDfields._tuple_pack(res2)...)
    )
end
