%% script_test_fcn_PlotZoom_zoomPlotLL.m
% This is a script to exercise the function: fcn_PlotZoom_zoomPlotLL.m
% This function was written on 2026_02_02 by S. Brennan, sbrennan@psu.edu

% REVISION HISTORY:
% 
% As: script_test_fcn_plot+Road_smartPlotLL
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - First write of the code
% 
% 2026_02_07 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_plot+Road_smartPlotLL
%   % * Updated function calls from fcn_plotRoad+_minPixelLengthPerZoom
%   %   to fcn_PlotZoom_minPixelLengthPerZoom
% 
% As: script_test_fcn_PlotZoom_zoomPlotLL
% 
% 2026_02_07 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_PlotZoom_zoomPlotLL
%   % * Updated function calls from fcn_plotRoad+_minPixelLengthPerZoom
%   %   to fcn_PlotZoom_minPixelLengthPerZoom

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

%% DEMO case: only opens and initializes plot in Fig 1, as no figNum given

figNum = 10001; 
titleString = sprintf('DEMO case: only opens and initializes plot in Fig 1, as no figNum given');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% call the function with empty inputs, and it should create the plot with
% the focus on the test track, satellite view
h_geoplot = fcn_PlotZoom_zoomPlotLL;

% Check results
assert(ishandle(h_geoplot));

%% DEMO case: all defaults, no data. Also opens and initializes plot

figNum = 10002; 
titleString = sprintf('DEMO case: all defaults, no data. Also opens and initializes plot');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

LLdata = [];

% Test the function
plotFormat = [];
handleName = [];
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdata), (plotFormat), (handleName), (figNum));

title(sprintf('Example %.0d: showing initializing plot to figure number',figNum), 'Interpreter','none');

% Check results
assert(ishandle(h_geoplot));

%% DEMO case: opens and inializes plot to the data point

figNum = 10003; 
titleString = sprintf('DEMO case: opens and inializes plot to the data point');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Find the limits
[~, ~, minDegPerPixelLon, ~] = fcn_PlotZoom_minPixelLengthPerZoom;

longData = (-77.8349:-1*minDegPerPixelLon(end-2):-77.8369)';
Npoints = length(longData);
wiggle = longData(2)-longData(1);
latData = 40.86368573*ones(Npoints,1);
countingPoints = (1:Npoints)';
iseven = mod(countingPoints,2)==0;
latDataWiggled = latData+iseven*wiggle;
LLdata = [latDataWiggled, longData, 0*latData];

LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA(LLdata);

% Test the function
plotFormat = '.';
handleName = [];
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));

% Check results
assert(ishandle(h_geoplot));

%% DEMO case: plot repeatedly to show effect of zooming in/out

figNum = 10004; 
titleString = sprintf('DEMO case: plot repeatedly to show effect of zooming in/out');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Find the limits
[zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom;

longData = (-77.8349:-1*minDegPerPixelLon(end-2):-77.8369)';
Npoints = length(longData);
wiggle = longData(2)-longData(1);
latData = 40.86368573*ones(Npoints,1);
countingPoints = (1:Npoints)';
iseven = mod(countingPoints,2)==0;
latDataWiggled = latData+iseven*wiggle;
LLdata = [latDataWiggled, longData, 0*latData];

LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA(LLdata);



% Create an initial plot
plotFormat = '.';
handleName = [];
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));

% Test the effects of zoom level
nCols = 7;
ith_col = 0;

% Change zoom level
ith_col = ith_col+1;
subplot(1,nCols, ith_col);
% Create an initial plot
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));
set(gca,'ZoomLevel', 22);
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));

% Change zoom level
ith_col = ith_col+1;
subplot(1,nCols, ith_col);
% Create an initial plot
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));
set(gca,'ZoomLevel', 18);
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));

% Change zoom level
ith_col = ith_col+1;
subplot(1,nCols, ith_col);
% Create an initial plot
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));
set(gca,'ZoomLevel', 15);
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));

% Change zoom level
ith_col = ith_col+1;
subplot(1,nCols, ith_col);
% Create an initial plot
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));
set(gca,'ZoomLevel', 12);
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));

