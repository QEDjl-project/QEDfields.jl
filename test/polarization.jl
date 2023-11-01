
using QEDbase
using QEDfields
using Random
using IntervalSets

RNG = MersenneTwister(137)
ATOL = eps()
RTOL = sqrt(eps())

RND_MOM = SFourMomentum(rand(RNG,4))
POL_SET = [PolX(), PolY()]

@testset "polarization vectors" begin
    @testset "$mom" for mom in [SFourMomentum(1,0,0,1),RND_MOM]
        @testset "single pol" begin
            @testset "$pol" for pol in POL_SET
                pol_vec = polarization_vector(pol,mom)
                @test isapprox(pol_vec*mom, zero(eltype(mom)), atol = ATOL, rtol = RTOL)
            end
        end
        @testset "pol combination" begin
            @testset "($pol1, $pol2)" for (pol1,pol2) in Iterators.product(POL_SET,POL_SET) 
                pol_vec1 = polarization_vector(pol1,mom)
                pol_vec2 = polarization_vector(pol2,mom)
                if pol1==pol2
                    groundtruth = -one(eltype(pol_vec1))
                else
                    groundtruth = zero(eltype(pol_vec1))
                end
                @test isapprox(pol_vec1*pol_vec2, groundtruth, atol = ATOL, rtol = RTOL)
            end
        end

        @testset "All pols" begin
            test_all_pol_vec = polarization_vector(AllPol(),mom)
            groundtruth_polx_vec = polarization_vector(PolX(),mom)
            groundtruth_poly_vec = polarization_vector(PolY(),mom)

            @test isapprox(test_all_pol_vec[1], groundtruth_polx_vec, atol = ATOL, rtol = RTOL)
            @test isapprox(test_all_pol_vec[2], groundtruth_poly_vec, atol = ATOL, rtol = RTOL)
        end
    end
end

@testset "oscillators" begin
    @testset "single argument" begin
        rnd_arg = rand(RNG,0:2pi)

        groundtruth_polX = cos(rnd_arg)
        test_val_polX = oscillator(PolX(),rnd_arg)
        @test isapprox(test_val_polX, groundtruth_polX, atol = ATOL, rtol = RTOL)

        groundtruth_polY = sin(rnd_arg)
        test_val_polY = oscillator(PolY(),rnd_arg)
        @test isapprox(test_val_polY, groundtruth_polY, atol = ATOL, rtol = RTOL)

        test_val_AllPol = oscillator(AllPol(),rnd_arg)
        @test isapprox(test_val_AllPol[1], groundtruth_polX, atol = ATOL, rtol = RTOL)
        @test isapprox(test_val_AllPol[2], groundtruth_polY, atol = ATOL, rtol = RTOL)
    end
end
