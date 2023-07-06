module QEDfields

using QEDbase

export dummy_QEDbase
export bar

# Write your package code here.
function dummy_QEDbase(x::AbstractVector{T}) where {T<:Real}
  length(x) == 4 || error("The length of the input needs to be four. <$(length(x))> given.")
  @inbounds SFourMomentum(x...)
end

function bar()
    return foo()
end


end
