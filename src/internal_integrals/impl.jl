# standard implementation for AbstractUnivariateInternalIntegral

struct UnivariateInternalIntegral{
        M <: AbstractIntegrationMethod,
    } <: AbstractUnivariateInternalIntegral
    method::M
end

integration_method(internal_int::UnivariateInternalIntegral) = internal_int.method

# standard implementation for AbstractBivariateInternalIntegral
struct BivariateInternalIntegral{
        M <: AbstractIntegrationMethod,
    } <: AbstractBivariateInternalIntegral
    method::M
end

integration_method(internal_int::BivariateInternalIntegral) = internal_int.method
