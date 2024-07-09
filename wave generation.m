close all;
clear all;
clc;

num_element = 16; % Number of elements in the array
num_seq = (0:1:num_element-1).'; % Generating a column vector from 0 to num_element-1

f = 3 * 1e9; % Frequency in Hz (3 GHz)
c = 3 * 1e8; % Speed of light in m/s (3x10^8 m/s)
lambda = c / f; % Wavelength in meters (m)

beta = 2 * pi / lambda; % Wave number

distance_array = 50 * 1e-3; % Distance between array elements in meters (50 mm)

% Desired angles
theta_deg = (-90:1:90).'; % Angles from -90 to 90 degrees
theta_rad = theta_deg * pi / 180; % Converting angles from degrees to radians

for angle_idx = 1:numel(theta_deg)
    theta_d = theta_deg(angle_idx); % Desired angle in degrees
    
    % Create a folder for each angle
    folder_name = fullfile('images', ['angle_', num2str(theta_d)]);
    if ~exist(folder_name, 'dir')
        mkdir(folder_name);
    end
    
    % Initialize array factor
    array_factor = exp(-1j * beta * num_seq * distance_array * sin(theta_rad(angle_idx)).');
    
    % Generate all possible phase combinations for all elements
    phase_combinations = deg2rad(0:359).' * (0:num_element-1);
    
    for phase_idx = 1:360 % Generate 360 images per angle
        % Constructing the array factor using the equation exp(-j * beta * m * d * sin(theta))
        array_factor_phase = array_factor .* exp(1j * phase_combinations(phase_idx, :));
        
        % Calculating the sum pattern using the beamforming weight vector
        sum_pattern = sum(abs(array_factor_phase), 1);
        
        % Create a new figure
        fig = figure('Visible', 'off');
        plot(theta_deg.', 20 * log10(sum_pattern)); % Transpose theta_deg
        axis([-90 90 -20 20]);
        xlabel('Angle (degrees)');
        ylabel('Magnitude (dB)');
        title(['Angle: ', num2str(theta_d), ', Phase: ', num2str(phase_idx)]);
        
        % Save the plot as an image
        plot_filename = fullfile(folder_name, ['angle_', num2str(theta_d), '_', num2str(phase_idx), '.png']);
        saveas(fig, plot_filename);
        close(fig); % Close the figure to avoid displaying it
    end
end


