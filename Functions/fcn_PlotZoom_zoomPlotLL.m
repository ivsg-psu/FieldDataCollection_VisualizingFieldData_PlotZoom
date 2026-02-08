function h_geoplot = fcn_PlotZoom_zoomPlotLL(varargin)
%fcn_PlotZoom_zoomPlotLL   geoplots Latitude and Longitude data with
% user-defined formatting strings, using precalculated datasets that set
% the data resolution for a given zoom level
%
% FORMAT:
%
%       h_geoplot = fcn_PlotZoom_zoomPlotLL((LLcellZoomArray), (plotFormat), (handleName), (figNum))
%
% INPUTS:
%
%      (OPTIONAL INPUTS)
%
%      LLcellZoomArray: a list of cell arrays, each containing 201 internal
%      cell arrays, each of these containing an [Nx2+] vector of data to
%      plot where N is the number of points, and there are 2 or more
%      columns. Each row of data correspond to the [Latitude Longitude]
%      coordinate of the point to plot in the 1st and 2nd column. If no
%      data is given, it plots the reference coordinate location for the
%      GPS origin.
%
%      plotFormat: one of the following:
%
%          * a format string, e.g. 'b-', that dictates the plot style
%          * a [1x3] color vector specifying the RGB ratios from 0 to 1
%          * a structure whose subfields for the plot properties to change, for example:
%            plotFormat.LineWidth = 3;
%            plotFormat.MarkerSize = 10;
%            plotFormat.Color = [1 0.5 0.5];
%            A full list of properties can be found by examining the plot
%            handle, for example: h_plot = plot(1:10); get(h_plot)
%
%      handleName: a string that denotes the name of the LLcellZoomArray,
%      which is used to index the plot handle so that the plot
%      automatically updates the data without redrawing.
%
%      figNum: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      h_geoplot: the handle to the geoplot result
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_PlotZoom_zoomPlotLL.m
%
%       for a full test suite.
%
% This function was written on 2026_02_02 by S. Brennan
% Questions or comments? snb10@psu.edu

% REVISION HISTORY:
%
% As: fcn_plot+Road_smartPlotLL
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - First write of the code
%
% 2026_02_03 by Sean Brennan, sbrennan@psu.edu
% - In fcn_plot+Road_smartPlotLL
%   % * Added handleName input
%   % * Allows storage of handles into UserData,
%   %   % for automatic plot updating instead of redraw
%
% As: fcn_PlotZoom_zoomPlotLL
%
% 2026_02_07 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotZoom_zoomPlotLL
%   % * Renamed function to fcn_PlotZoom_zoomPlotLL

% TO-DO:
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - Need to add custom zoom button capbilities to plots. See "is there a
%   way to put a custom toolbar on a geoplot to allow user-specified plot
%   modifications" in the copilot
% - Need to add bounding box limits on plotting to avoid updating objects
%   not in current view

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 4; % The largest Number of argument inputs to the function
flag_max_speed = 0;
if (nargin==MAX_NARGIN && isequal(varargin{end},-1))
	flag_do_debug = 0; % % % % Flag to plot the results for debugging
	flag_check_inputs = 0; % Flag to perform input checking
	flag_max_speed = 1;
else
	% Check to see if we are externally setting debug mode to be "on"
	flag_do_debug = 0; % % % % Flag to plot the results for debugging
	flag_check_inputs = 1; % Flag to perform input checking
	MATLABFLAG_PLOTZOOM_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTZOOM_FLAG_CHECK_INPUTS");
	MATLABFLAG_PLOTZOOM_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTZOOM_FLAG_DO_DEBUG");
	if ~isempty(MATLABFLAG_PLOTZOOM_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTZOOM_FLAG_DO_DEBUG)
		flag_do_debug = str2double(MATLABFLAG_PLOTZOOM_FLAG_DO_DEBUG);
		flag_check_inputs  = str2double(MATLABFLAG_PLOTZOOM_FLAG_CHECK_INPUTS);
	end
end

% flag_do_debug = 1;

if flag_do_debug
	st = dbstack; %#ok<*UNRCH>
	fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
	debug_figNum = 999978;
else
	debug_figNum = [];
end

%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 0 == flag_max_speed
	if flag_check_inputs == 1
		% Are there the right number of inputs?
		narginchk(0,MAX_NARGIN);

	end
else
	figNum = [];
end

% Check for empty inputs - this just initializes the plot
% Default is to NOT make a new plot, which will clear the plot and start a new plot
flag_make_new_plot = 0;
if 0 == nargin || 1==flag_max_speed
	flag_make_new_plot = 1;
