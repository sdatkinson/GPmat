function kern = standardSEKernParamInit(kern)

% STANDARDSEKERNPARAMINIT RBFARD2 kernel parameter initialisation.
% The RBF kernel without hyperparameters
% Includes jitter for stability reasons
%
% k(x_i, x_j) = 1 * [exp(-1/2 *(x_i - x_j)'*(x_i - x_j)) + jit*delta_ij]
%
% The parameters are sigma2, the process variance (kern.variance), the
% diagonal matrix of input scales (kern.inputScales, constrained to be
% positive). 
%
% SEEALSO : rbfKernParamInit
%
% FORMAT
% DESC initialises the automatic relevance determination radial basis function
%  kernel structure with some default parameters.
% ARG kern : the kernel structure which requires initialisation.
% RETURN kern : the kernel structure with the default parameters placed in.
%
% SEEALSO : kernCreate, kernParamInit
%
% COPYRIGHT : Neil D. Lawrence, 2004, 2005, 2006
%
% COPYRIGHT : Michalis K. Titsias, 2009

% KERN


% This parameter is restricted positive.
% kern.variance = 1;
% this is a fixed parameter
kern.jitter = 1e-5;
% kern.inputScales = 0.999*ones(1, kern.inputDimension);
kern.nParams = 0;

kern.transforms(1).index = [1:kern.nParams]; % Should be empty
kern.transforms(1).type = optimiDefaultConstraint('positive');

kern.isStationary = true;
