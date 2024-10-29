var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = QEDfields","category":"page"},{"location":"#QEDfields","page":"Home","title":"QEDfields","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for QEDfields.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [QEDfields]","category":"page"},{"location":"#QEDfields.AbstractBackgroundField","page":"Home","title":"QEDfields.AbstractBackgroundField","text":"Abstract base type for describing classical background fields.\n\nThe only supported class of background fields yet, is the pulsed plane-wave field (see AbstractPulsedPlaneWaveField for details).\n\n\n\n\n\n","category":"type"},{"location":"#QEDfields.AbstractPulsedPlaneWaveField","page":"Home","title":"QEDfields.AbstractPulsedPlaneWaveField","text":"Abstract base type for pulsed plane-wave fields.\n\nnote: Pulsed field interface\nFor every subtype, the following functions need to be implemented.\nreference_momentum(::AbstractPulsedPlaneWaveField)\ndomain(::AbstractPulsedPlaneWaveField)\npulse_length(::AbstractPulsedPlaneWaveField)\nenvelope(::AbstractPulsedPlaneWaveField,x::Real)\n\n\n\n\n\n","category":"type"},{"location":"#QEDfields.CosSquarePulse","page":"Home","title":"QEDfields.CosSquarePulse","text":"CosSquarePulse(mom::M,pulse_length::T) where {M<:QEDbase.AbstractFourMomentum,T<:Real}\n\nConcrete implementation of an AbstractPulsedPlaneWaveField for cos-square pulses.\n\nnote: Pulse shape\nThe pulse envelope of a cos-square pulse is defined as g(phi) = cos^2(fracpiphi2Deltaphi)for phiin (-DeltaphiDeltaphi), where Deltaphi denotes the pulse_length, and zero otherwise.\n\n\n\n\n\n","category":"type"},{"location":"#QEDfields._envelope","page":"Home","title":"QEDfields._envelope","text":"_envelope(::AbstractPulsedPlaneWaveField, phi::Real)\n\nInterface function for AbstractPulsedPlaneWaveField, which returns the value of the phase envelope function (also referred to as pulse envelope) for a given phase variable.\n\nnote: Single point implementation\nThe interface function can be implemented for just one phase point as input. With that, evaluation on a vector of inputs is generically implemented by broadcasting. However, if there is a better custom implementation for vectors in input values, consider implementing \n    _envelope(::AbstractPulsedPlaneWaveField, phi::AbstractVector{T<:Real})\n\n\nnote: unsafe implementation\nThis is the unsafe version of the phase envelope function, i.e. this should be implement without input checks like the domain check.  In the safe version envelope, a domain check is performed, i.e. it returns the value of _envelope if the passed in phi  is in the domain of the field, and zero otherwise. \n\n\n\n\n\n","category":"function"},{"location":"#QEDfields.amplitude-Tuple{AbstractPulsedPlaneWaveField, QEDbase.AbstractDefinitePolarization, Real}","page":"Home","title":"QEDfields.amplitude","text":"amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi)\n\nReturns the value of the amplitude for a given polarization direction and phase variable phi. \n\nnote: Conventions\nThere are two directions supported:pol::PolX # -> return envelope(phi)*cos(phi)\npol::PolY # -> return envelope(phi)*sin(phi)\n\nnote: Safe implementation\nIn this function, a domain check is performed, i.e. if phi is in the domain of the field, the value of the amplitude is returned, and zero otherwise.\n\n\n\n\n\n","category":"method"},{"location":"#QEDfields.domain","page":"Home","title":"QEDfields.domain","text":"domain(::AbstractPulsedPlaneWaveField)\n\nInterface function for AbstractPulsedPlaneWaveField, which returns interval (as a IntervalSets.Interval) for the given background field. \n\n\n\n\n\n","category":"function"},{"location":"#QEDfields.envelope-Tuple{AbstractPulsedPlaneWaveField, Real}","page":"Home","title":"QEDfields.envelope","text":"envelope(pulsed_field::AbstractPulsedPlaneWaveField, phi::Real)\n\nReturn the value of the phase envelope function (also referred to as pulse envelope or pulse shape)  for given pulsed_field and phase phi. Performs domain check on phi before calling _envelope;  returns zero if phi is not in the domain returned by [domain](@ref).\n\n\n\n\n\n","category":"method"},{"location":"#QEDfields.generic_spectrum-Tuple{AbstractPulsedPlaneWaveField, QEDbase.AbstractDefinitePolarization, Real}","page":"Home","title":"QEDfields.generic_spectrum","text":"generic_spectrum(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, pnum)\n\nReturn the generic spectrum of the given field, for the given polarization direction pol and a given photon number parameter pnum.\n\nnote: Convention\nThe generic spectrum is defined as the Fourier transform of the respective amplitude function for the given polarization direction:beginalign*\n    x-mathrmpol to int_-infty^infty g(phi) cos(phi) exp(ilphi)\n    y-mathrmpol to int_-infty^infty g(phi) sin(phi) exp(ilphi)\nendalign*where g(phi) is the envelope and l the photon number parameter.\n\n\n\n\n\n","category":"method"},{"location":"#QEDfields.oscillator","page":"Home","title":"QEDfields.oscillator","text":"oscillator(pol::AbstractPolarizaion, phi::Real)\n\nReturn the value of the base oscillator associated with a given polarization pol at a given point phi.\n\nnote: Convention\nThe current default implementation are PolX() -> cos(phi)\nPolY() -> sin(phi)\nAllPol() -> (cos(phi), sin(phi))\n\n\n\n\n\n","category":"function"},{"location":"#QEDfields.polarization_vector-Tuple{QEDbase.AbstractPolarization, Any}","page":"Home","title":"QEDfields.polarization_vector","text":"polarization_vector(pol::AbstractPolarization, mom::QEDbase.AbstractFourMomentum)\n\nReturn the polarization vector for a given polarization and four-momentum mom. For a definite polarization, the respective LorentzVector is returned,  where as for an indefinite polarization, a tuple of polarization vectors is returned.\n\nnote: Convention\nIn the current implementation, we use the base_state function for Photon provided by QEDcore.jl.\n\n\n\n\n\n","category":"method"},{"location":"#QEDfields.pulse_length","page":"Home","title":"QEDfields.pulse_length","text":"pulse_length(::AbstractPulsedPlaneWaveField)\n\nInterface function for AbstractPulsedPlaneWaveField, which returns a dimensionless representative number for the duration of the background field, i.e. a half-width or standard deviation in units of phase periods.\n\n\n\n\n\n","category":"function"},{"location":"#QEDfields.reference_momentum","page":"Home","title":"QEDfields.reference_momentum","text":"reference_momentum(::AbstractPulsedPlaneWaveField)\n\nInterface function for AbstractPulsedPlaneWaveField, which returns the reference momentum (as a subtype of QEDbase.AbstractFourMomentum) associated with the passed background field.\n\n\n\n\n\n","category":"function"}]
}