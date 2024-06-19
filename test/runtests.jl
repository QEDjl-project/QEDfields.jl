using QEDfields
using Test
using SafeTestsets

# -> this is covered by integration tests
# @time @safetestset "downstream" begin
#     include("downstream.jl")
# end

@time @safetestset "background field interface" begin
    include("interfaces/background_field_interface.jl")
end

@time @safetestset "polarization" begin
    include("polarization.jl")
end

@time @safetestset "pulses" begin
    include("pulses/cos_square.jl")
end
