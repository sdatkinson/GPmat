function [k, k2] = standardSEKernCompute(kern, x, x2)

% STANDARDSEKERNCOMPUTE Compute the RBFARD kernel given the parameters and 
% X.
% FORMAT
% DESC  Implementation of the rbfard2 kernel that allow for numerically 
%          robust computations (especially wrt to the variance of the 
%          kernel, ie. sigmaf^2) 
%
%          exp( - 0.5*sum_k (x_ik - x_jk)^2)  + jit*delta_ij
%
% FORMAT
% DESC computes the kernel matrix for the standardized SE kernel given a 
% design matrix of inputs.
% ARG kern : the kernel structure for which the matrix is computed.
% ARG x : input data matrix in the form of a design matrix.
% RETURN k : the kernel matrix computed at the given points.
%
% SEEALSO : rbfardjitKernParamInit, kernCompute, kernCreate, rbfardjitKernDiagCompute
%
% COPYRIGHT : Neil D. Lawrence, 2004, 2005, 2006
%
% COPYRIGHT : Michalis K. Titsias, 2009
%
% COPYRIGHT : Steven Atkinson, 2016

% KERN
    
if nargin < 3
  n2 = dist2(x, x);
  k2 = exp(-n2 * 0.5);
  k = k2 +  kern.jitter * eye(size(x,1));
else
  n2 = dist2(x, x2);
  k = exp(-n2 * 0.5);
  k2 = k;
end
