#' Swap main and alternative Experiments
#'
#' Swap the main Experiment for an alternative Experiment in a \linkS4class{SingleCellExperiment} object.
#'
#' @param x A \linkS4class{SingleCellExperiment} object.
#' @param name String or integer scalar specifying the alternative Experiment to use to replace the main Experiment.
#' @param saved String specifying the name to use to save the original \code{x} as an alternative experiment in the output.
#' If \code{NULL}, the original is not saved.
#' @param withColData Logical scalar specifying whether the column metadata of \code{x} should be preserved in the output.
#'
#' @return A SingleCellExperiment derived from \code{altExp(x, name)}.
#' This contains all alternative Experiments in \code{altExps(x)},
#' with an additional entry containing \code{x} if \code{saved} is specified.
#' If \code{withColData=TRUE}, the column metadata is set to \code{colData(x)}.
#' 
#' @details
#' During the course of an analysis, we may need to perform operations on each of the alternative Experiments in turn.
#' This would require us to repeatedly call \code{altExp(x, name)} prior to running downstream functions on those Experiments.
#' In such cases, it may be more convenient to switch the main Experiment with the desired alternative Experiments,
#' allowing a particular section of the analysis to be performed on the latter by default.
#' 
#' For example, the initial phases of the analysis might use the entire set of features.
#' At some point, we might want to focus only on a subset of features of interest,
#' but we do not want to discard the rest of the features.
#' This can be achieved by storing the subset as an alternative Experiment and swapping it with the main Experiment,
#' as shown in the Examples below.
#'
#' @author Aaron Lun
#' @seealso 
#' \code{\link{altExps}}, for a description of the alternative Experiment concept.
#' @examples
#' example(SingleCellExperiment, echo=FALSE) # using the class example
#'
#' # Let's say we defined a subset of genes of interest.
#' # We can save the feature set as its own altExp.
#' hvgs <- 1:10
#' altExp(sce, "subset") <- sce[hvgs,] 
#'
#' # At some point, we want to do our analysis on the HVGs only,
#' # but we want to hold onto the other features for later reference.
#' sce <- swapAltExp(sce, name="subset", saved="all")
#' sce
#' 
#' # Once we're done, it is straightforward to switch back.
#' swapAltExp(sce, "all") 
#' @export
swapAltExp <- function(x, name, saved=NULL, withColData=TRUE) {
    y <- altExp(x, name, withColData=withColData)
    y <- as(y, "SingleCellExperiment")
    altExps(y) <- altExps(x, withColData=FALSE)

    if (!is.null(saved)) {
        altExp(y, saved) <- removeAltExps(x)
    }
    y
}
