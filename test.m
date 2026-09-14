clc;
clear;

% Parameters
numParticles = 50;        % Number of particles
dim1 = 1;                  
dim = 2*dim1;               % Number of dimensions (3 for DG sizes and 3 for DG locations)
maxIter = 500;            % Maximum number of iterations
w = 0.5;                  % Inertia weight
c1 = 2.05;                 % Cognitive (personal) coefficient
c2 = 2.05;                 % Social (global) coefficient
crazinessFactor = 0.2;    % Craziness factor
% Define voltage thresholds
voltageLowerThreshold = 0.9;
voltageUpperThreshold = 1.05;

% Problem boundaries
lb = [zeros(1, dim1), ones(1, dim1)];  % Lower bounds for DG sizes and bus indices
ub = [2000 * ones(1, dim1), 69 * ones(1, dim1)];  % Upper bounds for DG sizes and bus indices

% Branch data: [from_bus, to_bus, resistance, reactance]
branchData = [1,2,0.000500000000000000,0.00120000000000000;2,3,0.000500000000000000,0.00120000000000000;3,4,0.00150000000000000,0.00360000000000000;4,5,0.0251000000000000,0.0294000000000000;5,6,0.366000000000000,0.186400000000000;6,7,0.381100000000000,0.194100000000000;7,8,0.0922000000000000,0.0470000000000000;8,9,0.493000000000000,0.0251000000000000;9,10,0.819000000000000,0.270700000000000;10,11,0.187200000000000,0.0619000000000000;11,12,0.711400000000000,0.235100000000000;12,13,1.03000000000000,0.340000000000000;13,14,1.04400000000000,0.345000000000000;14,15,1.05800000000000,0.349600000000000;15,16,0.196600000000000,0.0650000000000000;16,17,0.374400000000000,0.123800000000000;17,18,0.00470000000000000,0.00160000000000000;18,19,0.327600000000000,0.108300000000000;19,20,0.210600000000000,0.0696000000000000;20,21,0.341600000000000,0.112900000000000;21,22,0.0140000000000000,0.00460000000000000;22,23,0.159100000000000,0.0526000000000000;23,24,0.346300000000000,0.114500000000000;24,25,0.748800000000000,0.247500000000000;25,26,0.308900000000000,0.102100000000000;26,27,0.173200000000000,0.0572000000000000;3,28,0.00440000000000000,0.0108000000000000;28,29,0.0640000000000000,0.156500000000000;29,30,0.397800000000000,0.131500000000000;30,31,0.0702000000000000,0.0232000000000000;31,32,0.351000000000000,0.116000000000000;32,33,0.839000000000000,0.281600000000000;33,34,1.70800000000000,0.564600000000000;34,35,1.47400000000000,0.487300000000000;3,36,0.00440000000000000,0.0108000000000000;36,37,0.0640000000000000,0.156500000000000;37,38,0.105300000000000,0.123000000000000;38,39,0.0304000000000000,0.0355000000000000;39,40,0.00180000000000000,0.00210000000000000;40,41,0.728300000000000,0.850900000000000;41,42,0.310000000000000,0.362300000000000;42,43,0.0410000000000000,0.0478000000000000;43,44,0.00920000000000000,0.0116000000000000;44,45,0.108900000000000,0.137300000000000;45,46,0.000900000000000000,0.00120000000000000;4,47,0.00340000000000000,0.00840000000000000;47,48,0.0851000000000000,0.208300000000000;48,49,0.289800000000000,0.709100000000000;49,50,0.0822000000000000,0.201100000000000;8,51,0.0928000000000000,0.0473000000000000;51,52,0.331900000000000,0.111400000000000;9,53,0.174000000000000,0.0886000000000000;53,54,0.203000000000000,0.103400000000000;54,55,0.284200000000000,0.144700000000000;55,56,0.281300000000000,0.143300000000000;56,57,1.59000000000000,0.533700000000000;57,58,0.783700000000000,0.263000000000000;58,59,0.304200000000000,0.100600000000000;59,60,0.386100000000000,0.117200000000000;60,61,0.507500000000000,0.258500000000000;61,62,0.0974000000000000,0.0496000000000000;62,63,0.145000000000000,0.0738000000000000;63,64,0.710500000000000,0.361900000000000;64,65,1.04100000000000,0.530200000000000;11,66,0.201200000000000,0.0611000000000000;66,67,0.00470000000000000,0.00140000000000000;12,68,0.739400000000000,0.244400000000000;68,69,0.00470000000000000,0.00160000000000000];

