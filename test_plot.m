clc;
clear;

% Parameters
numParticles = 50;        % Number of particles
dim1 = 5;                  
dim = 2*dim1;               % Number of dimensions (dim1 for DG sizes and dim1 for DG locations)
maxIter = 50;            % Maximum number of iterations
w = 0.5;                  % Inertia weight
c1 = 2.05;                 % Cognitive (personal) coefficient
c2 = 2.05;                 % Social (global) coefficient
crazinessFactor = 0.8;    % Craziness factor
% Define voltage thresholds
voltageLowerThreshold = 0.9;
voltageUpperThreshold = 1.05;

% Problem boundaries
lb = [zeros(1, dim1), ones(1, dim1)];  % Lower bounds for DG sizes and bus indices
ub = [2000 * ones(1, dim1), 135 * ones(1, dim1)];  % Upper bounds for DG sizes and bus indices

% Branch data: [from_bus, to_bus, resistance, reactance]
branchData = [1	2	0	0
2	3	0.1461	0.2692
3	4	0.1461	0.2692
4	5	0.1461	0.2692
3	6	0.1461	0.2692
6	7	0.1461	0.2692
7	8	0.1461	0.2692
8	9	0.1461	0.2692
9	10	0.1461	0.2692
10	11	0.1461	0.2692
10	11	0.1461	0.2692
10	12	0.1461	0.2692
11	13	0.1461	0.2692
13	14	0.1461	0.2692
14	15	0.5303	0.3406
15	16	0.5303	0.3406
16	17	0.5303	0.3406
17	18	0.5303	0.3406
18	22	0.5303	0.3406
22	23	0.5303	0.3406
23	24	0.5303	0.3406
24	25	0.5303	0.3406
25	26	0.5303	0.3406
25	27	0.5303	0.3406
18	19	0.5303	0.3406
19	20	0.5303	0.3406
19	21	0.5303	0.3406
15	28	1.0098	0.3882
14	29	0.5303	0.3406
29	30	0.3002	0.3406
30	31	0.5303	0.3406
31	32	0.3002	0.3406
13	33	0.1461	0.2692
33	34	0.2375	0.3002
34	35	0.2375	0.3002
35	40	0.5303	0.3406
40	38	0.5303	0.3406
38	42	0.5303	0.3406
42	43	0.5303	0.3406
43	44	0.5303	0.3406
44	45	0.5303	0.3406
45	46	0.5303	0.3406
46	47	0.5303	0.3406
47	48	0.5303	0.3406
48	49	0.5303	0.3406
35	36	0.2375	0.3002
36	37	0.2375	0.3002
37	41	0.2375	0.3002
37	39	0.2375	0.3002
49	52	0.5303	0.3406
52	53	0.5303	0.3406
53	54	0.5303	0.3406
53	55	0.5303	0.3406
55	56	1.0098	0.3882
49	50	0.5303	0.3406
50	51	0.5303	0.3406
51	57	0.5303	0.3406
57	58	0.5303	0.3406
58	59	0.5303	0.3406
33	60	0.161	0.098
60	61	0.5303	0.3406
60	62	0.5303	0.3406
62	63	0.5303	0.3406
63	64	0.5303	0.3406
64	65	0.5303	0.3406
65	66	0.5303	0.3406
66	67	0.5303	0.3406
67	68	0.5303	0.3406
68	69	0.5303	0.3406
69	61	0.5303	0.3406
61	71	0.2375	0.3002
71	72	0.2375	0.3002
72	73	0.2375	0.3002
61	70	0.5303	0.3406
70	75	0.5303	0.3406
75	74	0.5303	0.3406
74	77	0.2375	0.3002
77	78	0.2375	0.3002
74	76	0.5303	0.3406
60	81	0.161	0.098
81	82	0.2375	0.3002
82	83	0.2375	0.3002
83	84	0.2375	0.3002
84	93	0.5303	0.3406
83	89	0.2375	0.3002
89	86	0.2375	0.3002
86	87	0.265	0.106
86	88	0.2375	0.3002
88	85	0.2375	0.3002
85	92	0.2375	0.3002
92	91	0.2375	0.3002
81	95	0.5303	0.3406
95	96	0.5303	0.3406
96	90	0.5303	0.3406
90	117	0.5303	0.3406
117	118	0.5303	0.3406
118	119	0.5303	0.3406
119	120	0.5303	0.3406
120	121	0.5303	0.3406
121	122	0.5303	0.3406
122	123	0.5303	0.3406
123	124	0.5303	0.3406
124	125	0.5303	0.3406
125	115	0.5303	0.3406
90	94	0.5303	0.3406
94	103	0.5303	0.3406
103	104	0.5303	0.3406
104	105	0.5303	0.3406
105	97	0.5303	0.3406
97	98	0.5303	0.3406
94	100	0.5303	0.3406
100	101	0.5303	0.3406
101	102	0.5303	0.3406
98	132	0.2375	0.3002
132	133	0.265	0.106
133	134	0.2375	0.3002
134	135	0.2375	0.3002
98	107	0.2375	0.3002
107	108	0.2375	0.3002
108	109	0.2375	0.3002
109	110	0.2375	0.3002
110	99	0.2375	0.3002
99	111	0.2375	0.3002
99	112	0.2375	0.3002
99	106	0.2375	0.3002
106	113	0.2375	0.3002
106	114	0.2375	0.3002];
% Bus data: [bus_number, voltage, angle, load_P, load_Q]
busData = [1	0	0
2	0	0
3	0	0
4	29.41	18.23
5	14.11	8.74
6	-3000	-1860
7	0.266	2.79
8	3.145	1.95
9	12.58	7.844
10	0	0
11	14.705	9.169
12	10.03	6.254
13	0	0
14	0	0
15	0	0
16	10.03	6.254
17	160.99	100.382
18	0	0
19	0	0
20	11.985	7.473
21	84.15	52.47
22	15.895	9.911
23	10.965	6.837
24	8.5	5.3
25	0	0
26	16.49	10.282
27	18.785	11.713
28	70.21	43.778
29	196.095	122.271
30	157.08	97.944
31	4.93	3.074
32	13.94	8.692
33	0	0
34	15.895	9.911
35	0	0
36	13.345	8.321
37	0	0
41	35.105	21.889
39	17.68	11.024
40	129.37	80.666
38	40.97	25.546
42	69.615	43.407
43	42.755	26.659
44	10.625	6.625
45	48.79	30.422
46	51.595	32.171
47	49.045	30.581
48	119.17	74.306
49	0	0
50	5.525	3.445
51	34.935	21.783
52	26.095	16.271
53	0	0
54	26.69	16.642
55	41.395	25.811
56	2.38	1.484
57	38.59	24.062
58	67.66	42.188
59	77.435	48.283
60	0	0
61	0	0
62	50.575	31.535
63	18.785	11.713
64	46.665	29.097
65	134.895	84.111
66	88.06	54.908
67	61.54	38.372
68	1.7	1.06
69	138.21	86.178
70	3.315	2.067
71	21.59	13.462
72	27.455	17.119
73	26.86	16.748
74	0	0
75	142.97	89.146
76	28.22	17.596
77	18.87	11.766
78	34	21.2
79	81.005	50.509
80	68.85	42.93
81	0	0
82	15.13	9.434
83	0	0
84	10.03	6.254
85	60.945	38.001
86	0	0
87	19.975	12.455
88	49.045	30.581
89	9.775	6.095
90	0	0
91	19.465	12.137
92	14.195	8.851
93	39.015	24.327
94	0	0
95	16.235	10.123
96	23.715	14.787
97	21.165	13.197
98	0	0
99	0	0
100	32.98	20.564
101	2.975	1.855
102	45.135	28.143
103	8.415	5.247
104	24.395	15.211
105	14.535	9.063
107	24.14	15.052
108	38.335	23.903
109	34.34	21.412
110	48.195	30.051
111	45.645	28.461
112	42.245	26.341
113	25.925	16.165
114	36.6435	22.843
115	14.535	9.063
117	51.935	32.383
118	21.93	13.674
119	45.645	28.461
120	63.495	39.591
121	6.29	3.922
122	51.595	32.171
123	29.835	18.603
124	4.42	2.756
125	9.18	5.724
132	32.98	20.564
133	30.43	18.974
134	15.98	9.964
135	8.415	5.247];
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
    dgLocations = round(pos(:,dim1+1:end));
    sizeDG = size(dgLocations);
    for i = 1:sizeDG(1)
        for j = 1:sizeDG(2)
            while sum(dgLocations(i, :) == dgLocations(i, j)) > 1
                dgLocations(i,j) = dgLocations(i,j) + 1;
                if dgLocations(i,j) > 135
                    dgLocations(i,j) = 1;
                end
            end
        end
        pos(i,dim1+1:end) = dgLocations(i,:);
    end
    dgLocations = dgLocations';
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
    fprintf('Iteration %d: Best Fitness = %f\n', iter, gBestFitness);
    iterbest(iter) = gBestFitness;
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
disp(sum(dgSize));

