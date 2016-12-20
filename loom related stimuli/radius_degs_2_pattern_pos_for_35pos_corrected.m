%% Part of code to generate looming related stimuli for reiserlab G3 panels.
% by MBR & MMM 2015

function min_position = radius_degs_2_pattern_pos_for_35pos_corrected(input_degs)

% modified for current geometry
deg2pos_conversion = 0.6*linspace(0.625,88.75,35);

[val, index] = min(abs(input_degs - deg2pos_conversion));
min_position = index;

end

