

abstract type AbstractSpinOrPolarization end

abstract type AbstractPolarization <: AbstractSpinOrPolarization end

abstract type AbstractDefinitePolarization <: AbstractPolarization end

abstract type AbstractIndefinitePolarization <: AbstractPolarization end

struct AllPolarization <: AbstractIndefinitePolarization end
const AllPol = AllPolarization

struct PolarizationX <: AbstractDefinitePolarization end
const PolX = PolarizationX

struct PolarizationY <: AbstractDefinitePolarization end
const PolY = PolarizationY

function _photon_state(mom::QEDbase.AbstractFourMomentum)
    cth = getCosTheta(mom)
    sth = sqrt(1 - cth^2)
    sin_phi = getSinPhi(mom)
    cos_phi = sqrt(1 - sin_phi^2)
    return SVector(
        SLorentzVector{Float64}(0.0, cth * cos_phi, cth * sin_phi, -sth),
        SLorentzVector{Float64}(0.0, -sin_phi, cos_phi, 0.0),
    )
end

function _photon_state(pol::PolarizationX, mom::QEDbase.AbstractFourMomentum)
    cth = getCosTheta(mom)
    sth = sqrt(1 - cth^2)
    sin_phi = getSinPhi(mom)
    cos_phi = sqrt(1 - sin_phi^2)
    return SLorentzVector{Float64}(0.0, cth * cos_phi, cth * sin_phi, -sth)
end

function _photon_state(pol::PolarizationY, mom::QEDbase.AbstractFourMomentum)
    sin_phi = getSinPhi(mom)
    cos_phi = sqrt(1 - sin_phi^2)
    return SLorentzVector{Float64}(0.0, -sin_phi, cos_phi, 0.0)
end
