% Rename all images in folder by sequential number.
%
% This script changes the name of all files with the file extension defined
% by "image_format" to a sequential number, e.g. if the file extension is
% png, all png files in the current folder will be renamed to "1.png",
% "2.png", ... and so on.

%% INITIALIZAION
% Define the image format for the files to be renamed.
image_format = 'png';

n_char_format = numel(image_format);
folder_file = dir;
n_file = numel(folder_file);
num_image = 1;
%% RENAMING ALL FILES WITH THE IMAGE FILE EXTENSION
for i_file = 1:n_file
    % The name of this file in the folder.
    this_file_name = folder_file(i_file).name;
    % Determin if this file has the image file extension.
    if numel(this_file_name) >= n_char_format
        is_image = strcmp( ...
            this_file_name(end-n_char_format+1:end),image_format);
    else
        is_image = false;
    end
    % If this file is a image, rename it with a sequential number.
    if is_image
        new_image_name = [num2str(num_image), '.', image_format];
        % Rename the image file.
        movefile(this_file_name, new_image_name);
        num_image = num_image + 1;
    end
end