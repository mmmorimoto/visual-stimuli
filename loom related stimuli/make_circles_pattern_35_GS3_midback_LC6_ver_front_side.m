%% Part of code to generate looming related stimuli for reiserlab G3 panels.
% by MBR & MMM 2015

%% make the image of an expanding disc for a grayscale = 3 pattern
clear all

img_x_dim = 64;
img_y_dim = 64;

blank_image = ones(img_x_dim, img_y_dim);

disc_rad = 0.25:0.75:26;

for k = 1:length(disc_rad)
    Pattern(k).image = blank_image;
    
    for x_ind = 1:img_x_dim
        for y_ind = 1:img_y_dim
            in_circle = circle_inequality(x_ind, 32.5, y_ind, 32.5, disc_rad(k));
            if in_circle
                Pattern(k).image(x_ind, y_ind) = 1/4;
            end
        end
    end
end

for k = 1:length(disc_rad)
    %Pattern(k).ds_image = imresize(Pattern(k).image, 0.25);
    for x_ind = 1:(img_x_dim/2) % 1:32
        for y_ind = 1:(img_y_dim/2) % 1:32
            x_range = [1:2] + 2*(x_ind-1); 
            y_range = [1:2] + 2*(y_ind-1); 
            Pattern(k).ds_image(x_ind, y_ind) = floor((3/4)*(sum(sum(Pattern(k).image(x_range,y_range)))));
        end
    end
     k     
     imagesc(Pattern(k).ds_image)
     pause(0.1)
end

% to get disc to end on black frame, just mask out the edges in the last
% few frames. Use index 33 as final size of disc
[X,Y] = find(Pattern(33).ds_image ~=3);

for k = 34:length(disc_rad)
    tmp_image = Pattern(k).ds_image;
      
    Pattern(k).ds_image = 3*ones(size(Pattern(k).ds_image));
    
    for p_ind = 1:length(X)
       Pattern(k).ds_image(X(p_ind), Y(p_ind)) = tmp_image(X(p_ind), Y(p_ind));      
    end
end


%% now make a pattern

pattern.x_num = length(disc_rad);  %% one dummy frame 
pattern.y_num = 2;   %% front and side
pattern.num_panels = 48;
pattern.gs_val = 3;
pattern.row_compression = 0;

Pats = 3*ones(32, 96, pattern.x_num, pattern.y_num);

for i = 1:pattern.x_num
    Pats(9:32,5:36,i,1) = Pattern(i).ds_image(5:28,:);
   
     Pats(:,:,i,1) = ShiftMatrix(Pats(:,:,i,1),28,'r','y'); % front 0deg
     Pats(:,:,i,2) = circshift(Pats(:,:,i,1), [0 20 0 0]); % side 45deg
    
end

%% complete the pattern
pattern.Pats = Pats;
pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1; 24 20 16 23 19 15 22 18 14 21 17 13; 36 32 28 35 31 27 34 30 26 33 29 25; 48 44 40 47 43 39 46 42 38 45 41 37];
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

directory_name = ''; % user directory
str = [directory_name '/Pattern_expanding_disc_dark_35_GS3_LC6_ver_front_side'];

save(str, 'pattern');

