# This tests the applySCE function.
# library(testthat); library(SingleCellExperiment); source("setup.R"); source("test-applySCE.R")

TESTFUN <- function(x, a=1, b=2, c=3) {
    list(X=x, ARGS=list(A=a, B=b, C=c))
}

test_that("applySCE works as expected", {
    def <- applySCE(loaded, FUN=TESTFUN)
    expect_identical(def[[1]]$X, loaded)
    expect_identical(def[[2]]$X, altExp(loaded, "Spike"))
    expect_identical(def[[3]]$X, altExp(loaded, "Protein"))
    expect_identical(unique(lapply(def, function(x) x$ARGS)), list(list(A=1, B=2, C=3)))

    # Trying with custom args.
    out <- applySCE(loaded, FUN=TESTFUN, which=list(
        AssayInput(assay="logcounts", a=-1),
        ReducedDimInput(type=2, b=-2, c=-10),
        AltExpInput(experiment="Protein")
    ), a=-100)

    expect_identical(out[[1]]$X, assay(loaded, "logcounts"))
    expect_identical(out[[2]]$X, reducedDim(loaded, 2))
    expect_identical(out[[3]]$X, altExp(loaded, "Protein"))

    # Overriding done correctly.
    expect_identical(out[[1]]$ARGS, list(A=-1, B=2, C=3))
    expect_identical(out[[2]]$ARGS, list(A=-100, B=-2, C=-10))
    expect_identical(out[[3]]$ARGS, list(A=-100, B=2, C=3))
})

test_that("applySCE retains names", {
    out <- applySCE(loaded, FUN=TESTFUN, which=list(
        helen=AssayInput(assay="logcounts", a=-1),
        sarah=ReducedDimInput(type=2, b=-2, c=-10),
        vanessa=AltExpInput(experiment="Protein")
    ), a=-100)

    expect_identical(names(out), c("helen", "sarah", "vanessa"))
})

test_that("applySCE errors out nicely", {
    expect_error(out <- applySCE(loaded, FUN=function(x) stop("YAY")), "YAY")
    expect_error(out <- applySCE(loaded, FUN=function(x) stop("YAY")), "failed on 'which[1]'", fixed=TRUE)
})

test_that("applySCE shorthand works as expected", {
    def <- applySCE(loaded, FUN=TESTFUN)
    short <- applySCE(loaded, FUN=TESTFUN, which=altExpNames(loaded))
    expect_identical(def, short)

    def <- applySCE(loaded, FUN=TESTFUN, which=list(MainExpInput(), AltExpInput(1)))
    short <- applySCE(loaded, FUN=TESTFUN, which=1)
    expect_identical(def, short)
})

test_that("simplification works correctly", {
    which <- list(MainExpInput(), AltExpInput("Spike"), AltExpInput("Protein"))
    results <- applySCE(loaded, FUN=identity, which=which)
    expect_identical(results, loaded)

    which <- list(MainExpInput(), AltExpInput("Spike"), AltExpInput("Spike"))
    raw <- applySCE(loaded, FUN=identity, which=which, SIMPLIFY=FALSE)
    expect_identical(raw, list(loaded, altExp(loaded), altExp(loaded)))

    which <- list(AltExpInput("Spike"), AltExpInput("Protein"))
    raw <- applySCE(loaded, FUN=identity, which=which)
    expect_identical(nrow(raw), 0L)
    expect_identical(altExps(raw), altExps(loaded)) 
})

test_that("simplification fails correctly", {
    which <- list(MainExpInput(), AltExpInput("Spike"), AltExpInput("Spike"))
    raw <- applySCE(loaded, FUN=identity, SIMPLIFY=FALSE, which=which)
    expect_warning(results <- simplifyToSCE(raw, which, loaded), "multiple references.*Spike")
    expect_error(results <- simplifyToSCE(raw, which, loaded, warn.level=3), "multiple references.*Spike")
    expect_null(results)

    which <- list(MainExpInput(), MainExpInput())
    raw <- applySCE(loaded, FUN=identity, SIMPLIFY=FALSE, which=which)
    expect_warning(results <- simplifyToSCE(raw, which, loaded), "multiple references.*main")
    expect_null(results)

    which <- list(MainExpInput(), AssayInput(1))
    raw <- applySCE(loaded, FUN=identity, SIMPLIFY=FALSE, which=which)
    expect_warning(results <- simplifyToSCE(raw, which, loaded, warn.level=1), NA)
    expect_warning(results <- simplifyToSCE(raw, which, loaded), "not a SummarizedExperiment")
    expect_null(results)

    set.seed(1000)
    which <- list(MainExpInput(), AltExpInput("Spike"))
    raw <- applySCE(loaded, FUN=function(x) { x[,sample(ncol(x), sample(ncol(x), 1))] }, SIMPLIFY=FALSE, which=which)
    expect_warning(results <- simplifyToSCE(raw, which, loaded, warn.level=0), NA)
    expect_warning(results <- simplifyToSCE(raw, which, loaded), "columns are different")
    expect_null(results)

    which <- list(MainExpInput(), AltExpInput("Spike"))
    raw <- applySCE(loaded, FUN=function(x) { as(x, "SummarizedExperiment") }, SIMPLIFY=FALSE, which=which)
    expect_warning(results <- simplifyToSCE(raw, which, loaded, warn.level=1), NA)
    expect_warning(results <- simplifyToSCE(raw, which, loaded), "not a SingleCellExperiment")
    expect_null(results)
})