% Bus data: [bus_number, voltage, angle, load_P, load_Q]
busData = [1,0,0;2,0,0;3,0,0;4,0,0;5,0.00260000000000000,0.00220000000000000;6,0.0404000000000000,0.0300000000000000;7,0.0750000000000000,0.0540000000000000;8,0.0300000000000000,0.0220000000000000;9,0.0280000000000000,0.0190000000000000;10,0.145000000000000,0.104000000000000;11,0.145000000000000,0.104000000000000;12,0.00800000000000000,0.00550000000000000;13,0.00800000000000000,0.00550000000000000;14,0,0;15,0.0455000000000000,0.0300000000000000;16,0.0600000000000000,0.0350000000000000;17,0.0600000000000000,0.0350000000000000;18,0,0;19,0.00100000000000000,0.000600000000000000;20,0.114000000000000,0.0810000000000000;21,0.00530000000000000,0.00350000000000000;22,0,0;23,0.0280000000000000,0.0200000000000000;24,0,0;25,0.0140000000000000,0.0100000000000000;26,0.0140000000000000,0.0100000000000000;27,0.0260000000000000,0.0186000000000000;28,0.0260000000000000,0.0186000000000000;29,0,0;30,0,0;31,0,0;32,0.0140000000000000,0.0100000000000000;33,0.0195000000000000,0.0140000000000000;34,0.00600000000000000,0.00400000000000000;35,0.0260000000000000,0.0186000000000000;36,0.0260000000000000,0.0186000000000000;37,0,0;38,0.0240000000000000,0.0170000000000000;39,0.0240000000000000,0.0170000000000000;40,0.00120000000000000,0.00100000000000000;41,0,0;42,0.00600000000000000,0.00430000000000000;43,0,0;44,0.0392000000000000,0.0263000000000000;45,0.0392000000000000,0.0263000000000000;46,0,0;47,0.0790000000000000,0.0564000000000000;48,0.384700000000000,0.274500000000000;49,0.384700000000000,0.274500000000000;50,0.0405000000000000,0.0283000000000000;51,0.00360000000000000,0.00270000000000000;52,0.00440000000000000,0.00350000000000000;53,0.0264000000000000,0.0190000000000000;54,0.0240000000000000,0.0172000000000000;55,0,0;56,0,0;57,0,0;58,0.100000000000000,0.0720000000000000;59,0,0;60,1.24400000000000,0.888000000000000;61,0.0320000000000000,0.0230000000000000;62,0,0;63,0.227000000000000,0.162000000000000;64,0.0590000000000000,0.0420000000000000;65,0.0180000000000000,0.0130000000000000;66,0.0180000000000000,0.0130000000000000;67,0.0280000000000000,0.0200000000000000;68,0.0280000000000000,0.0200000000000000];

baseMVA = 11;

% Compute total active power loss without DGs
[~,~,totalActivePowerLossWithoutDGs] = fitnessFunctionWithoutDGs(branchData, busData, voltageLowerThreshold, voltageUpperThreshold);
disp('Total Active Power Loss without DGs:');
disp(totalActivePowerLossWithoutDGs);

% Initialize particle positions and velocities
pos = zeros(numParticles, dim);
for i = 1:dim
    pos(:, i) = lb(i) + rand(numParticles, 1) * (ub(i) - lb(i));
end
vel = zeros(numParticles, dim);

% Initialize personal best positions and global best position
pBest = pos;
pBestFitness = inf(numParticles, 1);
[gBestFitness, gBestIdx] = min(pBestFitness);
gBest = pos(gBestIdx, :);

