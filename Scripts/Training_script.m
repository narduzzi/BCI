load('features_extracted_2241fft_60000.mat','features_extracted');

features_extracted_eh = features_extracted(1:40002,:);
shuffledArray_eh = features_extracted_eh(randperm(size(features_extracted_eh,1)),:);
