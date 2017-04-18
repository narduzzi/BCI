function [pca_signal latent]=pcasig(signal)

%signal=signal(1:64,:);
signal_norm=normr(signal');
[coeff, score, latent]=pca(signal_norm);
cum_var=cumsum(latent)/sum(latent);
figure();
plot(cum_var);
pca_signal=score;
end