end

% Check the data input
flag_plot_data = 0; % Default is not to plot the data
LLcellZoomArray = [];
if 1 <= nargin
	temp = varargin{1};

	% Check to see if data is being plotting. If it is not, then we
	% need to replot the figure
	if ~isempty(temp)
		LLcellZoomArray = temp;
		flag_plot_data = 1;
	else
		% No data is given - must be a new plot
		flag_make_new_plot = 1;
	end
end


% Set plotting defaults
plotFormat = 'k';
formatting_type = 1;  % Plot type in an integer to save the type of formatting. The numbers refer to 1: a string is given or 2: a color is given, or 3: a structure is given

% Check to see if user specifies plotFormat?
if 2 <= nargin
	input = varargin{2};
	if ~isempty(input)
		plotFormat = input;
		if ischar(plotFormat) && length(plotFormat)<=4
			formatting_type = 1;
		elseif isnumeric(plotFormat)  % Numbers are a color style
			formatting_type = 2;
		elseif isstruct(plotFormat)  % Structures give properties
			formatting_type = 3;
		else
			warning('on','backtrace');
			warning('An unkown input format is detected - throwing an error.')
			error('Unknown plotFormat input detected')
		end
	end
end

% Check the handleName input
% Default is to make handleName equal to string of LL of first data point
handleName = [];
if ~isempty(LLcellZoomArray)
	firstData = sprintf('%.8f_%.8f',LLcellZoomArray{end,2}(1,1),LLcellZoomArray{end,2}(1,2));
	handleName = firstData;
end
if 1 <= nargin
	temp = varargin{3};
	if ~isempty(temp)
		handleName = temp;
	end
end

% Default is to make a plot - this starts the plotting process
flag_do_plots = 1;
figNum = []; % Initialize the figure number to be empty
if (0==flag_max_speed) && (MAX_NARGIN<= nargin)
	temp = varargin{end};
	if ~isempty(temp)
		figNum = temp;
	else % An empty figure number is given by user, so we have to open a new one
		% create new figure with next default index
		figNum = figure;
		flag_make_new_plot = 1;
	end
end

% Is the figure number still empty? If so, then we need to open a new
% figure
if flag_make_new_plot && isempty(figNum)
	% create new figure with next default index
	figNum = figure;
end


% Setup figures if there is debugging
if flag_do_debug
	fig_debug = 9999;
else
	fig_debug = []; %#ok<*NASGU>
end



%% Write main code for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize the output
h_geoplot = 0;

reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE = getenv("MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE");
MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE = getenv("MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE");
MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE = getenv("MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE");
if ~isempty(MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE) && ~isempty(MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE) && ~isempty(MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE)
	reference_latitude  = str2double(MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE);
	reference_longitude = str2double(MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE);
	reference_altitude  = str2double(MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE);
end