% Main loop
for iter = 1:maxIter
    % Evaluate fitness
    dgLocations=round(pos(:,dim1+1:end))';
    dgCapacities=pos(:,1:dim1)';
    fitness = arrayfun(@(i) fitnessFunction(branchData, busData, dgLocations(i), dgCapacities(i), voltageLowerThreshold, voltageUpperThreshold), 1:numParticles)';
    
    % Update personal best
    for i = 1:numParticles
        if fitness(i) < pBestFitness(i)
            pBest(i, :) = pos(i, :);
            pBestFitness(i) = fitness(i);
        end
    end
    
    % Update global best
    [newGBestFitness, newGBestIdx] = min(pBestFitness);
    if newGBestFitness < gBestFitness
        gBest = pBest(newGBestIdx, :);
        gBestFitness = newGBestFitness;
    end
    
    % Craziness operation
    if rand < crazinessFactor
        % Randomly perturb velocities or positions
        vel = vel + crazinessFactor * (rand(size(vel)) - 0.5) .* (repmat(ub - lb, numParticles, 1));
    end
    
    % Update velocities and positions
    for i = 1:numParticles
        vel(i, :) = w * vel(i, :) ...
                    + c1 * rand * (pBest(i, :) - pos(i, :)) ...
                    + c2 * rand * (gBest - pos(i, :));
                
        pos(i, :) = pos(i, :) + vel(i, :);
        
        % Apply boundary conditions
        pos(i, :) = max(min(pos(i, :), ub), lb);
    end
    
    % Display iteration info
%     fprintf('Iteration %d: Best Fitness = %f\n', iter, gBestFitness);
end

fprintf('Best Fitness = %f\n', gBestFitness);
% Define voltage thresholds
voltageLowerThreshold = 0.95;
voltageUpperThreshold = 1.05;

% Extract the DG location and capacity from the best solution
dgSize = gBest(1:dim1);
dgLocation = round(gBest(dim1+1:end)); % Bus index

disp('DG Location (Bus Number):');
disp(dgLocation);
disp('DG Capacity:');
disp(dgSize);

% Calculate voltages
% Calculate the voltages and fitness without DGs
[V_withoutDGs, I_withoutDGs, fitnessWithoutDGs] = fitnessFunctionWithoutDGs(branchData, busData, voltageLowerThreshold, voltageUpperThreshold);

% Calculate the voltages and fitness with DGs
[V_withDGs, I_withDGs, fitnessWithDGs] = fitnessFunctionWithDGs(branchData, busData, dgLocation, dgSize, voltageLowerThreshold, voltageUpperThreshold);

disp('Voltages without DGs:');
V_withoutDGs=abs(real(V_withoutDGs));
disp(V_withoutDGs);

disp('Voltages with DGs:');
V_withDGs=abs(real(V_withDGs));
disp(V_withDGs);

% Display voltages at each DG location
% disp('Voltages at DG Locations:');
% V_DG = abs(real(V));
% V_DG=[1;V_DG];
% for i=1:length(V_DG)
%     if abs(V_DG(i)) < voltageLowerThreshold
%         V_DG(i) = voltageLowerThreshold;
%     elseif abs(V_DG(i)) > voltageUpperThreshold
%         V_DG(i) = voltageUpperThreshold;
%     end
% end
% I_DG = abs(real(I));
% disp(V_DG(dgLocation));
% 
% disp('Current at DG Locations:');
% disp(I_DG(dgLocation));

% Fitness function for total active power loss
function totalLoss = fitnessFunction(branchData, busData, dgLocations, dgCapacities, voltageLowerThreshold, voltageUpperThreshold)
    % Adjust the load data at DG locations
    numBuses = size(busData, 1);
    adjustedBusData = busData; % Create a copy to adjust
    
    for i = 1:length(dgLocations)
        dgLocation = dgLocations(i);
        dgCapacity = dgCapacities(i);
        if dgLocation <= numBuses
            adjustedBusData(dgLocation, 3) = adjustedBusData(dgLocation, 3) - dgCapacity;  % Adjust the active power demand
        end
    end
    
    % Calculate the voltages and currents using Backward-Forward Sweep
    [V, I] = backwardForwardSweep(adjustedBusData, branchData, voltageLowerThreshold, voltageUpperThreshold);
    
    % Calculate the total active power loss
    totalLoss = 0;
    numBranches = size(branchData, 1);
    for i = 1:numBranches
        resistance = branchData(i, 3);
        P_loss = resistance * abs(I(i))^2;
        totalLoss = totalLoss + P_loss;
    end
