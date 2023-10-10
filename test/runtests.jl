using QEDfields
using Test
using SafeTestsets

@time @safetestset "downstream" begin
        include("downstream.jl")
end

@time @safetestset "background field interface" begin
    include("interfaces/background_field_interface.jl")
end