%% Any debugging?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_do_plots == 1
	% check whether the figure already has data
	figure(figNum);
	temp_gca_handle = gca;
	if isempty(temp_gca_handle.Children)
		flag_make_new_plot = 1;
	end

	% Check to see if we are forcing image alignment via Lat and Lon shifting,
	% when doing geoplot. This is added because the geoplot images are very, very
	% slightly off at the test track, which is confusing when plotting data
	% above them.
	offset_Lat = 0; % Default offset
	offset_Lon = 0; % Default offset
	MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT = getenv("MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT");
	MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON = getenv("MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON");
	if ~isempty(MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT) && ~isempty(MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON)
		offset_Lat = str2double(MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT);
		offset_Lon  = str2double(MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON);
	end

	if flag_make_new_plot
		%clf;
		% set up new plot, clear the figure, and initialize the axes


		% Plot the base station with a green star? This sets up the figure for
		% the first time, including the zoom into the test track area.
		if isempty(LLcellZoomArray) % || length(dataToPlot(:,1))>1
			% PLOT STAR?
			h_tempGeoplot = geoplot(reference_latitude+offset_Lat, reference_longitude+offset_Lon, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
		else
			% PLOT NO STAR?

			% h_tempGeoplot = geoplot(dataToPlot(1,1)+offset_Lat, dataToPlot(1,2)+offset_Lon, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
			h_tempGeoplot = geoplot(nan, nan, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
			% firstNotNaNIndex = find(~isnan(LLcellZoomArray(:,1)),1);
			% set(gca,'MapCenter',LLcellZoomArray(firstNotNaNIndex,1:2));
			set(gca,'MapCenter',[reference_latitude reference_longitude]);
		end

		h_parent =  get(h_tempGeoplot,'Parent');
		set(h_parent,'ZoomLevel',16.375);
		try
			geobasemap satellite

		catch
			warning('Unable to load satellite view. Defaulting to OpenStreetMap view.')
			geobasemap openstreetmap
		end
		geotickformat -dd
		hold on
	end

	% Plotting any data?
	if flag_plot_data
		NplotPoints = length(LLcellZoomArray(:,1));


		% make plots
		if formatting_type==1
			finalPlotFormat = fcn_DebugTools_extractPlotFormatFromString(plotFormat, (-1));
		elseif formatting_type==2
			finalPlotFormat.Color = plotFormat;
		elseif formatting_type==3
			finalPlotFormat = plotFormat;
		else
			warning('on','backtrace');
			warning('An unkown input format is detected in the main code - throwing an error.')
			error('Unknown plot type')
		end

		% If plotting only one point, make sure point style is filled
		if isscalar(LLcellZoomArray)
			if ~isfield(plotFormat,'Marker') || strcmp(plotFormat.Marker,'none')
				finalPlotFormat.Marker = '.';
				finalPlotFormat.LineStyle = 'none';
			end
		end

		% Do plot
		temp_gca_handle = gca;
		currentZoom = get(temp_gca_handle,'ZoomLevel');
		roundedCurrentZoom = round(currentZoom,3);
		allZoomLevels = cell2mat(LLcellZoomArray(:,1));
		closestZoomIndex = find(round(allZoomLevels,3)==roundedCurrentZoom,1);
		if isempty(closestZoomIndex)
			error('Unable to find a matching zoom index. Exiting.');
		end

		% Pull out the data to be plotted
		dataToPlot = LLcellZoomArray{closestZoomIndex,2};
		Nplotted = length(dataToPlot(:,1));
		Ntotal = length(LLcellZoomArray{end,2}(:,1));

		% Check to see if the data has been plotted previously. If so, then
		% handleName will match one of the existing values
		existingHandles = get(gca,'UserData');
		flagFoundExistingHandle = 0;
		if ~isempty(existingHandles)
			allHandles = existingHandles.allHandles;
			allHandleNames = existingHandles.handleNames;
			thisHandleIndex = find(strcmp(allHandleNames,handleName),1);
			if ~isempty(thisHandleIndex)
				flagFoundExistingHandle = 1;
				thisHandle = allHandles{thisHandleIndex};
			else
				thisHandleIndex = length(allHandleNames)+1;
			end
		else
			allHandles = cell(1,1);
			allHandleNames = cell(1,1);
			thisHandleIndex = 1;
		end

		if flagFoundExistingHandle==0
			if flag_make_new_plot && ~isempty(dataToPlot)
				thisHandle = h_tempGeoplot;
				set(thisHandle,'LatitudeData',dataToPlot(:,1)+offset_Lat, 'LongitudeData',dataToPlot(:,2)+offset_Lon,'LineStyle','-','Marker','none');
			else
				thisHandle = geoplot(dataToPlot(:,1)+offset_Lat,dataToPlot(:,2)+offset_Lon);
			end
		else
			set(thisHandle,'LatitudeData',dataToPlot(:,1)+offset_Lat, 'LongitudeData',dataToPlot(:,2)+offset_Lon,'LineStyle','-','Marker','none');
		end
		title(sprintf('Zoom: %.0f',roundedCurrentZoom))
		subtitle(sprintf('Points used: %.2f%%', Nplotted*100/Ntotal));


		% if ~isnan(dataToPlot(end,1:2))
		%     set(gca,'MapCenter',dataToPlot(end,1:2));
		% end

		% Fix attributes
		if ~isempty(dataToPlot)
			list_fieldNames = fieldnames(finalPlotFormat);
			for ith_field = 1:length(list_fieldNames)
				thisField = list_fieldNames{ith_field};
				thisHandle.(thisField) = finalPlotFormat.(thisField);
			end
		end

		% Save the handle result for the next time the function is called
		allHandles{thisHandleIndex,1} = thisHandle;
		allHandleNames{thisHandleIndex,1} = handleName;
		existingHandles.allHandles = allHandles;
		existingHandles.handleNames = allHandleNames;
		set(gca,'UserData',existingHandles);

	end

end
if flag_do_debug
	fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end
end % Ends main function

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

