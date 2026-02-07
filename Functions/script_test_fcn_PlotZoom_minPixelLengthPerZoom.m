% script_test_fcn_PlotZoom_minPixelLengthPerZoom.m
% tests fcn_PlotZoom_minPixelLengthPerZoom.m

% REVISION HISTORY:
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - Wrote the code originally, copilot code to start

% TO-DO:
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)


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
% Figures start with 1

close all;
fprintf(1,'Figure: 1XXXXXX: DEMO cases\n');

%% DEMO case: default case
figNum = 10001;
titleString = sprintf('DEMO case: default case');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Call the function
[zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom;

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(zoomLevels));
assert(isnumeric(minMetersPerPixel));
assert(isnumeric(minDegPerPixelLon));
assert(isnumeric(minDegPerPixelLat));

% Check variable sizes
assert(size(zoomLevels,1)==201);
assert(size(zoomLevels,2)==1);
assert(size(minMetersPerPixel,1)==201);
assert(size(minMetersPerPixel,2)==1);
assert(size(minDegPerPixelLon,1)==201);
assert(size(minDegPerPixelLon,2)==1);
assert(size(minDegPerPixelLat,1)==201);
assert(size(minDegPerPixelLat,2)==1);

% Check variable values
assert(isequal(zoomLevels(1),0));
assert(isequal(zoomLevels(end),25));
assert(minMetersPerPixel(1)>13000); % Actual: about 120,000 meters
assert(minMetersPerPixel(end)>0.0004); % Actual: about 0.0035 meters
assert(minDegPerPixelLon(1)>1.406); 
assert(minDegPerPixelLon(end)>4.1e-08); 
assert(minDegPerPixelLat(1)>.12); 
assert(minDegPerPixelLat(end)>3.6e-09); 

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: smallest case (near north pole)
figNum = 10002;
titleString = sprintf('DEMO case: smallest case (near north pole)');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Call the function
[zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom(85.05112878);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(zoomLevels));
assert(isnumeric(minMetersPerPixel));
assert(isnumeric(minDegPerPixelLon));
assert(isnumeric(minDegPerPixelLat));

% Check variable sizes
assert(size(zoomLevels,1)==201);
assert(size(zoomLevels,2)==1);
assert(size(minMetersPerPixel,1)==201);
assert(size(minMetersPerPixel,2)==1);
assert(size(minDegPerPixelLon,1)==201);
assert(size(minDegPerPixelLon,2)==1);
assert(size(minDegPerPixelLat,1)==201);
assert(size(minDegPerPixelLat,2)==1);


% Check variable values
assert(isequal(zoomLevels(1),0));
assert(isequal(zoomLevels(end),25));
assert(minMetersPerPixel(1)>13000); % Actual: about 120,000 meters
assert(minMetersPerPixel(end)>0.0004); % Actual: about 0.0035 meters
assert(minDegPerPixelLon(1)>1.406); 
assert(minDegPerPixelLon(end)>4.1e-08); 
assert(minDegPerPixelLat(1)>.12); 
assert(minDegPerPixelLat(end)>3.6e-09); 

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: largest case (at equator)
figNum = 10003;
titleString = sprintf('DEMO case: smallest case (at equator)');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Call the function
[zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom(0);

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(zoomLevels));
assert(isnumeric(minMetersPerPixel));
assert(isnumeric(minDegPerPixelLon));
assert(isnumeric(minDegPerPixelLat));

% Check variable sizes
assert(size(zoomLevels,1)==201);
assert(size(zoomLevels,2)==1);
assert(size(minMetersPerPixel,1)==201);
assert(size(minMetersPerPixel,2)==1);
assert(size(minDegPerPixelLon,1)==201);
assert(size(minDegPerPixelLon,2)==1);
assert(size(minDegPerPixelLat,1)==201);
assert(size(minDegPerPixelLat,2)==1);


