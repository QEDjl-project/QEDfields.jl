# standard implementation for AbstractInternalIntegral

struct InternalIntegral{
        P <: AbstractBackgroundField,
        M <: AbstractIntegrationMethod,
    } <: AbstractInternalIntegral
    field::P
    method::M
end

background_field(internal_int::InternalIntegral) = internal_int.field
integration_method(internal_int::InternalIntegral) = internal_int.method
