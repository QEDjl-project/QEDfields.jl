using QEDfields
using Test
using SafeTestsets

@time begin
    @safetestset "integration methods" begin
        include("integration_methods.jl")
    end

    # fields tests
    @safetestset "result types" begin
        include("results.jl")
    end

    #=
    @safetestset "field interface" begin
        include("interface.jl")
    end
=#
    @testset "pulse profiles" begin

        #@safetestset "interface" begin
        #    include("pulse_profile/interface.jl")
        #end

        #@safetestset "pulses" begin
        #    include("pulse_profile/pulses.jl")
        #end

        #=
        @safetestset "cos square" begin
            include("pulse_profile/cos_square.jl")
        end

        @safetestset "gaussian" begin
            include("pulse_profile/gaussian_pulse.jl")
        end
        =#

    end
    #=
    @testset "pulsed fields" begin

        @safetestset "interface" begin
            include("pulsed_fields/interface.jl")
        end

        @safetestset "implementation" begin
            include("pulsed_fields/impl.jl")
        end

    end
    =#
end
