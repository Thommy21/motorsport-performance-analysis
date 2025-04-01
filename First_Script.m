%% MATLAB Motorsport Analysis Script
clear all; close all; clc;

%% SECTION 1: Load and Prepare Data
% Load lap time data from CSV file
data = readtable('lap_times.csv');
laps = data.Lap;
lap_times = data.LapTime;
top_speeds = data.TopSpeed;
disp(data);

%% SECTION 2: Lap Time Analysis
% Plot Lap Time vs. Lap Number
figure;
plot(laps, lap_times, 'o-', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('Lap Number'); ylabel('Lap Time (seconds)');
title('Lap Time Analysis'); grid on;

% Fastest and Slowest Laps
[fastest_time, fastest_idx] = min(lap_times);
[slowest_time, slowest_idx] = max(lap_times);
disp(['Fastest Lap: ', num2str(fastest_idx), ' - ', num2str(fastest_time), ' sec']);
disp(['Slowest Lap: ', num2str(slowest_idx), ' - ', num2str(slowest_time), ' sec']);
hold on;
plot(laps(fastest_idx), fastest_time, 'gs', 'MarkerSize', 10, 'LineWidth', 2);
plot(laps(slowest_idx), slowest_time, 'rs', 'MarkerSize', 10, 'LineWidth', 2);
hold off;

% Lap-to-lap Differences
lap_differences = diff(lap_times);
disp('Lap Time Differences (compared to previous lap):');
disp(lap_differences);
figure;
plot(2:length(lap_times), lap_differences, '-o', 'LineWidth', 2);
xlabel('Lap Number'); ylabel('Time Difference (sec)');
title('Lap-to-Lap Time Change'); grid on;

% Statistics
lap_std = std(lap_times);
disp(['Lap Time Standard Deviation: ', num2str(lap_std), ' sec']);
avg_lap_time = mean(lap_times);
disp(['Predicted Next Lap Time (Average): ', num2str(avg_lap_time), ' sec']);

%% SECTION 3: Top Speed Analysis
figure;
plot(laps,top_speeds,'o-','Linewidth',2);
xlabel('lap number'); ylabel('top speeds(km/h)');
title('Top Speed Across Different Laps'); grid on;

figure;
plot(top_speeds,laps,'o-','Linewidth',2);
ylabel('lap number'); xlabel('top speeds(km/h)');
title('Top Speed Across Different Laps (Inverted)'); grid on;

figure;
scatter(top_speeds, lap_times, 'filled');
xlabel('Top Speed (km/h)'); ylabel('Lap Time (sec)');
title('Lap Time vs. Top Speed'); grid on;

figure;
scatter(lap_times,top_speeds,'filled');
ylabel('Top Speed (km/h)'); xlabel('Lap Time (sec)');
title('Lap Time vs. Top Speed (Flipped)'); grid on;

%% SECTION 4: Simulated Driver Stints
% Driver 1
for i = 1:10
    laptime(i) = 84.5 + 0.15*(i - 1) + randn()*0.3;
end
laptime(7) = laptime(7) + 2.5;

% Driver 2
for i = 1:10
    laptime2(i) = 84.2 + 0.12*(i - 1) + randn()*0.3;
end
laptime2(9) = laptime2(9) + 2.5;

% Plot Stints
figure;
plot(1:10, laptime, '-o', 'DisplayName', 'Driver 1'); hold on;
plot(1:10, laptime2, '-s', 'DisplayName', 'Driver 2');
plot(7, laptime(7), 'rx', 'MarkerSize', 12, 'LineWidth', 2);
plot(9, laptime2(9), 'rx', 'MarkerSize', 12, 'LineWidth', 2);
xlabel('Lap Number'); ylabel('Lap Time (sec)');
title('Simulated Stints: Driver Comparison'); legend; grid on; hold off;

%% SECTION 5: Sector Simulation
% Driver 1
for i = 1:10
    r = sort(rand(1,2));
    p = [r(1), r(2)-r(1), 1-r(2)];
    sectors1(:,i) = laptime(i) * p';
end

% Driver 2
for i = 1:10
    r = sort(rand(1,2));
    p = [r(1), r(2)-r(1), 1-r(2)];
    sectors2(:,i) = laptime2(i) * p';
end

% Sector Averages
avgsectors1 = mean(sectors1,2);
avgsectors2 = mean(sectors2,2);
disp('Driver 1 Sector Averages:'); disp(avgsectors1);
disp('Driver 2 Sector Averages:'); disp(avgsectors2);

figure;
bar([avgsectors1 avgsectors2]);
legend('Driver 1', 'Driver 2');
xlabel('Sector'); ylabel('Average Time (sec)');
title('Average Sector Times Comparison'); grid on;

%% SECTION 6: Top Speed Simulation
for i = 1:10
    topspeeds1(i) = 290 + randn()*2;
    topspeeds2(i) = 292 + randn()*2;
end

% Average Top Speed Plot
avgTop1 = mean(topspeeds1);
avgTop2 = mean(topspeeds2);
figure;
bar([avgTop1, avgTop2]);
set(gca, 'XTickLabel', {'Driver 1', 'Driver 2'});
ylabel('Average Top Speed (km/h)');
title('Average Top Speed Comparison'); grid on;

%% SECTION 7: Summary Table
lap = (1:10)';
driver1_times = laptime';
driver2_times = laptime2';
driver1_speeds = topspeeds1';
driver2_speeds = topspeeds2';

summary = table(lap, driver1_times, driver2_times, driver1_speeds, driver2_speeds, ...
    'VariableNames', {'Lap', 'Driver1_LapTime', 'Driver2_LapTime', 'Driver1_TopSpeed', 'Driver2_TopSpeed'});

disp('--- Stint Summary ---');
disp(summary);
%% SECTION 8: Tire Compound Simulation
compound='soft'

switch compound
    case 'soft'
        base_time = 83.5;         % Fastest base lap
        degradation = 0.25;       % High degradation
        noise = 0.2;              % Slight variability

    case 'medium'
        base_time = 84.0;         % Balanced
        degradation = 0.15;       % Moderate degradation
        noise = 0.2;

    case 'hard'
        base_time = 84.7;         % Slowest base lap
        degradation = 0.08;       % Low degradation
        noise = 0.2;
        
    otherwise
        error('Unknown compound selected.');
end

% Simulate lap times for 10 laps
for i = 1:10
    compound_laps(i) = base_time + degradation * (i - 1) + randn() * noise;
end

% Plot result
figure;
plot(1:10, compound_laps, '-o', 'LineWidth', 2);
xlabel('Lap');
ylabel('Lap Time (sec)');
title(['Simulated Stint on ', upper(compound), ' Tire']);
grid on;
%% SECTION 9: Compare All Tire Compounds

laps = 1:10;
noise = 0.2;

% Soft
base_soft = 83.5;
deg_soft = 0.25;
for i = 1:10
    soft_laps(i) = base_soft + deg_soft * (i - 1) + randn() * noise;
end

% Medium
base_medium = 84.0;
deg_medium = 0.15;
for i = 1:10
    medium_laps(i) = base_medium + deg_medium * (i - 1) + randn() * noise;
end

% Hard
base_hard = 84.7;
deg_hard = 0.08;
for i = 1:10
    hard_laps(i) = base_hard + deg_hard * (i - 1) + randn() * noise;
end

% Plot all
figure;
plot(laps, soft_laps, '-o', 'DisplayName', 'Soft'); hold on;
plot(laps, medium_laps, '-s', 'DisplayName', 'Medium');
plot(laps, hard_laps, '-^', 'DisplayName', 'Hard');
xlabel('Lap');
ylabel('Lap Time (sec)');
title('Tire Compound Comparison');
legend;
grid on;
%% SECTION 10: Two Drivers with Different Tire Compounds
laps = 1:10;
noise = 0.2;

% Soft
base_soft = 83.5;
deg_soft = 0.25;
for i = 1:10
    driver2_laps(i) = base_soft + deg_soft * (i - 1) + randn() * noise;
end

% Medium
base_medium = 84.0;
deg_medium = 0.15;
for i = 1:10
    driver1_laps(i) = base_medium + deg_medium * (i - 1) + randn() * noise;
end
[min_driver1, idx1] = min(driver1_laps);
[min_driver2, idx2] = min(driver2_laps);

%plot both driver laps with different compound
figure 
plot(laps,driver1_laps,'-o','DisplayName','MediumCompound');hold on
plot(laps,driver2_laps,'-s','DisplayName','SoftCompound');
% Fastest lap markers
plot(idx1, min_driver1, 'g*', 'MarkerSize', 10, 'LineWidth', 2,'DisplayName','best lap driver1');
plot(idx2, min_driver2, 'r*', 'MarkerSize', 10, 'LineWidth', 2,'DisplayName','best lap driver2');
xlabel('Lap');
ylabel('Lap Time(Sec)');
legend;
grid on;

%% tyre compound summary table
% Create delta
delta_laps = driver2_laps - driver1_laps;

% Build table
compound_summary = table(laps', driver1_laps', driver2_laps', delta_laps', ...
    'VariableNames', {'Lap', 'Medium_Compound', 'Soft_Compound', 'Delta_Soft_vs_Medium'});

% Display it
disp('--- Compound Comparison Summary ---');
disp(compound_summary);