% Change zoom level
ith_col = ith_col+1;
subplot(1,nCols, ith_col);
% Create an initial plot
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));
set(gca,'ZoomLevel', 9);
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));


% Change zoom level
ith_col = ith_col+1;
subplot(1,nCols, ith_col);
% Create an initial plot
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));
set(gca,'ZoomLevel', 6);
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));

% Change zoom level
ith_col = ith_col+1;
subplot(1,nCols, ith_col);
% Create an initial plot
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));
set(gca,'ZoomLevel', 3);
h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
assert(ishandle(h_geoplot));


%%
figNum = 10005; 
titleString = sprintf('DEMO case: plot repeatedly to show effect of zooming in/out');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf; 


% Shape file string of PA highways 
shapeFileString = "state_college_roads.shp";

% Create a geospatial table
geospatial_table = fcn_OSM2SHP_loadShapeFile(fullfile(pwd,'Data',shapeFileString), -1);

% Call the function
[~, LL_allSegments_cell] = fcn_OSM2SHP_extractLLFromGeospatialTable(geospatial_table, (-1));

% Get the colorOrder
ax = gca;
colorOrder = ax.ColorOrder;
Ncolors = size(colorOrder,1);

LLIdata = [];
for ith_segment = 1:length(LL_allSegments_cell)
	thisColorIndex = mod(ith_segment-1,Ncolors)+1;
	thisLLdata = LL_allSegments_cell{ith_segment};
	NthisLLdata = size(thisLLdata,1);
	LLIdata = [LLIdata; nan nan nan; [thisLLdata thisColorIndex*ones(NthisLLdata,1)]]; %#ok<AGROW>
end


% Downsample the LL data by size
LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA(LLIdata);

%%
clear plotFormat
plotFormat.Color = [0 0.7 0];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;


ZoomUsed = 15;

subplot(1,2,1)
fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorOrder), (figNum)); 
h_axis = gca;
set(h_axis,'ZoomLevel',ZoomUsed);
oldMapCenter = get(h_axis,'MapCenter');
oldZoom = get(h_axis,'ZoomLevel');


subplot(1,2,2)
fcn_plotRoad_plotLL(([]), ([]), (figNum));
h_axis = gca;
set(h_axis,'MapCenter',oldMapCenter);
set(h_axis,'ZoomLevel',oldZoom);

% h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), ([]), (figNum));
allZoomLevels = cell2mat(LLdataCellArray(:,1));
closestZoomIndex = find(round(allZoomLevels,3)==ZoomUsed,1);
dataToPlot = LLdataCellArray{closestZoomIndex,2};
Nplotted = length(dataToPlot(:,1));
Ntotal = length(LLdataCellArray{end,2}(:,1));
fcn_plotRoad_plotLLI(dataToPlot, (plotFormat),  (colorOrder), (figNum)); 
title(sprintf('Reduction: %.2f%%',Nplotted*100/Ntotal));


%% DEMO case: Complex with segment colors
figNum = 10006; 
titleString = sprintf('DEMO case: Complex with segment colors');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf; 


% Shape file string of PA highways 
shapeFileString = "state_college_roads.shp";

% Create a geospatial table
geospatial_table = fcn_OSM2SHP_loadShapeFile(fullfile(pwd,'Data',shapeFileString), -1);

% Call the function
[LLCoordinate_allSegments, LL_allSegments_cell] = fcn_OSM2SHP_extractLLFromGeospatialTable(geospatial_table, (-1));

% Get the colorOrder
ax = gca;
colorOrder = ax.ColorOrder;
Ncolors = size(colorOrder,1);

clear plotFormat
plotFormat.Color = [0 0.7 0];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;

subplot(1,2,1)
LLIdata = [];
for ith_segment = 1:length(LL_allSegments_cell)
	thisColorIndex = mod(ith_segment-1,Ncolors)+1;
	thisLLdata = LL_allSegments_cell{ith_segment};
	NthisLLdata = size(thisLLdata,1);
	LLIdata = [LLIdata; nan nan nan; [thisLLdata thisColorIndex*ones(NthisLLdata,1)]]; %#ok<AGROW>
