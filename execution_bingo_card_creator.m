% Executable to create image bingo cards.
%
% This script will create stylish image bingo cards, where square images 
% are used instead of numbers. Instead of drawing numbers, a PowerPoint 
% presentation with the pictures can be used to play the game.
% A min. number of images drawn ("n_draw_min") can be set, before which no
% bingo card will win. This allows it to show most pictures used for the 
% game and preventing ending the game prematurely. After reaching
% "n_draw_min", for this and the two following draws only one bingo card
% will win. This prevents multiple people from winning at once.
% Additionaly to the pictures, graphic elemts are placed on the card to
% make them look better. Here, a picture and text is used as a header and a
% bar code, serial number (the serial number allows to identify cards that
% will win first) and a qr code are placed at the bottom of the card. 
% The pictures used for the bingo cards have to be named sequentially with
% the image file extension chosen (e.g. "1.png", "2.png" and so on). An
% additional script provided ("rename_all_image.m") allows to rename all
% pictures in a given folder accordingly.

%% INITIATION
% Number of fields on the bingo card (needs to be a square root of a
% natural number) [int].
n_field = 25;
% Amount of different pictures on the bingo card.
n_max = 37;
% Min. number of numbers drawn before the first bingo can occure (this can 
% be set to the row width for total randomness of the bingo cards) [int].
n_draw_min = 10;
% Number of valids cards that are created [int].
n_card = 5;
% Add a serial number to the bingo card as graphical element [vector]. 
% for a sequential serial number the lowest serial number will be the
% winning card. To prevent this the serial number vector can be set up not
% sequential, e.g.:
%series_number = [10001911688533 : 10001911688540, ...
%    10001911688532 : -1:  10001911688500];
series_number = 10009489661:10009489761;
% Define the order in which the pictures/numbers will be drawn at the bingo
% game [vector].
drawing_order = [20:50, 1:19];
% Image file extension [str].
image_file_ext = 'png';
% Initiate further variables.
width_pixel = 420;
hight_pixel = 594;
n_row = n_field ^0.5;
draw_order = randperm(n_max);
drawn_number = draw_order(1:n_draw_min);
drawn_number_p = draw_order(1:(n_draw_min+1));
drawn_number_pp = draw_order(1:(n_draw_min+2));
drawn_number_ppp = draw_order(1:(n_draw_min+3));
width_frame = 0.01;
width_subplot = 1/n_row - width_frame;
hight_subplot = width_subplot * width_pixel / hight_pixel;
configuration = cell(2,1);
is_reached = zeros(2,1);
best_total = zeros(2,1);
is_reached_p = zeros(2,1);
best_total_p = zeros(2,1);
is_reached_pp = zeros(2,1);
best_total_pp = zeros(2,1);
is_reached_ppp = zeros(2,1);
best_total_ppp = zeros(2,1);
%% CREATE THE BINGO CARDS
n_batch = 10;
for i_batch = 1:n_batch
    for i_run = 1:100000
        % Generate the numbers for a bingo card [matrix].
        configuration{i_run} = configuration_generator(n_row, n_max);
        [is_reached(i_run), best_total(i_run)] = ...
            configuration_evaluation(configuration{i_run}, drawn_number);
        [is_reached_p(i_run), best_total_p(i_run)] = ...
            configuration_evaluation(configuration{i_run}, drawn_number_p);
        [is_reached_pp(i_run), best_total_pp(i_run)] = ...
            configuration_evaluation(configuration{i_run}, drawn_number_pp);
        [is_reached_ppp(i_run), best_total_ppp(i_run)] = ...
            configuration_evaluation(configuration{i_run}, drawn_number_ppp);
    end
    % Test if enough configurations have been found so the that enough
    % cards exist that still have not won after "n_draw+2" draws [int].
    n_valid_card = sum(best_total_ppp <= 4) + 2;
    if n_valid_card >= n_card
        % Case: Enought cards exist, loop can be exited.
        break
    elseif i_batch == n_batch
        % Case: The max. number of configurations have been generated
        % without finding enough cards.
        error(['Not enough cards have been found. Either chose a higher ' ...
            'number of loop iterations or consider changing your ', ...
            'bingo requirement parameters.'])
    end
        
