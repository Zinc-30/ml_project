@echo off
title run svm on datasets
rd /q /s svm_result
mkdir svm_result
for /f %%i in (./datasets.txt) do (
	echo. =======================[%%i]================================ >> .\svm_result\Result.txt
	echo. +++++linear model++++++++++ >> .\svm_result\Result.txt
	echo. ####learn#####:>> .\svm_result\Result.txt
	svm_learn.exe -t 0 .\datasets\%%i_train.dat .\svm_result\%%i_linearmodel >> .\svm_result\Result.txt
	echo. ####trainset####:>> .\svm_result\Result.txt
	svm_classify.exe .\datasets\%%i_train.dat .\svm_result\%%i_linearModel .\svm_result\%%i_linearPredict >> .\svm_result\Result.txt
	echo. ####testset####:>> .\svm_result\Result.txt
	svm_classify.exe .\datasets\%%i_test.dat .\svm_result\%%i_linearModel .\svm_result\%%i_linearPredict >> .\svm_result\Result.txt
	
	echo. +++++RBF model g=0.5++++++++++ >> .\svm_result\Result.txt
	echo. ####learn####:>> .\svm_result\Result.txt
	svm_learn.exe -t 2 -g 0.5 .\datasets\%%i_train.dat .\svm_result\%%i_rbfmodel >> .\svm_result\Result.txt
	echo. ####trainset####:>> .\svm_result\Result.txt
	svm_classify.exe .\datasets\%%i_train.dat .\svm_result\%%i_rbfmodel .\svm_result\%%i_rbfPredict >> .\svm_result\Result.txt
	echo. ####testset####:>> .\svm_result\Result.txt
	svm_classify.exe .\datasets\%%i_test.dat .\svm_result\%%i_rbfmodel .\svm_result\%%i_rbfPredict >> .\svm_result\Result.txt
)