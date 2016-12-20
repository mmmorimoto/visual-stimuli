%% Part of code to generate looming related stimuli for reiserlab G3 panels.
% by MBR & MMM 2015

%% << Caution: position function#0 refers to pattern frame#1  >>
clear all
directory_name = ''; % user directory

%% rv 10,40,70,130,310,550

deg2pos_conversion_corrected = 0.6*linspace(0.625,88.75,35);

pattern_name ='looming_patterns_';
func_freq = 64;
frame_length = 35;
dummy_frame_duration_1 = 0.5; % in sec
dummy_frame_duration_2 = 1.5; % in sec

dummy_frame_position_func_1 = zeros(1,func_freq*dummy_frame_duration_1);
dummy_frame_position_func_2 = zeros(1,func_freq*dummy_frame_duration_2);

rv_vector = [.010 .040 .070 .130 .310 .550]; % in sec
loom_duration = [400 400 400 500 1000 1600];
theta_min_in=5; %in degrees
theta_max_in=90; %in degrees
delta_t = 0.01; % in sec

for k = 1:length(rv_vector)
    
r_v_ratio = rv_vector(k);
time_theta_array_corrected = find_rv_timecourse(0.6*theta_min_in, 0.6*theta_max_in, r_v_ratio, delta_t);  

hold_duration = 1; % in sec

min_position_corrected=[];
for i = 1: length(time_theta_array_corrected(:,2))
    min_position_corrected(i) = radius_degs_2_pattern_pos_for_35pos_corrected(time_theta_array_corrected(i,2));
end

start_num_indices = hold_duration/delta_t;
end_num_indices = loom_duration(k) - (length(min_position_corrected)+ start_num_indices); 
start_padding = repmat(min_position_corrected(1), [1 start_num_indices]);
end_padding = repmat(min_position_corrected(end), [1 end_num_indices]);
full_position_index_corrected = [start_padding min_position_corrected end_padding] -1;

i=floor(linspace(1,loom_duration(k),64*(loom_duration(k)/100)));
x_position_func_corrected = full_position_index_corrected(i);
loom_stop_period= repmat(x_position_func_corrected(1),1,2*func_freq);
func_x_chan_corrected = [ dummy_frame_position_func_1  fliplr(x_position_func_corrected)  loom_stop_period  dummy_frame_position_func_2];

figure;
subplot(2,1,1)
plot(func_x_chan_corrected, '.')
title(['Full Min Position ', num2str(rv_vector(k)),' ',num2str(length(func_x_chan_corrected)/64), 'sec'])
xlabel('time (func freq 64)')
ylabel('Position Index')
legend('corrected')

subplot(2,1,2)
plot(deg2pos_conversion_corrected(func_x_chan_corrected+1), '.')
xlabel('time (func freq 64)')
ylabel('Disk size, degrees')

func = func_x_chan_corrected;
str = [directory_name '/position_function_', pattern_name,'X_', num2str(rv_vector(k)),'.mat']; 
save(str, 'func');


% backwards X func
func_x_chan = [dummy_frame_position_func_1  loom_stop_period  x_position_func_corrected  dummy_frame_position_func_2];

func = func_x_chan;
str = [directory_name '/position_function_', 'backwards_', pattern_name,'X_', num2str(rv_vector(k)),'.mat']; 
save(str, 'func');


% front Y func
func_y_chan_front = [zeros(1,length(func_x_chan_corrected))];
func = func_y_chan_front;
str = [directory_name '/position_function_', pattern_name,'Y_front_', num2str(rv_vector(k)),'.mat']; 
save(str, 'func');

% side Y func
func_y_chan_side = [ones(1,length(func_x_chan_corrected))];
func = func_y_chan_side;
str = [directory_name '/position_function_', pattern_name,'Y_side_', num2str(rv_vector(k)),'.mat']; 
save(str, 'func');

end