end
% Find all configurations that won't win till the min number of draws is
% reached [matrix].
test_neg = best_total == 4;
test_p_neg = best_total_p == 4;
test_p_pos = best_total_p == 5;
test_pp_neg = best_total_pp == 4;
test_pp_pos = best_total_pp == 5;
test_ppp_neg = best_total_ppp <= 4;
test_ppp_pos = best_total_ppp == 5;
% Identify the bingo cards that fullfil the requirements of not winning
% until a certain number of draws [matrix]. 
% Cards that will win after "n_draw_min" draws.
choice_first = find(test_neg .* test_p_pos);
% Cards that will win after "n_draw_min"+1 draws.
choice_second = find(test_p_neg .* test_pp_pos);
% Cards that will win after "n_draw_min"+2 draws.
choice_third = find(test_pp_neg .* test_ppp_pos);
% Cards that will win after "n_draw_min"+3 draws.
choice_fourth = find(test_ppp_neg);
% Select the bingo cards that will be turned into an image [matrix].
card_list(1) = choice_first(1);
card_list(2) = choice_second(1);
card_list(3) = choice_third(1);
card_list(4:n_card) = choice_fourth(1:n_card-3);

%% Load images. 

% Vertical position the pictures should start from.
picture_vertical_start = 0.1;

image_collection = cell(n_max,1);
image_name = cell(n_max,1);
for i_image = 1:n_max
    image_name{i_image} = [num2str(drawing_order(i_image)), '.', ...
        image_file_ext];
    % Set the backgroung color to white due to transparency.
    BG = [1,1,1];
    image_collection{i_image} = ...
        imread(image_name{i_image},'BackgroundColor',BG);
end

% Load the head picture.
image_head = imread('kopfzeile_2.png','BackgroundColor',BG);

% Load the barcode picture.
image_barcode = imread('barcode_2.png','BackgroundColor',BG);

% Load the qr code.
image_qr_code = imread('qr_code.png','BackgroundColor',BG);

%% Plot and save the bingo cards.
close all
for i_card = 1:n_card
    fh = figure(i_card);
    % Set up the new card variables.
    card_name = ['card_',num2str(i_card, '%03i'), '.' image_file_ext];
    this_card_arangement = configuration{card_list(i_card)};
    
    set(fh, 'Position', [0, 0, 420, 594]);
    % Set background color of the figure to white.
    %figure(i_card, 'Color',[1, 1, 1]);
    set(fh, 'Color',[1, 1, 1]);
    hold on
    for i_row = 1: n_row
        for i_column = 1: n_row
            i_plot = (i_row-1)*n_row + i_column;
            
            % Postition of this subplot.
            pos_left = (i_column - 1) * 0.2 + width_frame/2;
            pos_bot = (i_row - 1) * 0.1414 + width_frame/2 + ...
                picture_vertical_start;
            % Set subplot.
            subplot('Position',[pos_left pos_bot width_subplot hight_subplot])
            
            image(image_collection{this_card_arangement(i_row, i_column)})
            axis('off')
            axis('square')
            
            
%             disp(['Plot ' num2str(i_plot), ' Row ' num2str(i_row) ' Column ', ...
%                 num2str(i_column) ' Pos left ' num2str(pos_left) ' Pos bot ', ...
%                 num2str(pos_bot)]);
        end
    end
    
    % Add the Head of the picture.
    pos_head_left = 0.05;
    pos_head_bot = (0.1414 + width_frame/2) * 5 + picture_vertical_start;
    subplot('Position', [pos_head_left, pos_head_bot, 0.9, 0.123])
    image(image_head);
    axis('off')
    
    % Series number on the pictres bottom.
    series_number_text = ['Numeri di serie: ' num2str(series_number(i_card))];
    subplot('Position', [0.02, 0.003, 0.5, 0.015])
    text(0.01,1.0,series_number_text,'FontSize',6);
    axis('off')
    
    % Add the bar code 
    subplot('Position', [0.01, 0.028, 0.5, 0.02]);
    image(image_barcode)
    axis('off')
    
    % Add the QR code
    subplot('Position', [0.86, 0.01, 0.12, 0.12 * width_pixel / hight_pixel]);
    image(image_qr_code)
    axis('off')
    axis('square')
    
    hold off
    %axis('square')
    export_fig(card_name, '-r300')
    
end


