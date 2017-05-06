function configuration = configuration_generator(n_row, n_max)
% Generate random bingo card.
%
% This function generates a random bingo card of the size n_field x n_field
% and with n_max being the highest number.
%
% Parameters:
%  n_row: Size of bingo card (n_row x n_row) @type int
%  n_max: Highest possible number on the bingo card @type int
%  configuration: The bingo card @type matrix

% Create random numbers [vector].
confi_vec = randperm(n_max,n_row^2);
% Create bingo card with random numbers [matrix].
configuration = reshape(confi_vec,[n_row,n_row]);