using Random
using QEDfields

RNG = Xoshiro(137)

DTYPES = (UInt32, UInt64, Int32, Int64, Float16, Float32, Float64, Complex{Float16}, Complex{Float32}, Complex{Float64})

function _check_internal_ints(internal_ints, I1, I2)
    @test isbits(internal_ints)
    @test internal_ints.I1 == I1
    @test internal_ints.I2 == I2
    if VERSION >= v"1.12"
        @test_throws FieldError internal_ints.I11
        @test_throws FieldError internal_ints.I12
    else
        @test_throws "type InternalIntegrals has no field I11" internal_ints.I11
        @test_throws "type InternalIntegrals has no field I12" internal_ints.I12
    end

    return nothing
end

function _check_internal_ints(internal_ints, I11, I12, I2)
    @test isbits(internal_ints)
    @test internal_ints.I11 == I11
    @test internal_ints.I12 == I12
    @test internal_ints.I2 == I2
    return if VERSION >= v"1.12"
        @test_throws FieldError internal_ints.I1
    else
        @test_throws "type InternalIntegrals has no field I1" internal_ints.I1
    end
end

function _check_phase_ints(phase_ints, B1, B2)
    @test isbits(phase_ints)
    @test phase_ints.B1 == B1
    @test phase_ints.B2 == B2
    if VERSION >= v"1.12"
        @test_throws FieldError phase_ints.B11
        @test_throws FieldError phase_ints.B12
    else
        @test_throws "type PhaseIntegrals has no field B11" phase_ints.B11
        @test_throws "type PhaseIntegrals has no field B12" phase_ints.B12
    end

    return nothing
end

function _check_phase_ints(phase_ints, B11, B12, B2)
    @test isbits(phase_ints)
    @test phase_ints.B11 == B11
    @test phase_ints.B12 == B12
    @test phase_ints.B2 == B2

    if VERSION >= v"1.12"
        @test_throws FieldError phase_ints.B1
    else
        @test_throws "type PhaseIntegrals has no field B1" phase_ints.B1
    end

    return nothing
end


