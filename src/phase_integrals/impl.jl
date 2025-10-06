# standard implementation for phase integrals

struct PhaseIntegral{
        P <: AbstractBackgroundField,
        I <: AbstractInternalIntegral,
        M <: AbstractIntegrationMethod,
    } <: AbstractPhaseIntegral{P}
    field::P
    internal_integral::I
    method::M

    # TODO: verify compat of field and internal_integral
    function PhaseIntegral(
            field::P,
            internal_integral::I,
            method::M
        ) where {
            P <: AbstractBackgroundField,
            I <: AbstractInternalIntegral,
            M <: AbstractIntegrationMethod,
        }
        background_field(internal_integral) == field || throw(
            ArgumentError(
                "fields passed and in internal integral must match!"
            )
        )

        return new{P, I, M}(field, internal_integral, method)
    end
end

# default fallback on standard internal integral
function PhaseIntegral(
        field::AbstractBackgroundField,
        method_intern::AbstractIntegrationMethod,
        method_global::AbstractIntegrationMethod
    )
    return PhaseIntegral(
        field,
        InternalIntegral(
            field,
            method_intern,
        ),
        method_global
    )
end

background_field(phase_integral::PhaseIntegral) = phase_integral.field
internal_integral(phase_integral::PhaseIntegral) = phase_integral.internal_integral
integration_method(phase_integral::PhaseIntegral) = phase_integral.method
