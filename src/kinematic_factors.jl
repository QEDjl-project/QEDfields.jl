# kinematic factors

"""
    kinematic_factor1(field::AbstractBackground, p, p_prime) -> Float64

Compute the kinematic factor \$\\beta_1(p, p'|k, a)\$ for strong-field QED processes.

# Arguments
- `field::AbstractBackground`: Background electromagnetic field configuration containing
  the reference momentum \$K\$ and polarization vector \$\\varepsilon^\\mu\$
- `p`: Initial four-momentum of the particle
- `p_prime`: Final four-momentum of the particle

# Returns
  - Kinematic factor: \$e((p'\\varepsilon)/(p'K) - (p\\varepsilon)/(pK))\$ where \$e\$ is the elementary charge

# See also
- [`kinematic_factor2`](@ref): The quadratic kinematic factor \$\\beta_2\$
"""
function kinematic_factor1(field::AbstractBackground, p, p_prime)
    K = reference_momentum(field)
    Eps = polarization_vector(field)

    term1 = (p_prime * Eps) / (p_prime * K)
    term2 = (p * Eps) / (p * K)
    return ELEMENTARY_CHARGE * (term1 - term2)
end

"""
    kinematic_factor2(field::AbstractBackground, p, p_prime) -> Float64

Compute the kinematic factor \$\\beta_2(p, p'|k, a)\$ for strong-field QED processes.

# Arguments
- `field::AbstractBackground`: Background electromagnetic field configuration containing
  the reference momentum \$K\$ and polarization vector \$\\varepsilon^\\mu\$
- `p`: Initial four-momentum of the particle
- `p_prime`: Final four-momentum of the particle

# Returns
  - Kinematic factor: \$-e^2(1/(p'K) - 1/(pK))\$ where \$e\$ is the elementary charge

# See also
- [`kinematic_factor1`](@ref): The quadratic kinematic factor \$\\beta_1\$
"""
function kinematic_factor2(field::AbstractBackground, p, p_prime)
    K = reference_momentum(field)
    term1 = inv(p_prime * K)
    term2 = inv(p * K)
    return ELEMENTARY_CHARGE^2 * (term2 - term1)
end
