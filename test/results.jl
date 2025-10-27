using Random
using QEDfields

RNG = Xoshiro(137)

DTYPES = (Float16, Float32, Float64)

@testset "dtype = $dtype" for dtype in DTYPES
    @testset "internal integral" begin
        @testset "definite polarization" begin
            I1, I2 = rand(RNG, dtype, 2)

            ii_result = @inferred InternalIntegrals(I1, I2)

            @test isbits(ii_result)
            @test ii_result.I1 == I1
            @test ii_result.I2 == I2
            @test_throws "type InternalIntegrals has no field I11" ii_result.I11
            @test_throws "type InternalIntegrals has no field I12" ii_result.I12
        end

        @testset "definite polarization" begin
            I11, I12, I2 = rand(RNG, dtype, 3)

            ii_result = @inferred InternalIntegrals(I11, I12, I2)

            @test isbits(ii_result)
            @test ii_result.I11 == I11
            @test ii_result.I12 == I12
            @test ii_result.I2 == I2
        end
    end

    @testset "phase integral result" begin
        @testset "w/o error" begin
            value = rand(RNG, dtype)

            phase_integral_result = @inferred PhaseIntegralResult(value)

            @test isbits(phase_integral_result)
            @test phase_integral_result.value == value
            @test isnan(phase_integral_result.error)
        end

        @testset "w/ error" begin
            value, error = rand(RNG, dtype, 2)

            phase_integral_result = @inferred PhaseIntegralResult(value, error)

            @test isbits(phase_integral_result)
            @test phase_integral_result.value == value
            @test phase_integral_result.error == error
        end

    end
end
