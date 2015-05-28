function noise = gaussianNoiseExpandParam(noise, params)

% GAUSSIANNOISEEXPANDPARAM Create noise structure from GAUSSIAN noise's parameters.
% FORMAT
% DESC returns a Gaussian noise structure filled with the
% parameters in the given vector. This is used as a helper function to
% enable parameters to be optimised in, for example, the NETLAB
% optimisation functions.
% ARG noise : the noise structure in which the parameters are to be
% placed.
% ARG param : vector of parameters which are to be placed in the
% noise structure.
% RETURN noise : noise structure with the given parameters in the
% relevant locations.
%
% SEEALSO : gaussianNoiseParamInit, gaussianNoiseExtractParam, noiseExpandParam
%
% COPYRIGHT : Neil D. Lawrence, 2004, 2005

% NOISE


noise.bias = params(1:end-1);
noise.sigma2 = params(end);
