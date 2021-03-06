\name{SCEnews}
\title{SingleCellExperiment News}
\encoding{UTF-8}

\section{Version 1.12.0}{\itemize{
\item Added the \code{rowSubset} function as a standard location for a row subset.
}}

\section{Version 1.10.0}{\itemize{
\item Removed deprecated modes for getting and setting \code{reducedDims}.

\item Added the \code{colLabels} function as a standard location for column labels.

\item Added more options to control \code{sizeFactors} behavior when size factors are missing.
}}

\section{Version 1.8.0}{\itemize{
\item Added altExp() and related methods to get and set alternative Experiments.

\item Added the splitAltExps() utility to create many alternative Experiments at once.

\item Added the swapAltExp() utility to swap between main and alternative Experiments.

\item Deprecated isSpike(), spikeNames() and related arguments for handling spike-ins,
in favor of representing spike-ins as alternative Experiments.

\item Deprecated type= in sizeFactors() and sizeFactorNames(), 
which were previously only required to store size factors for spike-ins.

\item Internal change to the representation of reducedDims() to streamline subsetting and combining.
}}

\section{Version 1.4.0}{\itemize{
\item Allow ... arguments to be passed to rowData() and colData().

\item Added weights() methods for getting/setting observational weights.

\item Added reducedDimNames<- method to set the names of reduced dimension slots.

\item Added withDimnames= argument to reducedDim() and reducedDims().

\item Exported getters and setters for internal metadata fields.

\item Added developer instructions for making use of internal metadata fields.
}}

\section{Version 1.2.0}{\itemize{
\item Added the clearSpikes() function to remove all spike-in information.

\item Added the clearSizeFactors() function to remove all size factor information.

\item Added the sizeFactorNames() function to query the available (named) size factor sets.

\item isSpike() with an unknown spike-in set in type= will no longer throw an error, and will quietly return NULL.

\item isSpike<- with type=NULL is deprecated in favour of clearSpikes() for removing existing spike-in information.
All spike-in sets must also be explicitly named during assignment.

\item Added the LinearEmbeddingMatrix class for storing dimensionality reduction with loadings.
}}

\section{Version 1.0.0}{\itemize{
\item
New package SingleCellExperiment, for representation of single-cell genomics data.
}}
