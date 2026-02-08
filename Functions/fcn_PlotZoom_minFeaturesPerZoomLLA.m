function LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA( LLdata, varargin)
% Given LLA to be plotted, creates a cell array of the same data,
% downsampling it so that, at every zoom level possible in a geoplot, only
% the features that are at least one pixel are plotted.
%
% FORMAT:
%
%      LLdataCellArray = fcn_PlotZoom_minFeaturesPerZoomLLA( LLdata, (figNum))
%
% INPUTS:
%
%      LLdata - the input data representing Latitude and Longitude
%
%      (OPTIONAL INPUTS)
%
%      figNum             - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%      LLdataCellArray - a {Nx2} cell array, one row for each zoom level
%      containing:
%          column1: the zoom level
%          column2: the down-sampled LLdata for the zoom level
%
% DEPENDENCIES:
%
%      GPS class
%      gps_object.WGSLLA2ENU
%      fcn_PlotZoom_stretchDataToLength
%      fcn_PlotZoom_minPixelLengthPerZoom
%
% EXAMPLES:
%
% See the script:
%
%       script_test_fcn_PlotZoom_minFeaturesPerZoomLLA
%
% for a full test suite.
%
% This function was written on 2026_02_07 by S. Brennan
% Questions or comments? snb10@psu.edu

% REVISION HISTORY:
%
% 2026_02_07 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotZoom_minFeaturesPerZoomLLA
%   % * Created function by pulling out INTERNAL function from 
%   %   % script_test_fcn_PlotZoom_zoomPlotLL


% TO-DO:
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 2; % The largest Number of argument inputs to the function
flag_max_speed = 0;
if (nargin==MAX_NARGIN && isequal(varargin{end},-1))
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS");
    MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS);
    end
end

% flag_do_debug = 1;

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_figNum = 999978; %#ok<NASGU>
else
    debug_figNum = []; %#ok<NASGU>
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
		narginchk(MAX_NARGIN-1,MAX_NARGIN);

		% Validate LLdata to be sure it has 2 or 3 columns, 1+ rows
		fcn_DebugTools_checkInputsToFunctions(LLdata, '2or3column_of_mixed',[1 2]);

		% Validate XYdata to be sure it has 2 columns, 1+ rows
		% fcn_DebugTools_checkInputsToFunctions(XYdata, '2column_of_numbers',[1 2]);

	end
end

% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin) 
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp; 
        flag_do_plots = 1;
    end
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

% Find the ENU data equivalent
gps_object = GPS(reference_latitude, reference_longitude, reference_altitude); % Initiate the class object for GPS

% Use the class to convert LLA to ENU
ENU_data = gps_object.WGSLLA2ENU(LLdata(:,1), LLdata(:,2), LLdata(:,1)*0);

[zoomLevels, minMetersPerPixel] = fcn_PlotZoom_minPixelLengthPerZoom;
Nzooms = length(zoomLevels);
LLdataCellArray = cell(Nzooms,2);
ENUdataCellArray = cell(Nzooms,2);
for ith_zoom = Nzooms:-1:1
	thisMinLength = minMetersPerPixel(ith_zoom)*8;
	ENUdataCellArray{ith_zoom,1} = zoomLevels(ith_zoom,1);
	LLdataCellArray{ith_zoom,1} = zoomLevels(ith_zoom,1);
	[~, indicesUsed] = fcn_PlotZoom_stretchDataToLength(thisMinLength, ENU_data, (-1));
	ENUdataCellArray{ith_zoom,2} = ENU_data(indicesUsed,:);
	LLdataCellArray{ith_zoom,2} = LLdata(indicesUsed,:);
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
	figure(figNum);
	for ith_zoom = Nzooms:-1:1
		zoomLevel = ENUdataCellArray{ith_zoom,1};
		ENUdata = ENUdataCellArray{ith_zoom,2};
		if ~isempty(ENU_data)
			plot(ENUdata(:,1),ENUdata(:,2),'-');
		end
		title(sprintf('Zoom: %.3f',zoomLevel));
		pause(0.1);
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