end

function [V, I, totalLoss] = fitnessFunctionWithDGs(branchData, busData, dgLocations, dgCapacities, voltageLowerThreshold, voltageUpperThreshold)
    % Adjust the load data at DG locations
    numBuses = size(busData, 1);
    adjustedBusData = busData; % Create a copy to adjust
    
    for i = 1:length(dgLocations)
        dgLocation = dgLocations(i);
        dgCapacity = dgCapacities(i);
        if dgLocation <= numBuses
            adjustedBusData(dgLocation, 3) = adjustedBusData(dgLocation, 3) - dgCapacity;  % Adjust the active power demand
        end
    end
    
    % Calculate the voltages and currents using Backward-Forward Sweep
    [V, I] = backwardForwardSweep(adjustedBusData, branchData, voltageLowerThreshold, voltageUpperThreshold);
    
    % Calculate the total active power loss
    totalLoss = 0;
    numBranches = size(branchData, 1);
    for i = 1:numBranches
        resistance = branchData(i, 3);
        P_loss = resistance * abs(I(i))^2;
        totalLoss = totalLoss + P_loss;
    end
end


% Backward-Forward Sweep Function
function [V, I] = backwardForwardSweep(busData, branchData, voltageLowerThreshold, voltageUpperThreshold)
    numBuses = size(busData, 1);
    numBranches = size(branchData, 1);
    
    % Initialize bus voltages and branch currents
    V = ones(numBuses, 1);  % All buses start with voltage 1.0 p.u.
    I = zeros(numBranches, 1);  % Initialize branch currents to zero
    
    maxIter = 100;
    tol = 1e-6;
    
    for iter = 1:maxIter
        % Backward Sweep: Calculate branch currents
        for i = numBranches:-1:1
            fromBus = branchData(i, 1);
            toBus = branchData(i, 2);
            resistance = branchData(i, 3);
            reactance = branchData(i, 4);
            
            % Current contribution from the load at the toBus
            if toBus <= numBuses
                I(i) = conj((busData(toBus, 2) + 1j * busData(toBus, 3)) / V(toBus));
                I(i) = I(i) + sum(I(branchData(:, 2) == toBus));
            end
        end
        
        % Forward Sweep: Update bus voltages
        V_prev = V;
        for i = 1:numBranches
            fromBus = branchData(i, 1);
            toBus = branchData(i, 2);
            resistance = branchData(i, 3);
            reactance = branchData(i, 4);
            
            if toBus <= numBuses
                V(toBus) = V(fromBus) - (resistance + 1j * reactance) * I(i);
                % Ensure voltage is within the thresholds
%                 if abs(V(toBus)) < voltageLowerThreshold
%                     V(toBus) = voltageLowerThreshold;
%                 elseif abs(V(toBus)) > voltageUpperThreshold
%                     V(toBus) = voltageUpperThreshold;
%                 end
            end
        end
        
        % Check for convergence
        if max(abs(V - V_prev)) < tol
            break;
        end
    end
    
    % Final voltage threshold enforcement
%     for i = 1:numBuses
%         if abs(V(i)) < voltageLowerThreshold
%             V(i) = voltageLowerThreshold;
%         elseif abs(V(i)) > voltageUpperThreshold
%             V(i) = voltageUpperThreshold;
%         end
%     end
end



function [V,I,totalLoss] = fitnessFunctionWithoutDGs(branchData, busData, voltageLowerThreshold, voltageUpperThreshold)
    % Calculate the voltages and currents using Backward-Forward Sweep
    [V, I] = backwardForwardSweep(busData, branchData, voltageLowerThreshold, voltageUpperThreshold);
    
    % Calculate the total active power loss
    totalLoss = 0;
    numBranches = size(branchData, 1);
    for i = 1:numBranches
        resistance = branchData(i, 3);
        P_loss = resistance * abs(I(i))^2;
        totalLoss = totalLoss + P_loss;
    end
end


