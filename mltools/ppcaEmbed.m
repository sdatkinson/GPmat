function [X, sigma2, W, v, XCov] = ppcaEmbed(Y, dims)

% PPCAEMBED Embed data set with probabilistic PCA.
% FORMAT
% DESC returns latent positions for a given data set via probabilistic
% PCA.
% Parameters sigma2 and W are ML estimates.
% ARG Y : the data set which you want the latent positions for.
% ARG dims : the dimensionality of the latent space.
% RETURN X : the latent positions.
% RETURN sigma2 : the variance not explained by the latent positions.
% RETURN W : the matrix required to invert the transformation, Y=X*W.
% RETURN v : the eigenvalues of the decomposition
% RETURN XCov: the [diagonal] covariance of the Gaussian posterior p(x|t)
%   (returned as a dims x 1 vector)
%
% COPYRIGHT : Neil D. Lawrence, 2006
%
% SEEALSO : lleEmbed, isomapEmbed

% MLTOOLS

% Additional info:
%
% W is dims x d; each row is a basis vector of the uplifting transformation
%
% Prior p(x) = N(0, I)
% p(t|x) = N(t|xW + mu, sigma2 * I) % Note: t and x are row vectors
% p(t) = N(t|mu, W'*W
% Posterior: p(x|t) = N(x|(t-mu) * W * M^-1, sigma2 * M^-1)

if ~any(any(isnan(Y))) % Fully observed data
  if size(Y, 1)<size(Y, 2) % More dimensions than data
    Ymean = mean(Y);
    Ycentre = zeros(size(Y));
    for i = 1:size(Y, 1)
      Ycentre(i, :) = Y(i, :) -Ymean;
    end
    if size(Ycentre, 2)>30000
      % Bug in MATLAB 7.0 means you have to do this.
      innerY = zeros(size(Ycentre, 1));
      for i = 1:size(Ycentre, 1)
        innerY(i, :) = Ycentre(i, :)*Ycentre';
      end
    else
      innerY = Ycentre*Ycentre';
    end
    [v, u] = eigdec(innerY, dims); 
    v(v<0)=0;
    X = u(:, 1:dims)*sqrt(size(Y, 1));
    v = v/sqrt(size(Y, 1));
    sigma2 = (trace(innerY) - sum(v))/(size(Y, 2)-dims);
    W = X'*Ycentre;

  else % More data than dimensions
    [v, u] = pca(Y);
    v(v<0)=0;
%     Ymean = mean(Y);
%     Ycentre = zeros(size(Y));
%     for i = 1:size(Y, 2)
%       Ycentre(:, i) = Y(:, i) - Ymean(i);
%     end
    Ycentre = Y - mean(Y);
    X = Ycentre*u(:, 1:dims)*diag(1./sqrt(v(1:dims)));
    sigma2 = mean(v(dims+1:end));
%     W = X'*Ycentre;
    % Tipping & Bishop, 1999, Eq. 7:
    wML = diag(sqrt(v(1:dims) - sigma2)) * u(:, 1:dims)';  
    W = wML;
  end
else
  [X, sigma2, W, v] = missingData(Y, dims);
end

XCov = sigma2 ./ (diag(W * W') + sigma2);  % dims x 1

end


function [X, sigma2, W, v] = missingData(Y, dims)
% Hacky implementation of Probabilistic PCA for when there is missing data.
iters = 100;
% Initialise W randomly
d = size(Y, 2);
q = dims;
N = size(Y, 1);
W = randn(d, q)*1e-3;
sigma2 = 1;
mu = zeros(d, 1);
for i = 1:d
    obs = find(~isnan(Y(:, i)));
    if length(obs)>0
        mu(i) = mean(Y(obs, i));
    else
        mu(i) = 0;
    end
end
numObs = sum(sum(~isnan(Y)));
for i = 1:iters
    M = W'*W + sigma2*eye(q);
    invM = inv(M);
    exp_xxT = zeros(q);
    exp_x = zeros(N, q);
    for n = 1:N
        obs = find(~isnan(Y(n, :)));
        exp_x(n, :) = (invM*W(obs, :)'*(Y(n, obs)' - mu(obs)))';
    end
    exp_xxT = N*sigma2*invM + exp_x'*exp_x;
    s = zeros(d, q);
    s2 = 0;
    for n = 1:N
        obs = find(~isnan(Y(n, :)));
        subY = zeros(size(Y(n, :)))';
        subY(obs) = Y(n, obs)' - mu(obs);
        s = s + (subY)*exp_x(n, :);
        s2 = s2 + sum((Y(n, obs)' - mu(obs)).^2) - 2*exp_x(n, :)*W(obs, :)'*(Y(n, obs)' - mu(obs));
    end
    W = s*inv(exp_xxT);
    sigma2 = 1/(numObs)*(s2 + trace(exp_xxT*W'*W));
end

X = exp_x;
end