% Plotting GBest
plot(iterbest)

% Calculate voltages
% Calculate the voltages and fitness without DGs
[V_withoutDGs, I_withoutDGs, fitnessWithoutDGs] = fitnessFunctionWithoutDGs(branchData, busData, voltageLowerThreshold, voltageUpperThreshold);

% Calculate the voltages and fitness with DGs
[V_withDGs, I_withDGs, fitnessWithDGs, BIBC, BCBV] = fitnessFunctionWithDGs(branchData, busData, dgLocation, dgSize, voltageLowerThreshold, voltageUpperThreshold);

        % disp('Voltages without DGs:');
        % V_withoutDGs=abs(real(V_withoutDGs));
        % disp(V_withoutDGs);
        % 
        % disp('Voltages with DGs:');
        % V_withDGs=abs(real(V_withDGs));
        % disp(V_withDGs);

% disp('BIBC:')
% disp(BIBC)
% 
% disp('BCBV:')
% disp(BCBV)

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
    [V, I, BIBC, BCBV] = backwardForwardSweep(adjustedBusData, branchData, voltageLowerThreshold, voltageUpperThreshold);
    
    % Calculate the total active power loss
    totalLoss = 0;
    numBranches = size(branchData, 1);
    for i = 1:numBranches
        resistance = branchData(i, 3);
        P_loss = resistance * abs(I(i))^2;
        totalLoss = totalLoss + P_loss;
    end
