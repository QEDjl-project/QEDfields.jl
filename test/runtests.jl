using QEDfields
using Test
import Pkg


function isinstalled(pk::AbstractString)
  return pk in [v.name for v in values(Pkg.dependencies())]
end


@testset "QEDfields.jl" begin
    # Write your tests here.
    
    @test isinstalled("QEDbase")

end
