function [WL] = wavelength(signal)
WL = mean(abs(diff(signal,[],2)),2);
end