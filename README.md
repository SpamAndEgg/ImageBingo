# ImageBingo
Generate image bingo cards (Matlab).

The executable Matlab script is "execution_bingo_card_creator".
This script will create stylish image bingo cards, where square images 
are used instead of numbers. Instead of drawing numbers, a PowerPoint 
presentation with the pictures can be used to play the game.
A min. number of images drawn ("n_draw_min") can be set, before which no
bingo card will win. This allows it to show most pictures used for the 
game and preventing ending the game prematurely. After reaching
"n_draw_min", for this and the two following draws only one bingo card
will win. This prevents multiple people from winning at once.
Additionaly to the pictures, graphic elemts are placed on the card to
make them look better. Here, a picture and text is used as a header and a
bar code, serial number (the serial number allows to identify cards that
will win first) and a qr code are placed at the bottom of the card. 
The pictures used for the bingo cards have to be named sequentially with
the image file extension chosen (e.g. "1.png", "2.png" and so on). An
additional script provided ("rename_all_image.m") allows to rename all
pictures in a given folder accordingly.
