function k = standardSEKernDiagCompute(kern, x)

% RBFARDJITKERNDIAGCOMPUTE Compute diagonal of RBFARDJIT kernel.
% FORMAT
% DESC computes the diagonal of the kernel matrix for the automatic relevance determination radial basis function kernel given a design matrix of inputs.
% ARG kern : the kernel structure for which the matrix is computed.
% ARG x : input data matrix in the form of a design matrix.
% RETURN k : a vector containing the diagonal of the kernel matrix
% computed at the given points.
%
% SEEALSO : rbfard2KernParamInit, kernDiagCompute, kernCreate, rbfard2KernCompute
%
% COPYRIGHT : Neil D. Lawrence, 2004, 2005, 2006
%
% COPYRIGHT : Michalis K. Titsias, 2009
%
% COPYRIGHT : Steven Atkinson, 2017

% KERN


k = repmat(1 + kern.jitter, size(x, 1), 1);
