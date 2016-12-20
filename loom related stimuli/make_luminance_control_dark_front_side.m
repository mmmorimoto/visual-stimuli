%% Part of code to generate looming related stimuli for reiserlab G3 panels.
% by MBR & MMM 2015

%% make luminance control for the loom pattern

% load the original looming disc stimulus
directory_name = ''; % user directory
str = [directory_name '/Pattern_expanding_disc_dark_35_GS3_LC6_ver_front_side'];

load(str);

loom_Pats = pattern.Pats;

pattern.Pats = 3*ones(size(loom_Pats));

[P_height, P_width, loom_frames, loom_pos] = size(loom_Pats);

% for first position of loom
final_image = (squeeze((loom_Pats(:,:,loom_frames,1))));

% pull out all indices not equal to background in the final image
[X,Y] = find(final_image ~= 3); % X and Y are indices to points within the disc
num_pixels = length(X)


% instead of gap method below could alternativly use random speckle
rand_ind = randperm(length(X));

for k = 1:loom_frames
    % goal is to make a new image, within the size of the disc with the same mean luminace
    run_sum = 0;
    for j = 1:num_pixels
       pat_vect(j) = loom_Pats(X(j), Y(j), k, 1);
    end
     
    lum_avg(k) = mean(pat_vect);
    
    mx_lum = ceil(lum_avg(k)); % highest intensity to use
    mn_lum = floor(lum_avg(k)); % lowest intensity
    
    tmp_circ = mx_lum*ones(1,num_pixels); 
    
    if mx_lum ~= mn_lum % if not all pixels are same value, implement a mixture
       num_mn = 1; % iterate until you have enough of mn_lum points to match the avg 
       while mean(tmp_circ) > lum_avg(k)
           tmp_circ = mx_lum*ones(1,num_pixels); 
           pix_gap = (num_pixels/(num_mn+1)); % instead of gap, could use random speckle
           pix_pos = round(1:pix_gap:num_pixels);
           % If uniform
           %tmp_circ(pix_pos) = mn_lum;
           % If random speckle
           tmp_circ(rand_ind(1:num_mn)) = mn_lum;
           num_mn = num_mn+1;
       end
       
    end
    tm_avg(k) = mean(tmp_circ);
    tm_circ_mat(k,:) = tmp_circ;
    
    for j = 1:num_pixels
        pattern.Pats(X(j), Y(j), k, 1) = tmp_circ(j);
    end
end
figure; % plot the mean luminance for both patterns
plot(lum_avg)
hold all
plot(tm_avg)

for i = 1:35
     pattern.Pats(:,:,i,2) = circshift(pattern.Pats(:,:,i,1), [0 20 0 0]); % side 45deg 
end
    
%%
pattern.data = Make_pattern_vector(pattern);

str = [directory_name '/Pattern_luminance_loom_control_dark_front_side'];

save(str, 'pattern');
