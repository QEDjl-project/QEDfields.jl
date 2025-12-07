module FCCQuadExt

using FCCQuad
using QEDfields
using IntervalSets


@inline function _fccquad(
        prefactor::Function,
        oscillator::Function,
        freqs::AbstractVector{<:Real};
        xmin,
        xmax,
        integrator::FilonClenshawCurtisQuadrature{T}
    ) where {T}

    return fccquad(
        prefactor, oscillator, freqs;
        T = T,
        xmin = xmin,
        xmax = xmax,
        reltol = integrator.reltol,
        abstol = integrator.abstol,
        method = integrator.method,
        vectornorm = integrator.vectornorm,
        branching = integrator.branching,
        maxdepth = integrator.maxdepth,
        minlog2degree = integrator.minlog2degree,
        localmaxlog2degree = integrator.localmaxlog2degree,
        nonadaptivelog2degree = integrator.nonadaptivelog2degree,
        globalmaxlog2degree = integrator.globalmaxlog2degree,
    )
end

_as_vec(x::AbstractVector) = x
_as_vec(x::Number) = [x]
function QEDfields.phase_integrals(
        field::QEDfields.AbstractPlaneWaveField{P},
        internal_integral_method::QEDfields.AbstractIntegrationMethod,
        phase_integral_method::FilonClenshawCurtisQuadrature,
        pnum::T,
        beta1::T,
        beta2::T
    )::PhaseIntegrals{Complex{T}, 2} where {
        T <: Real,
        P <: QEDfields.AbstractDefinitePolarization,
    }

    dom = compact_domain(field)
    a, b = endpoints(dom)
    max_amp = maximum_amplitude(field)

    # TODO: make max_amp factors global
    pre1 = x -> max_amp * QEDfields._amplitude(field, x)
    osc1 = x -> exp(1im * QEDfields._volkov_phase(field, internal_integral_method, x, beta1, beta2))
    pre2 = x -> max_amp^2 * QEDfields._amplitude(field, x)^2
    osc2 = x -> exp(1im * QEDfields._volkov_phase(field, internal_integral_method, x, beta1, beta2))

    res1, nevals1 = _fccquad(pre1, osc1, _as_vec(pnum); xmin = a, xmax = b, integrator = phase_integral_method)
    res2, nevals2 = _fccquad(pre2, osc2, _as_vec(pnum); xmin = a, xmax = b, integrator = phase_integral_method)
    return PhaseIntegrals(
        PhaseIntegralResult(QEDfields._tuple_pack(res1[:, 1])...),
        PhaseIntegralResult(QEDfields._tuple_pack(res2[:, 1])...),
    )
end

end
