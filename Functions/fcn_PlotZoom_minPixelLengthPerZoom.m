function [zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom(varargin)
%%fcn_PlotZoom_minPixelLengthPerZoom   minimum ground length (m) per pixel for zooms 0:1/8:25
%
% This function returns the minimum ground length represented by one pixel
% (meters) for zoom levels from 0 to 25 in steps of 1/8. It uses the
% Web‑Mercator tile convention (tile size = 256 px, world circumference =
% 40,075,016.686 m) and treats fractional zooms by using 2^z. Because
% meters-per-pixel for longitude scales with cos(latitude), the minimum
% meters/pixel on a displayed map occurs at the maximum absolute latitude
% in the view. By default the function uses the Web‑Mercator latitude limit
% ±85.05112878° (the usual tile limit). 
%
% If you want the meters/pixel at a specific latitude (e.g., map center),
% enter the mapCenterLatitude. 
% 
% Notes
%   - Uses Web-Mercator tile convention (tile size = 256 px).
%   - minDegPerPixelLon = 360 / (256 * 2^z).
%   - minDegPerPixelLat = minDegPerPixelLon * cos(maxLat), with maxLat = 85.05112878°.
%   - Increasing zoom by +1 halves meters/pixel (twice the linear
%     resolution). Fractional zooms are supported by 2^z scaling.
%
% FORMAT:
%
%       [zoomLevels, minMetersPerPixel, minDegPerPixelLon, minDegPerPixelLat] = fcn_PlotZoom_minPixelLengthPerZoom((mapCenterLatitude), (figNum))
%
% INPUTS:
%
%      (OPTIONAL INPUTS)
%
%      mapCenterLatitude  - the latitude to use as a reference for
%      calculations. If MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE global
%      variable is defined, this latitude is used. Otherwise, a maximum
%      latitude of 85.05112878 is used, which is the absolute limit
%      supported by the tiling function used in MATLAB, as this produces
%      the smallest lengths per pixel, and hence the most conservative
%      estimates.
%
%      figNum             - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%      zoomLevels         - vector of zoom levels (0:1/8:25)
%
%      minMetersPerPixel  - vector of minimum meters per pixel at each
%      zoom. The result is meters per single pixel. 
%   
%      minDegPerPixelLon  - minimum degrees of longitude per pixel at
%      each zoom
%   
%      minDegPerPixelLat  - minimum degrees of latitude  per pixel at
%      each zoom
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%   [z,mpp] = fcn_PlotZoom_minPixelLengthPerZoom;
%   plot(z,mpp); set(gca,'YScale','log'); ylabel('meters / pixel');
%
% See the script:
%
%       script_test_fcn_PlotZoom_minPixelLengthPerZoom.m 
%
% for a full test suite.
%
% This function was written on 2026_02_02 by S. Brennan
% Questions or comments? snb10@psu.edu

% REVISION HISTORY:
%
% As: fcn_plotRoad_minPixelLengthPerZoom
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - Wrote the code originally, copilot code to start
%
% As: fcn_PlotZoad_minPixelLengthPerZoom
%
% 2026_02_07 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotZoom_minPixelLengthPerZoom
%   % * Pulled function into PlotZoom repo

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
        narginchk(0,MAX_NARGIN);

    end
end

% Check the mapCenterLatitude input
mapCenterLatitude = 85.05112878; % Default worst-case latitude
MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE = getenv("MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE");
if ~isempty(MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE)
	mapCenterLatitude = str2double(MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE);
end
if 1 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        mapCenterLatitude = temp;
    end
end

% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin) 
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp; %#ok<NASGU>
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

% Constants (Web Mercator / tile scheme)
earthCircumference = 40075016.686;   % meters
tileSize = 256;                      % pixels per tile (typical)

% Use Web-Mercator latitude limit (max absolute latitude supported by
% tiles) or user-specified latitude to calculate location-specific arc
% distance.
maxLatRad = deg2rad(mapCenterLatitude);

% Zoom levels: 0 to 25 in steps of 1/8
zoomLevels = (0 : 1/8 : 25)';

% Resolution at a given zoom and latitude:
% metersPerPixel(z,lat) = earthCircumference * cos(lat) / (tileSize * 2^z)
% Minimum across lat range [-maxLat, +maxLat] occurs at ±maxLat (cos small).
cosMaxLat = cos(maxLatRad);

% compute min meters per pixel for each zoom
minMetersPerPixel = (earthCircumference * cosMaxLat) ./ (tileSize .* 2.^zoomLevels);

% Compute arc lengths per pixel
minDegPerPixelLon = 360 ./ (tileSize .* 2.^zoomLevels);
minDegPerPixelLat = minDegPerPixelLon .* cosMaxLat;

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
   
	% Nothing to plot

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

