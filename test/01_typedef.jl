module TestTypeDef
    using Base.Test
    using CategoricalArrays
    using CategoricalArrays: DefaultRefType, level,  reftype, valtype, catvalue, iscatvalue

    pool = CategoricalPool(
        [
            "a",
            "b",
            "c"
        ],
        Dict(
            "a" => DefaultRefType(1),
            "b" => DefaultRefType(2),
            "c" => DefaultRefType(3),
        )
    )

    @test iscatvalue(Int) == false
    @test iscatvalue(Any) == false
    @test iscatvalue(Null) == false

    @test isa(pool, CategoricalPool)

    @test isa(pool.index, Vector)
    @test length(pool.index) == 3
    @test pool.index[1] == "a"
    @test pool.index[2] == "b"
    @test pool.index[3] == "c"

    @test isa(pool.invindex, Dict)
    @test length(pool.invindex) == 3
    @test pool.invindex["a"] === DefaultRefType(1)
    @test pool.invindex["b"] === DefaultRefType(2)
    @test pool.invindex["c"] === DefaultRefType(3)

    @test isa(pool.order, Vector{DefaultRefType})
    @test length(pool.order) == 3
    @test pool.order[1] === DefaultRefType(1)
    @test pool.order[2] === DefaultRefType(2)
    @test pool.order[3] === DefaultRefType(3)

    # valtype() only accepts "categorical value type"
    @test_throws ArgumentError valtype("abc")
    @test_throws ArgumentError valtype(String)
    @test_throws ArgumentError valtype(1.0)
    @test_throws ArgumentError valtype(Int)

    for i in 1:3
        x = catvalue(i, pool)

        @test iscatvalue(x)
        @test iscatvalue(typeof(x))
        @test valtype(x) === String
        @test valtype(typeof(x)) === String
        @test reftype(x) === DefaultRefType
        @test reftype(typeof(x)) === DefaultRefType
        @test x isa CategoricalArrays.CategoricalString{DefaultRefType}

        @test isa(level(x), DefaultRefType)
        @test level(x) === DefaultRefType(i)

        @test isa(CategoricalArrays.pool(x), CategoricalPool)
        @test CategoricalArrays.pool(x) === pool
    end

    pool = CategoricalPool(
        [
            "a",
            "b",
            "c"
        ],
        Dict(
            "a" => DefaultRefType(1),
            "b" => DefaultRefType(2),
            "c" => DefaultRefType(3),
        ),
        [
            DefaultRefType(3),
            DefaultRefType(2),
            DefaultRefType(1),
        ]
    )

    @test isa(pool, CategoricalPool)

    @test isa(pool.index, Vector)
    @test length(pool.index) == 3
    @test pool.index[1] == "a"
    @test pool.index[2] == "b"
    @test pool.index[3] == "c"

    @test isa(pool.invindex, Dict)
    @test length(pool.invindex) == 3
    @test pool.invindex["a"] === DefaultRefType(1)
    @test pool.invindex["b"] === DefaultRefType(2)
    @test pool.invindex["c"] === DefaultRefType(3)

    @test isa(pool.order, Vector{DefaultRefType})
    @test length(pool.order) == 3
    @test pool.order[1] === DefaultRefType(3)
    @test pool.order[2] === DefaultRefType(2)
    @test pool.order[3] === DefaultRefType(1)

    for i in 1:3
        y = catvalue(i, pool)

        @test iscatvalue(y)

        @test isa(level(y), DefaultRefType)
        @test level(y) === DefaultRefType(i)

        @test isa(CategoricalArrays.pool(y), CategoricalPool)
        @test CategoricalArrays.pool(y) === pool
    end
end
