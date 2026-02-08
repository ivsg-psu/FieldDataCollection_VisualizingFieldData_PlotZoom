function [stretchedXYdata, indicesUsed] = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, varargin)
% Stretches data until all edges are at least as large as minLength. Achieves stretching by
% removing interior points, grouping points toward side of smaller length.
% Repeats until data edges all pass requirements, or until data disappears.
%
% FORMAT:
%
%       stretchedXYdata = fcn_PlotZoom_stretchDataToLength(minLength, XYdata, (figNum))
%
% INPUTS:
%
%      minLength  - the distance in meters that all edges must be larger
%      than
%
%      XYdata     - the XY input data that will be "stretched"
%
%      (OPTIONAL INPUTS)
%
%      figNum             - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%      stretchedXYdata     - the XY data with same endpoints, and with
%      interior points removed until all edges pass minLength criteria
%
%      indicesUsed - which indices were used from the original data set
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
% See the script:
%
%       script_test_fcn_PlotZoom_stretchDataToLength.m 
%
% for a full test suite.
%
% This function was written on 2026_02_02 by S. Brennan
% Questions or comments? snb10@psu.edu

% REVISION HISTORY:
%
% As: fcn_plot+Road_stretchDataToLength
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - Wrote the code originally
% 
% As: fcn_PlotZoom_stretchDataToLength
%
% 2026_02_07 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotZoom_stretchDataToLength
%   % * Renamed function from fcn_plot+Road_stretchDataToLength


% TO-DO:
%
% 2026_02_02 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 3; % The largest Number of argument inputs to the function
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
		narginchk(MAX_NARGIN-1,MAX_NARGIN);

		% Validate minLength to be sure it has 1 columns, 1 rows
		fcn_DebugTools_checkInputsToFunctions(minLength, '1column_of_numbers',[1 1]);

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
Npoints = length(XYdata(:,1));


if any(isnan(XYdata))
	nanBreaks = isnan(XYdata(:,1));
	indicies_cell_array = fcn_DebugTools_breakArrayByNans(XYdata,-1);
	newIndicesCellArray = cell(size(indicies_cell_array));
	for ith_dataCluster = 1:length(indicies_cell_array)
		indicesInThisCluster = indicies_cell_array{ith_dataCluster};
		thisXYData = XYdata(indicesInThisCluster,:);
		[~, newIndices] = fcn_PlotZoom_stretchDataToLength(minLength, thisXYData, -1);
		newIndicesCellArray{ith_dataCluster} = indicesInThisCluster(newIndices);
	end
	
	indicesUsed = false(Npoints,1); % Initialize values
	indicesRemaining = cell2mat(newIndicesCellArray');
	indicesUsed(indicesRemaining) = true;
	indicesUsed(nanBreaks) = true;
else

	% First, check if bounding box around all data is already smaller than min
	% distance. If so, the data will be returned empty no matter what - no need
	% to calculate
	maxXYs = max(XYdata,[],1);
	minXYs = min(XYdata,[],1);
	diagDist = real(sum((maxXYs-minXYs).^2,2).^0.5);

	if diagDist<minLength
		stretchedXYdata = [];
		indicesUsed = false(Npoints,1);
		return;
	end

	% Greedy selection
	indicesUsed = false(Npoints,1); % Initialize values

	% Save first index as initial start point
	lastIdx = 1;
	indicesUsed(1) = true; % Set first value to true
	lengthToCheck = minLength^2;

	for k = 2:Npoints
		difference = XYdata(lastIdx,:)-XYdata(k,:);
		thisDist = sum(difference.^2,2);
		if thisDist >= lengthToCheck
			indicesUsed(k) = true;
			lastIdx = k;
		end
	end
	% Save last point
	indicesUsed(end) = true;
end

stretchedXYdata = XYdata(indicesUsed,:);
%%%%%%%%%%%%%%%
% Sorting method - very accurate, but VERY slow
% If enter here, may need to calculate data
% stretchedXYdata = XYdata;
% flagKeepGoing = true;
% while flagKeepGoing
% 	% For debugging
% 	if flag_do_debug
% 		figure(debug_figNum);
% 		clf;
% 		hold on;
% 		plot(XYdata(:,1),XYdata(:,2),'.-','LineWidth',5,'MarkerSize',40,'DisplayName','XY Data')
% 		plot(stretchedXYdata(:,1),stretchedXYdata(:,2),'.-','LineWidth',3,'MarkerSize',20,'DisplayName','Stretched XY Data')
% 		legend('Interpreter','none','Location','best');
% 		axis padded 
% 	end
% 
% 
% 	edgeLengths = sum(diff(stretchedXYdata,1,1).^2,2).^0.5;
% 	Nedges = length(edgeLengths);
% 	[shortestEdge,minimumEdgeIndex] = min(edgeLengths);
% 	if shortestEdge>minLength
% 		flagKeepGoing = false;
% 	else
% 		if Nedges==1 || all(isnan(edgeLengths))
% 			% Only one edge left, and it's too small
% 			stretchedXYdata = [];
% 			flagKeepGoing = false;
% 		else
% 			indicesToKeep = true(Nedges+1,1);
% 			if minimumEdgeIndex==1
% 				indicesToKeep(2,1) = false;
% 			elseif minimumEdgeIndex==Nedges
% 				indicesToKeep(end-1,1) = false;
% 			else
% 				% Only way to enter here is if there are 3 or more edges
% 				if all(isnan([edgeLengths(minimumEdgeIndex-1); edgeLengths(minimumEdgeIndex+1)]))
% 					% Both sides are nan-edges
% 					indicesToKeep(minimumEdgeIndex)   = false;
% 					indicesToKeep(minimumEdgeIndex+1) = false;
% 				else
% 					if edgeLengths(minimumEdgeIndex-1)>=edgeLengths(minimumEdgeIndex+1)
% 						% Previous edge longer than following edge
% 						indicesToKeep(minimumEdgeIndex+1) = false;
% 					else
% 						indicesToKeep(minimumEdgeIndex) = false;
% 					end
% 				end
% 			end
% 			stretchedXYdata = stretchedXYdata(indicesToKeep,:);
% 		end
% 
% 	end
% end

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
   hold on;
   axis padded 
   plot(XYdata(:,1),XYdata(:,2),'.-','LineWidth',5,'MarkerSize',40,'DisplayName','XY Data')
   if ~isempty(stretchedXYdata)
	   plot(stretchedXYdata(:,1),stretchedXYdata(:,2),'.-','LineWidth',3,'MarkerSize',20,'DisplayName','Stretched XY Data')
	   title(sprintf('Reduction from %.0f points to %.0f points',length(XYdata(:,1)),length(stretchedXYdata(:,1))));
   end
   legend('Interpreter','none','Location','best');
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

