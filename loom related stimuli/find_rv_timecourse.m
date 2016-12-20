%% Part of code to generate looming related stimuli for reiserlab G3 panels.
% by MBR & MMM 2015

function [time_theta_array] = find_rv_timecourse(theta_min_in, theta_max_in, r_v_ratio, delta_t)

display_frequency=1/delta_t;  %in Hz

deg_to_rad=pi()/180;
theta_max=theta_max_in*deg_to_rad;
theta_min=theta_min_in*deg_to_rad;

min_collision_time = r_v_ratio/tan(theta_max/2); %time to collision for disc at theta_max.
max_collision_time = r_v_ratio/tan(theta_min/2); %time to collision for disc at theta_min.
total_collision_time = max_collision_time - min_collision_time;
num_frames = ceil(total_collision_time*display_frequency); %round up so we cover at least theta_min to theta_max.

time_theta_array(:,1) = -min_collision_time:-delta_t:-max_collision_time;
time_theta_array(:,2) = (180/pi)*2*atan2(r_v_ratio,(abs(time_theta_array(:,1))));

figure
plot(time_theta_array(:,1),time_theta_array(:,2),'.')
xlabel('time (sec)')
ylabel('Theta (deg)')
end
