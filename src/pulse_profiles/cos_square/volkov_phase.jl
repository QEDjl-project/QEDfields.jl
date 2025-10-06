# correct for -dphi<=x<=dphi
@inline function _integral11_cos_square(x, dphi)
    return dphi / 4.0 * (sin((pi / dphi - 1) * x) / (pi - dphi) + sin((pi / dphi + 1) * x) / (pi + dphi) + 2 * sin(x) / dphi)
end

# value for x=dphi
@inline function _integral11_cos_square(dphi)
    return pi^2 / 2 * sin(dphi) / (pi^2 - dphi^2)
end

"""

    integral11(::InternalIntegral,phi::Real)

"""
function integral11 end

"""

    integral11(::InternalIntegral,phi::Real)

"""
function integral12 end

"""

    integral2(::InternalIntegral,phi::Real)

"""
function integral2 end

function InternalIntegral1(x, dphi)
    if x <= -dphi
        return -_integral11_cos_square(dphi)
    elseif x >= dphi
        return _integral11_cos_square(dphi)
    else
        return _integral11_cos_square(x, dphi)
    end
end

function unsafe_InternalIntegral1(x, dphi)
    return _integral11_cos_square(x, dphi)
end

function InternalIntegral1_quad(x, dphi)
    tmp_func = t -> envelope(t, dphi) * cos(t)
    res, err = quadgk(tmp_func, 0, x)
    return res
end
