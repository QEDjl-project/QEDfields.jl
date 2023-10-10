###################
# check if upstream packages provide the assumed functionality
###################

using Pkg: Pkg

# QEDbase.jl

import QEDbase

@testset "Integration: QEDbase" begin

    QEDbase_exports = names(QEDbase)
    @test :SFourMomentum in QEDbase_exports
end

