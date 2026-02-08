%% script_test_fcn_PlotZoom_minFeaturesPerZoomLLA
% This is a script to exercise the function: fcn_PlotZoom_minFeaturesPerZoomLLA
% This script was written on 2026_02_07 by S. Brennan, sbrennan@psu.edu

% REVISION HISTORY:
% 
% 2026_02_07 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_PlotZoom_minFeaturesPerZoomLLA
%   % * Wrote script 
%   % * Used script_test_fcn_PlotZoom_stretchDataToLength as starter

% TO-DO:
% 
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu


%% Set up the workspace

close all

%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              ____   __    _____          _
%  |  __ \                            / __ \ / _|  / ____|        | |
%  | |  | | ___ _ __ ___   ___  ___  | |  | | |_  | |     ___   __| | ___
%  | |  | |/ _ \ '_ ` _ \ / _ \/ __| | |  | |  _| | |    / _ \ / _` |/ _ \
%  | |__| |  __/ | | | | | (_) \__ \ | |__| | |   | |___| (_) | (_| |  __/
%  |_____/ \___|_| |_| |_|\___/|___/  \____/|_|    \_____\___/ \__,_|\___|
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Demos%20Of%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEMO figures start with 1

close all;
fprintf(1,'Figure: 1XXXX: DEMO cases\n');

%% DEMO case: simple example
figNum = 10001; 
titleString = sprintf('DEMO case: simple example');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Load some test data 
[~, ~, minDegPerPixelLon, ~] = fcn_PlotZoom_minPixelLengthPerZoom;
longData = (-77.8349:-1*minDegPerPixelLon(end-2):-77.8369)';
Npoints = length(longData);
wiggle = longData(2)-longData(1);
latData = 40.86368573*ones(Npoints,1);
countingPoints = (1:Npoints)';
iseven = mod(countingPoints,2)==0;
latDataWiggled = latData+iseven*wiggle;
LLdata = [latDataWiggled, longData, 0*latData];