% Check variable values
assert(isequal(zoomLevels(1),0));
assert(isequal(zoomLevels(end),25));
assert(minMetersPerPixel(1)>13000); % Actual: about 120,000 meters
assert(minMetersPerPixel(end)>0.0004); % Actual: about 0.0035 meters
assert(minDegPerPixelLon(1)>1.406); 
assert(minDegPerPixelLon(end)>4.1e-08); 
assert(minDegPerPixelLat(1)>.12); 
assert(minDegPerPixelLat(end)>3.6e-09); 

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
% Figures start with 2

close all;
fprintf(1,'Figure: 2XXXXXX: TEST mode cases\n');

% %% TEST case: This one returns nothing since there is no portion of the path in criteria
% figNum = 20001;
% titleString = sprintf('TEST case: This one returns nothing since there is no portion of the path in criteria');
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
% Figures start with 8

close all;
fprintf(1,'Figure: 8XXXXXX: FAST mode cases\n');

%% Basic example - NO FIGURE
figNum = 80001;
fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
figure(figNum); close(figNum);

% Call the function
[zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom(([]),([]));

% Check variable types
assert(isnumeric(zoomLevels));
assert(isnumeric(minMetersPerPixel));
assert(isnumeric(minDegPerPixelLon));
assert(isnumeric(minDegPerPixelLat));

% Check variable sizes
assert(size(zoomLevels,1)==201);
assert(size(zoomLevels,2)==1);
assert(size(minMetersPerPixel,1)==201);
assert(size(minMetersPerPixel,2)==1);
assert(size(minDegPerPixelLon,1)==201);
assert(size(minDegPerPixelLon,2)==1);
assert(size(minDegPerPixelLat,1)==201);
assert(size(minDegPerPixelLat,2)==1);


% Check variable values
assert(isequal(zoomLevels(1),0));
assert(isequal(zoomLevels(end),25));
assert(minMetersPerPixel(1)>13000); % Actual: about 120,000 meters
assert(minMetersPerPixel(end)>0.0004); % Actual: about 0.0035 meters
assert(minDegPerPixelLon(1)>1.406); 
assert(minDegPerPixelLon(end)>4.1e-08); 
assert(minDegPerPixelLat(1)>.12); 
assert(minDegPerPixelLat(end)>3.6e-09); 

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% Basic fast mode - NO FIGURE, FAST MODE
figNum = 80002;
fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
figure(figNum); close(figNum);

% Call the function
[zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom(([]),(-1));

% Check variable types
assert(isnumeric(zoomLevels));
assert(isnumeric(minMetersPerPixel));
assert(isnumeric(minDegPerPixelLon));
assert(isnumeric(minDegPerPixelLat));

% Check variable sizes
assert(size(zoomLevels,1)==201);
assert(size(zoomLevels,2)==1);
assert(size(minMetersPerPixel,1)==201);
assert(size(minMetersPerPixel,2)==1);
assert(size(minDegPerPixelLon,1)==201);
assert(size(minDegPerPixelLon,2)==1);
assert(size(minDegPerPixelLat,1)==201);
assert(size(minDegPerPixelLat,2)==1);


% Check variable values
assert(isequal(zoomLevels(1),0));
assert(isequal(zoomLevels(end),25));
assert(minMetersPerPixel(1)>13000); % Actual: about 120,000 meters
assert(minMetersPerPixel(end)>0.0004); % Actual: about 0.0035 meters
assert(minDegPerPixelLon(1)>1.406); 
assert(minDegPerPixelLon(end)>4.1e-08); 
assert(minDegPerPixelLat(1)>.12); 
assert(minDegPerPixelLat(end)>3.6e-09); 

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% Compare speeds of pre-calculation versus post-calculation versus a fast variant
figNum = 80003;
fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
figure(figNum);
close(figNum);


Niterations = 50;

% Do calculation without pre-calculation
tic;
for ith_test = 1:Niterations
	[zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom(([]),([]));
end
slow_method = toc;

% Do calculation with pre-calculation, FAST_MODE on
tic;
for ith_test = 1:Niterations
	[zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom(([]),(-1));
end
fast_method = toc;

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));

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

%% BUG 

%% Fail conditions
if 1==0
    %
end


%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§
