function [is_reached, best_total] = configuration_evaluation(configuration, drawn_number)
% Test what the max. number of selected numbers in a row is.
%
% This function gives out the max. number of selected numbers in a row on a
% bingo card (configuration) and if a bingo occured.
%
% Parameters:
%  configuration: Bingo card @type matrix
%  drawn_number: All numbers drawn @type matrix
%  is_reached: States if a bingo was reached @type boolean
%  best_total: Most numbers hit in any valid row @type int

%% INITIATION
test_confi = false(size(configuration));
n_number = numel(drawn_number);
%% CHECK BINGO CARD
for i_number = 1:n_number
    [index_x, index_y] = find(configuration == drawn_number(i_number));
    test_confi(index_x, index_y) = true;
end
% Max. number hits in horizontal, vertical and diagonal row [int].
best_horizontal = max(sum(test_confi,1));
best_vertical = max(sum(test_confi,2));
best_diagonal = trace(test_confi);
best_diagonal_transposed = trace(test_confi');
% Max. number hits in any valid row [int].
best_total = max([best_horizontal, best_vertical, best_diagonal, ...
    best_diagonal_transposed]);
% Determin if a bingo is reached [boolean].
is_reached = best_total == size(test_confi,1);