% Test the function
LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA( LLdata, (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(LLdataCellArray));

% Check variable sizes
assert(size(LLdataCellArray,1)==201); 
assert(size(LLdataCellArray,2)==2); 

% Check variable values
% assert(isequal(2,min(cell_array_of_lap_indices{1})));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% DEMO case: simple example with NaN values
figNum = 10002; 
titleString = sprintf('DEMO case: simple example with NaN values');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Load some test data 
[~, ~, minDegPerPixelLon, ~] = fcn_PlotZoom_minPixelLengthPerZoom;
longData = (-77.8349:-1*minDegPerPixelLon(end-2):-77.8369)';
Npoints = length(longData);
wiggle = longData(2)-longData(1);
latData = 40.86368573*ones(Npoints,1);
countingPoints = (1:Npoints)';
iseven = mod(countingPoints,2)==0;
latDataWiggled = latData+iseven*wiggle;
LLdata = [latDataWiggled, longData, 0*latData];

midPoint = floor(Npoints/2);
LLdata(midPoint,:) = [nan nan 2];

% Test the function
LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA( LLdata, (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(LLdataCellArray));

% Check variable sizes
assert(size(LLdataCellArray,1)==201); 
assert(size(LLdataCellArray,2)==2); 

% Check variable values
% assert(isequal(2,min(cell_array_of_lap_indices{1})));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% Complex case with NaN values
figNum = 10003; 
titleString = sprintf('DEMO case: Complex case with NaN values');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Shape file string of PA highways
shapeFileString = "state_college_roads.shp";

% Create a geospatial table
geospatial_table = fcn_OSM2SHP_loadShapeFile(fullfile(pwd,'Data',shapeFileString), -1);

% Call the function
[LLCoordinate_allSegments, LL_allSegments_cell] = fcn_OSM2SHP_extractLLFromGeospatialTable(geospatial_table, (-1));

LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA(LLCoordinate_allSegments, (figNum));



%% Test cases start here. These are very simple, usually trivial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______ ______  _____ _______ _____
% |__   __|  ____|/ ____|__   __/ ____|
%    | |  | |__  | (___    | | | (___
%    | |  |  __|  \___ \   | |  \___ \
%    | |  | |____ ____) |  | |  ____) |
%    |_|  |______|_____/   |_| |_____/
%
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST figures start with 2

close all;
fprintf(1,'Figure: 2XXXXXX: TEST mode cases\n');

% %% Test case: Plot LL data 
% figNum = 20001;
% titleString = sprintf('Test case: Plot LL data');
% fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
% figure(figNum); clf;

%% Fast Mode Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ______        _     __  __           _        _______        _
% |  ____|      | |   |  \/  |         | |      |__   __|      | |
% | |__ __ _ ___| |_  | \  / | ___   __| | ___     | | ___  ___| |_ ___
% |  __/ _` / __| __| | |\/| |/ _ \ / _` |/ _ \    | |/ _ \/ __| __/ __|
% | | | (_| \__ \ |_  | |  | | (_) | (_| |  __/    | |  __/\__ \ |_\__ \
% |_|  \__,_|___/\__| |_|  |_|\___/ \__,_|\___|    |_|\___||___/\__|___/
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Fast%20Mode%20Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FAST Mode figures start with 8

close all;
fprintf(1,'Figure: 8XXXXXX: TEST mode cases\n');
fprintf(1, 'Plot function - No fast mode tests')

%% Basic example - NO FIGURE
figNum = 80001;
fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
figure(figNum); close(figNum);

% Load some test data 
[~, ~, minDegPerPixelLon, ~] = fcn_PlotZoom_minPixelLengthPerZoom;
longData = (-77.8349:-1*minDegPerPixelLon(end-2):-77.8369)';
Npoints = length(longData);
wiggle = longData(2)-longData(1);
latData = 40.86368573*ones(Npoints,1);
countingPoints = (1:Npoints)';
iseven = mod(countingPoints,2)==0;
latDataWiggled = latData+iseven*wiggle;
LLdata = [latDataWiggled, longData, 0*latData];

% Test the function
LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA( LLdata, ([]));

% Check variable types
assert(iscell(LLdataCellArray));

% Check variable sizes
assert(size(LLdataCellArray,1)==201); 
assert(size(LLdataCellArray,2)==2); 

% Check variable values
% assert(isequal(2,min(cell_array_of_lap_indices{1})));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% Basic example - NO FIGURE
figNum = 80002;
fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
figure(figNum); close(figNum);

% Load some test data 
[~, ~, minDegPerPixelLon, ~] = fcn_PlotZoom_minPixelLengthPerZoom;
longData = (-77.8349:-1*minDegPerPixelLon(end-2):-77.8369)';
Npoints = length(longData);
wiggle = longData(2)-longData(1);
latData = 40.86368573*ones(Npoints,1);
countingPoints = (1:Npoints)';
iseven = mod(countingPoints,2)==0;
latDataWiggled = latData+iseven*wiggle;
LLdata = [latDataWiggled, longData, 0*latData];

% Test the function
LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA( LLdata, (-1));

% Check variable types
assert(iscell(LLdataCellArray));

% Check variable sizes
assert(size(LLdataCellArray,1)==201); 
assert(size(LLdataCellArray,2)==2); 

% Check variable values
% assert(isequal(2,min(cell_array_of_lap_indices{1})));

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));

%% Compare speeds of pre-calculation versus post-calculation versus a fast variant

figNum = 80003;
fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
figure(figNum); close(figNum);


% Load some test data 
[~, ~, minDegPerPixelLon, ~] = fcn_PlotZoom_minPixelLengthPerZoom;
longData = (-77.8349:-1*minDegPerPixelLon(end-2):-77.8369)';
Npoints = length(longData);
wiggle = longData(2)-longData(1);
latData = 40.86368573*ones(Npoints,1);
countingPoints = (1:Npoints)';
iseven = mod(countingPoints,2)==0;
latDataWiggled = latData+iseven*wiggle;
LLdata = [latDataWiggled, longData, 0*latData];

Niterations = 2;

% Do calculation without pre-calculation
tic;
for ith_test = 1:Niterations

	% Test the function
	LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA( LLdata, ([]));

end
slow_method = toc;

% Do calculation with pre-calculation, FAST_MODE on
tic;

for ith_test = 1:Niterations

	% Test the function
	LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA( LLdata, (-1));

end
fast_method = toc;


% Plot results as bar chart
figure(373737);
clf;
hold on;

X = categorical({'Normal mode','Fast mode'});
X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
Y = [slow_method fast_method ]*1000/Niterations;
bar(X,Y)
ylabel('Execution time (Milliseconds)')

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));

%% BUG cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ____  _    _  _____
% |  _ \| |  | |/ ____|
% | |_) | |  | | |  __    ___ __ _ ___  ___  ___
% |  _ <| |  | | | |_ |  / __/ _` / __|/ _ \/ __|
% | |_) | |__| | |__| | | (_| (_| \__ \  __/\__ \
% |____/ \____/ \_____|  \___\__,_|___/\___||___/
%
% See: http://patorjk.com/software/taag/#p=display&v=0&f=Big&t=BUG%20cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All bug case figures start with the number 9

% close all;
% fprintf(1,'Figure: 9XXXXXX: TEST mode cases\n');

%% BUG

%% Fail conditions
if 1==0

    %% Should throw error because XYdata must have 2 columns

end

