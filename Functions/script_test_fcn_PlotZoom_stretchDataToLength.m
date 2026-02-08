%% script_test_fcn_PlotZoom_stretchDataToLength.m
% This is a script to exercise the function: fcn_PlotZoom_stretchDataToLength.m
% This function was written on 2026_02_02 by S. Brennan, sbrennan@psu.edu

% REVISION HISTORY:
% 
% As: script_test_fcn_plot+Road_stretchDataToLength
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - First write of the code
% 
% As: script_test_fcn_PlotZoom_stretchDataToLength
%
% 2026_02_07 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_PlotZoom_stretchDataToLength
%   % * Renamed function from script_test_fcn_plot+Road_stretchDataToLength

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
XYdata = [0 0; 1 1; 4 2; nan nan; 5 1; 6 1; nan nan; 2 0; 4 0; 5 -1; nan nan];
minLength = 2; % Define the minimum length for stretching the data

% Test the function
[stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(stretchedXYdata));
assert(islogical(indicesUsed));

% Check variable sizes
assert(size(stretchedXYdata,1)<=size(XYdata,1)); 
assert(size(stretchedXYdata,2)==2); 
assert(size(indicesUsed,1)<=size(XYdata,1)); 
assert(size(indicesUsed,2)==1); 

% Check variable values
% assert(isequal(2,min(cell_array_of_lap_indices{1})));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: all edges disappear
figNum = 10002; 
titleString = sprintf('DEMO case: all edges disappear');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Load some test data 
XYdata = [0 0; .5 .5; 1 1; 1.5 1];
minLength = 3; % Define the minimum length for stretching the data

% Test the function
[stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(stretchedXYdata));
assert(islogical(indicesUsed));

% Check variable sizes
assert(size(stretchedXYdata,1)<=size(XYdata,1)); 
assert(size(stretchedXYdata,2)==0); 
assert(size(indicesUsed,1)<=size(XYdata,1)); 
assert(size(indicesUsed,2)==1); 

% Check variable values
% assert(isequal(2,min(cell_array_of_lap_indices{1})));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: all edges disappear due to NaN
figNum = 10003; 
titleString = sprintf('DEMO case: all edges disappear due to NaN');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Load some test data 
XYdata = [0 0; .5 .5; nan nan; 4 4; 5 5];
minLength = 3; % Define the minimum length for stretching the data

% Test the function
[stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(stretchedXYdata));
assert(islogical(indicesUsed));

% Check variable sizes
assert(size(stretchedXYdata,1)<=size(XYdata,1)); 
assert(size(stretchedXYdata,2)>=0); 
assert(size(indicesUsed,1)<=size(XYdata,1)); 
assert(size(indicesUsed,2)==1); 


% Check variable values
% assert(isequal(2,min(cell_array_of_lap_indices{1})));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% DEMO case: no edges disappear 
figNum = 10004; 
titleString = sprintf('DEMO case: no edges disappear');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Load some test data 
XYdata = [0 0; 4 4; 5 9; 3 1];
minLength = 3; % Define the minimum length for stretching the data

% Test the function
[stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(stretchedXYdata));
assert(islogical(indicesUsed));

% Check variable sizes
assert(size(stretchedXYdata,1)<=size(XYdata,1)); 
assert(size(stretchedXYdata,2)==2); 
assert(size(indicesUsed,1)<=size(XYdata,1)); 
assert(size(indicesUsed,2)==1); 

% Check variable values
% assert(isequal(2,min(cell_array_of_lap_indices{1})));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% DEMO case: box compressed
figNum = 10005; 
titleString = sprintf('DEMO case: box compressed');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Load some test data 
XYdata = [0 0; 4 0; 4 1; 0 1; 0 0];
minLength = 3; % Define the minimum length for stretching the data

% Test the function
[stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(stretchedXYdata));
assert(islogical(indicesUsed));

% Check variable sizes
assert(size(stretchedXYdata,1)<=size(XYdata,1)); 
assert(size(stretchedXYdata,2)==2); 
assert(size(indicesUsed,1)<=size(XYdata,1)); 
assert(size(indicesUsed,2)==1); 

% Check variable values
% assert(isequal(2,min(cell_array_of_lap_indices{1})));

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

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
XYdata = [0 0; 1 1; 4 2; nan nan; 5 1; 6 1; nan nan; 2 0; 4 0; 5 -1; nan nan];
minLength = 2; % Define the minimum length for stretching the data

% Test the function
[stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, ([]));

% Check variable types
assert(isnumeric(stretchedXYdata));
assert(islogical(indicesUsed));

% Check variable sizes
assert(size(stretchedXYdata,1)<=size(XYdata,1)); 
assert(size(stretchedXYdata,2)==2); 
assert(size(indicesUsed,1)<=size(XYdata,1)); 
assert(size(indicesUsed,2)==1); 

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
XYdata = [0 0; 1 1; 4 2; nan nan; 5 1; 6 1; nan nan; 2 0; 4 0; 5 -1; nan nan];
minLength = 2; % Define the minimum length for stretching the data

% Test the function
[stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, (-1));

% Check variable types
assert(isnumeric(stretchedXYdata));
assert(islogical(indicesUsed));

% Check variable sizes
assert(size(stretchedXYdata,1)<=size(XYdata,1)); 
assert(size(stretchedXYdata,2)==2); 
assert(size(indicesUsed,1)<=size(XYdata,1)); 
assert(size(indicesUsed,2)==1); 
 

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
XYdata = [0 0; 1 1; 4 2; nan nan; 5 1; 6 1; nan nan; 2 0; 4 0; 5 -1; nan nan];
minLength = 2; % Define the minimum length for stretching the data


Niterations = 100;

% Do calculation without pre-calculation
tic;
for ith_test = 1:Niterations
	% Test the function
	[stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, ([]));
end
slow_method = toc;

% Do calculation with pre-calculation, FAST_MODE on
tic;

for ith_test = 1:Niterations
	% Test the function
	[stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, (-1));
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