@testset "dtype = $dtype" for dtype in DTYPES
    @testset "internal integral result" begin
        @testset "w/o error" begin
            value = rand(RNG, dtype)

            internal_integral_result = @inferred InternalIntegralResult(value)

            @test isbits(internal_integral_result)
            @test isapprox(internal_integral_result.value, value, atol = 0, rtol = 0)
            @test isnan(internal_integral_result.error)
        end

        @testset "w/ error" begin
            value, error = rand(RNG, dtype, 2)

            internal_integral_result = @inferred InternalIntegralResult(value, error)

            @test isbits(internal_integral_result)
            @test isapprox(internal_integral_result.value, value, atol = 0, rtol = 0)
            @test isapprox(internal_integral_result.error, error, atol = 0, rtol = 0)
        end

    end

    @testset "internal integral" begin
        @testset "definite polarization" begin
            I1, err1 = rand(RNG, dtype, 2)
            I1_result = InternalIntegralResult(I1, err1)
            I1_result_without_error = InternalIntegralResult(I1)

            I2, err2 = rand(RNG, dtype, 2)
            I2_result = InternalIntegralResult(I2, err2)
            I2_result_without_error = InternalIntegralResult(I2)

            ii_with_error = @inferred InternalIntegrals(I1_result, I2_result)
            ii_without_error = @inferred InternalIntegrals(I1_result_without_error, I2_result_without_error)
            ii_default = @inferred InternalIntegrals(I1, I2)

            _check_internal_ints(ii_with_error, I1_result, I2_result)
            _check_internal_ints(ii_without_error, I1_result_without_error, I2_result_without_error)
            _check_internal_ints(ii_default, I1_result_without_error, I2_result_without_error)
        end

        @testset "indefinite polarization" begin
            I11, err11 = rand(RNG, dtype, 2)
            I11_result = InternalIntegralResult(I11, err11)
            I11_result_without_error = InternalIntegralResult(I11)

            I12, err12 = rand(RNG, dtype, 2)
            I12_result = InternalIntegralResult(I12, err12)
            I12_result_without_error = InternalIntegralResult(I12)

            I2, err2 = rand(RNG, dtype, 2)
            I2_result = InternalIntegralResult(I2, err2)
            I2_result_without_error = InternalIntegralResult(I2)

            ii_with_error = @inferred InternalIntegrals(I11_result, I12_result, I2_result)
            ii_without_error = @inferred InternalIntegrals(I11_result_without_error, I12_result_without_error, I2_result_without_error)
            ii_default = @inferred InternalIntegrals(I11, I12, I2)

            _check_internal_ints(ii_with_error, I11_result, I12_result, I2_result)
            _check_internal_ints(ii_without_error, I11_result_without_error, I12_result_without_error, I2_result_without_error)
            _check_internal_ints(ii_default, I11_result_without_error, I12_result_without_error, I2_result_without_error)
        end
    end

    @testset "phase integral result" begin
        @testset "w/o error" begin
            value = rand(RNG, dtype)

            phase_integral_result = @inferred PhaseIntegralResult(value)

            @test isbits(phase_integral_result)
            @test isapprox(phase_integral_result.value, value, atol = 0, rtol = 0)
            @test isnan(phase_integral_result.error)
        end

        @testset "w/ error" begin
            value, error = rand(RNG, dtype, 2)

            phase_integral_result = @inferred PhaseIntegralResult(value, error)

            @test isbits(phase_integral_result)
            @test isapprox(phase_integral_result.value, value, atol = 0, rtol = 0)
            @test isapprox(phase_integral_result.error, error, atol = 0, rtol = 0)
        end
    end

    @testset "phase integral" begin
        @testset "definite polarization" begin
            B1, err1 = rand(RNG, dtype, 2)
            B1_result = PhaseIntegralResult(B1, err1)
            B1_result_without_error = PhaseIntegralResult(B1)

            B2, err2 = rand(RNG, dtype, 2)
            B2_result = PhaseIntegralResult(B2, err2)
            B2_result_without_error = PhaseIntegralResult(B2)

            pi_with_error = @inferred PhaseIntegrals(B1_result, B2_result)
            pi_without_error = @inferred PhaseIntegrals(B1_result_without_error, B2_result_without_error)
            pi_default = @inferred PhaseIntegrals(B1, B2)

            _check_phase_ints(pi_with_error, B1_result, B2_result)
            _check_phase_ints(pi_without_error, B1_result_without_error, B2_result_without_error)
            _check_phase_ints(pi_default, B1_result_without_error, B2_result_without_error)
        end

        @testset "indefinite polarization" begin
            B11, err11 = rand(RNG, dtype, 2)
            B11_result = PhaseIntegralResult(B11, err11)
            B11_result_without_error = PhaseIntegralResult(B11)

            B12, err12 = rand(RNG, dtype, 2)
            B12_result = PhaseIntegralResult(B12, err12)
            B12_result_without_error = PhaseIntegralResult(B12)

            B2, err2 = rand(RNG, dtype, 2)
            B2_result = PhaseIntegralResult(B2, err2)
            B2_result_without_error = PhaseIntegralResult(B2)

            pi_with_error = @inferred PhaseIntegrals(B11_result, B12_result, B2_result)
            pi_without_error = @inferred PhaseIntegrals(B11_result_without_error, B12_result_without_error, B2_result_without_error)
            pi_default = @inferred PhaseIntegrals(B11, B12, B2)

            _check_phase_ints(pi_with_error, B11_result, B12_result, B2_result)
            _check_phase_ints(pi_without_error, B11_result_without_error, B12_result_without_error, B2_result_without_error)
            _check_phase_ints(pi_default, B11_result_without_error, B12_result_without_error, B2_result_without_error)
        end
    end
end
