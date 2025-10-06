# kinematic factors

# == beta1(p,p'\vert k,a)
function kinematic_factor1(field::AbstractBackground, p, p_prime)
    K = reference_momentum(field)
    Eps = polarization_vector(field)

    term1 = (p_prime * Eps) / (p_prime * K)
    term2 = (p * Eps) / (p * K)
    return ELEMENTARY_CHARGE * (term1 - term2)
end

# == beta2(p,p'\vert k,a)
function kinematic_factor2(field::AbstractBackground, p, p_prime)
    K = reference_momentum(field)
    term1 = inv(p_prime * K)
    term2 = inv(p * K)
    return ELEMENTARY_CHARGE^2 * (term2 - term1)
end
