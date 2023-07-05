using QEDfields
using Test
import Pkg


function isinstalled(pk::AbstractString)
  return pk in [v.name for v in values(Pkg.dependencies())]
end


@testset "QEDfields.jl" begin
    # Write your tests here.
    
    @testset "Integration: QEDbase" begin
      
      @test isinstalled("QEDbase")
      @test length(dummy_QEDbase(rand(4)))==4
      @test bar()==42
    end


end
