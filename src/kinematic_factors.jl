# TODO: implement kin factors for indefinite polarization (see offline note)

# kinematic factors
"""
    kinematic_factor1(field::AbstractBackgroundField, pol, p, p_prime) -> Real
    kinematic_factor1(field::AbstractBackgroundField, p, p_prime) -> Real

Return the first order kinematic factor
\$\\beta_1(p, p' \\mid k, \\varepsilon)\$ for an electron interacting with a
background electromagnetic field.

The function supports both *definite* and *indefinite* polarization models via
multiple dispatch.

# Arguments

- `field::AbstractBackgroundField`: Background electromagnetic field configuration,
providing the reference momentum \$k\$ and polarization data.
- `pol::AbstractDefinitePolarization` (optional): Definite polarization state \$\\varepsilon\$.
- `p`: Incoming electron four-momentum.
- `p_prime`: Outgoing electron four-momentum.

# Returns

- `Real`: The kinematic factor
    ```math
    \\begin{align*}

    \\beta_1(p, p' \\mid k, \\varepsilon) =  e\\left(
      \\frac{p' \\varepsilon}{p' k}
      -
      \\frac{p \\varepsilon}{p k}
    \\right),
    \\end{align*}
  ```
  where \$e\$ is the elementary charge, \$\\varepsilon\$ is the polarization
  vector, and \$k\$ is the reference momentum of the background field. For
  mismatched definite polarizations, the return value is zero.

# Calling modes

## Explicit polarization

```julia
kinematic_factor1(field, pol, p, p_prime)
```
If the background field carries a definite polarization, the kinematic factor is evaluated
only when the explicitly provided polarization `pol` matches the polarization type
`field`. Otherwise, the function returns zero. In contrast, if the field carries an
indefinite polarization, the kinematic factor is always evaluated for the given definite
polarization pol.

## Implicite polarization

```Julia
kinematic_factor1(field, p, p_prime)
```

This in only avaliable for background fields with definite polarization, such that the
polarization of `field` is used implicitly.

- [`kinematic_factor2`](@ref): The second order kinematic factor \$\\beta_1\$
"""
kinematic_factor1

### definite polarization
# return zero, if the polarization passed in does not match the field polarization
kinematic_factor1(field::AbstractBackgroundField{<:AbstractDefinitePolarization}, pol::AbstractDefinitePolarization, p, p_prime) = zero(eltype(p))

# if given pol and field pol match, proceed
kinematic_factor1(field::AbstractBackgroundField{P}, pol::P, p, p_prime) where {P <: AbstractDefinitePolarization} = _kinematic_factor1(field, pol, p, p_prime)

# default: take field pol
kinematic_factor1(field::AbstractBackgroundField{P}, p, p_prime) where {P <: AbstractDefinitePolarization} = kinematic_factor1(field, polarization(field), p, p_prime)

### indefinite polarization

kinematic_factor1(field::AbstractBackgroundField{P}, pol::AbstractDefinitePolarization, p, p_prime) where {P <: AbstractIndefinitePolarization} = _kinematic_factor1(field, pol, p, p_prime)

# generic implementation
function _kinematic_factor1(field::AbstractBackgroundField, pol::AbstractDefinitePolarization, p, p_prime)
    k = reference_momentum(field)
    Eps = polarization_vector(field, pol)

    term1 = (p_prime * Eps) / (p_prime * k)
    term2 = (p * Eps) / (p * k)
    return ELEMENTARY_CHARGE * (term1 - term2)
end

"""
    kinematic_factor2(field::AbstractBackgroundField, p, p_prime) -> Float64

Return the sectond order kinematic factor
\$\\beta_2(p, p' \\mid k, \\varepsilon)\$ for an electron interacting with a
background electromagnetic field.

# Arguments

- `field::AbstractBackgroundField`: Background electromagnetic field configuration containing
  the reference momentum \$k\$ and polarization vector \$\\varepsilon^\\mu\$
- `p`: Initial four-momentum of the particle
- `p_prime`: Final four-momentum of the particle

# Returns

- `Real`: The kinematic factor
  ```math
    \\begin{align*}

    \\beta_2(p, p' \\mid k, \\varepsilon) =  -e^2\\left(
      \\frac{1}{p' k}
      -
      \\frac{1}{p k}
    \\right),
    \\end{align*}
  ```
   where \$e\$ is the elementary charge

# See also
- [`kinematic_factor1`](@ref): The first order kinematic factor \$\\beta_1\$
"""
function kinematic_factor2(field::AbstractBackgroundField, p, p_prime)
    k = reference_momentum(field)
    term1 = inv(p_prime * k)
    term2 = inv(p * k)
    return ELEMENTARY_CHARGE^2 * (term2 - term1)
end