end

function [V, I, totalLoss, BIBC, BCBV] = fitnessFunctionWithDGs(branchData, busData, dgLocations, dgCapacities, voltageLowerThreshold, voltageUpperThreshold)
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
    [V, I, BIBC, BCBV] = backwardForwardSweep(adjustedBusData, branchData, voltageLowerThreshold, voltageUpperThreshold);
    
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
function [V, I, BIBC, BCBV] = backwardForwardSweep(busData, branchData, voltageLowerThreshold, voltageUpperThreshold)
    numBuses = size(busData, 1);
    numBranches = size(branchData, 1);
    
    % Initialize bus voltages and branch currents
    V = ones(numBuses, 1);  % All buses start with voltage 1.0 p.u.
    I = zeros(numBranches, 1);  % Initialize branch currents to zero
    
    % Calculate BIBC and BCBV matrices
    BIBC = calculateBIBC(busData, branchData);
    BCBV = calculateBCBV(busData, branchData);
    
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

% Placeholder function to calculate BIBC matrix
function BIBC = calculateBIBC(busData, branchData)
    numBuses = size(busData, 1);
    numBranches = size(branchData, 1);
    BIBC = zeros(numBuses, numBranches);
    
    % Implement the actual BIBC calculation here
    % Placeholder example: Populate BIBC matrix based on bus and branch data
    
    for i = 1:numBranches
        fromBus = branchData(i, 1);
        toBus = branchData(i, 2);
        if toBus <= numBuses
            BIBC(toBus, i) = 1;
        end
    end
    
    % Further implementation as needed
end

% Placeholder function to calculate BCBV matrix
function BCBV = calculateBCBV(busData, branchData)
    numBuses = size(busData, 1);
    numBranches = size(branchData, 1);
    BCBV = zeros(numBuses, numBranches);
    
    % Implement the actual BCBV calculation here
    % Placeholder example: Populate BCBV matrix based on bus and branch data
    
    for i = 1:numBranches
        fromBus = branchData(i, 1);
        toBus = branchData(i, 2);
        resistance = branchData(i, 3);
        reactance = branchData(i, 4);
        impedance = resistance + 1j * reactance;
        if toBus <= numBuses
            BCBV(toBus, i) = impedance;
        end
    end
    
    % Further implementation as needed
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


