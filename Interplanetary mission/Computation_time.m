clear, clc, close all;

T_elapsed = 3.5480;
N = 100;
k = T_elapsed / N^3;

T_max = 7 * 60^2;
n = (T_max / k)^(1/3)

n_max = 150;
T = k * n_max^3