end
[h_plot, indiciesInEachPlot]  = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorOrder), (figNum)); 
h_axis = gca;
set(h_axis,'ZoomLevel',10);
oldMapCenter = get(h_axis,'MapCenter');
oldZoom = get(h_axis,'ZoomLevel');


% Group the LL data by colors
subplot(1,2,2)
fcn_plotRoad_plotLL(([]), ([]), (figNum));
h_axis = gca;
set(h_axis,'MapCenter',oldMapCenter);
set(h_axis,'ZoomLevel',oldZoom);

LLIdataByColor = cell(Ncolors,1);
for ith_segment = 1:length(LL_allSegments_cell)
	thisColorIndex = mod(ith_segment-1,Ncolors)+1;
	thisLLdata = LL_allSegments_cell{ith_segment};
	NthisLLdata = size(thisLLdata,1);
	thisColorData = LLIdataByColor{thisColorIndex};
	appendedColorData = [thisColorData; nan nan thisColorIndex; [thisLLdata thisColorIndex*ones(NthisLLdata,1)]]; 
	LLIdataByColor{thisColorIndex} = appendedColorData;
end

for ith_color = 1:Ncolors
	LLdata = LLIdataByColor{ith_color};
	LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA(LLdata);
	plotFormat.Color = colorOrder(ith_color,:);
	handleName = sprintf('Color_%.0f',ith_color);
	h_geoplot = fcn_PlotZoom_zoomPlotLL((LLdataCellArray), (plotFormat), (handleName), (figNum));
	hold on;
end



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
fprintf(1, 'Plot function - No fast mode tests\n')

% %% Basic example - NO FIGURE
% 
% figNum = 80001;
% fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
% figure(figNum); close(figNum);
% 
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% 
% %% Basic example - NO FIGURE
% 
% figNum = 80002;
% fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
% figure(figNum); close(figNum);
% 
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% %% Compare speeds of pre-calculation versus post-calculation versus a fast variant
% 
% figNum = 80003;
% fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
% figure(figNum); close(figNum);
% 
% Niterations = 100;
% 
% % Do calculation without pre-calculation
% tic;
% for ith_test = 1:Niterations
% 
% 
% 
% end
% slow_method = toc;
% 
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% 
% for ith_test = 1:Niterations
% 
% 
% 
% end
% fast_method = toc;
% 
% 
% % Plot results as bar chart
% figure(373737);
% clf;
% hold on;
% 
% X = categorical({'Normal mode','Fast mode'});
% X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
% Y = [slow_method fast_method ]*1000/Niterations;
% bar(X,Y)
% ylabel('Execution time (Milliseconds)')
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));

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

% 
% %% fcn_PlotZoom_minFeaturesPerZoomLLA
% function LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA(LLdata)
% 
% % Find the ENU data equivalent
% gps_object = GPS(); % Initiate the class object for GPS
% 
% % Use the class to convert LLA to ENU
% ENU_data = gps_object.WGSLLA2ENU(LLdata(:,1), LLdata(:,2), LLdata(:,1)*0);
% 
% [zoomLevels, minMetersPerPixel] = fcn_PlotZoom_minPixelLengthPerZoom;
% Nzooms = length(zoomLevels);
% LLdataCellArray = cell(Nzooms,2);
% for ith_zoom = 1:Nzooms
% 	thisMinLength = minMetersPerPixel(ith_zoom);
% 	LLdataCellArray{ith_zoom,1} = zoomLevels(ith_zoom,1);
% 	[~, indicesUsed] = fcn_plotRoad_stretchDataToLength(thisMinLength, ENU_data, (-1));
% 	LLdataCellArray{ith_zoom,2} = LLdata(indicesUsed,:);
% end
% 
% % For debugging
% if 1==0
% 	for ith_zoom = 1:50:Nzooms
% 		thisMinLength = minMetersPerPixel(ith_zoom);
% 		LLdataCellArray{ith_zoom,1} = zoomLevels(ith_zoom,1);
% 		[~, indicesUsed] = fcn_plotRoad_stretchDataToLength(thisMinLength, ENU_data, (-1));
% 		LLdataCellArray{ith_zoom,2} = LLdata(indicesUsed,:);
% 	end
% end
% end % Ends fcn_PlotZoom_minFeaturesPerZoomLLA

