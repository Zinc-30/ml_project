%%
%% Convert data files from MATLAB format to SVMlight format
%%

File = cell(10, 1);
File{1} = 'australian_train';
File{2} = 'australian_test';
File{3} = 'breast-cancer_train';
File{4} = 'breast-cancer_test';
File{5} = 'diabetes_train';
File{6} = 'diabetes_test';
File{7} = 'german-numer_train';
File{8} = 'german-numer_test';
File{9} = 'heart_train';
File{10} = 'heart_test';

for fid = 1:10
  load(File{fid});
  X = full(X);
  fout = fopen(strcat(File{fid}, '.dat'), 'w');
  for i = 1:size(X, 1)
    fprintf(fout, '%i', Y(i) * 2 - 1);
    for j = 1:size(X, 2)
      fprintf(fout, ' %i:%f', j, X(i, j));
    end
    fprintf(fout, '\n');
  end
  fclose(fout);
end

