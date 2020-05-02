function [h_out] = plot_neu_positions(site_ind,snr_ind,fignum)
%PLOT_NEU_POSITIONS - Plots North, East, and Up positions
%
% Syntax:  [h_out]=plot_neu_positions(site_ind,snr_ind,fignum)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%   fignum              figure number to plot the first cut data on
%
% Global Parameters:
% Outputs:
%   h_out               Plot Handle
%
%
% See also: SNR_OUTLIERS_MAIN
%
% Programmer: John Paul Russo
%   University of Colorado at Boulder
% August 26, 2013; Last revision: October 08, 2013
% Current Version: 2.0
% Backward Compatible Version: 2.0
% Precedent Versions: main_plotter.m; save_snr_flags.m;load_neu_positions.m (2.0)
% Dependent Versions: N/A

% 8/28/2013: created subplots of north east and up.
% 8/30/2013: added formatting and printPNG.
% 9/1/2013: JR - fixed print address,axis labels, and units.
%           JR - removed mean value from position data
%           JR - reads in data from ssss_L2_flag.txt and uses this to
%                mark bad points on the plot. Tested on p150 and p041.
%           JR   fixed to account for offset between data sets(not quite done).
% 9/4/2013: JR - uses intersect to align the flag data and position data
% 9/9/2013: JR - restructured main loop, added legend, and integrated with snr_outliers
% 9/11/2013: JR - fixed a fontsize issue

%% Load Globals
global format sites_list constants
outliers = [];
markerSize =format.marker_size;
set(0,'DefaultLineMarkerSize',markerSize);

%% Load year, doy, NEU data
stationName = sites_list(site_ind).sid;
year=sites_list(site_ind).neu.year;
dayOfYear=sites_list(site_ind).neu.doy;
northEastUp=sites_list(site_ind).neu.neu;
source=sites_list(site_ind).neu.source;
if ~isempty(northEastUp)
    %% Load the flag data for given station
    flagData=sites_list(site_ind).snr{snr_ind}.flags;
    flagYear = flagData(:,1);
    flagDay = flagData(:,2);
    flagTimes=flagData(:,3);
    flags = flagData(:,4);
    
    %% Create time vector
    % time vector for position data
    time = ydoy2ydec([year,dayOfYear]);
    % C is the new time vector for the plots
    [C,IA,IB] = intersect(time,flagTimes);
    %% Remove mean value
    northEastUp(:,1) = northEastUp(:,1) - mean(northEastUp(:,1));
    northEastUp(:,2) = northEastUp(:,2) - mean(northEastUp(:,2));
    northEastUp(:,3) = northEastUp(:,3) - mean(northEastUp(:,3));
    
    %% convert position units from m to mm.
    northEastUp = 1000*northEastUp;
    
    figure(fignum)
    %% Create subplots of position data
    
    for j = 1:3
        %% Find outliers with flag data
       count = 1;
       count_out = 1;
       for i = 1:length(C)
         if flags(IB(i)) == 0
           outliers(count_out,:) = [C(i),northEastUp(IA(i),j)];
           count_out = count_out + 1;
         elseif flags(IB(i)) == 1
           pos(count,:) = [C(i),northEastUp(IA(i),j)];
           count = count + 1;
         end
        end
        %% Determine subplot
        subplot(3,1,j);
        %% Plot Outliers on Position Data
        hold on; grid on;
        h_pos = plot(pos(:,1),pos(:,2),'.'); % position data
        if length(outliers) > 0
          h_outs = plot(outliers(:,1),outliers(:,2),'r.'); % outliers
        end
        hold off;
        
        %% Format plots
        if j == 1
          title(['SNR Outlier Detection on ' stationName ' ',source,' Positions'])
          ylabel('North, mm')
          set(gca,'XTickLabel',[])
        elseif j == 2
          ylabel('East, mm')
          set(gca,'XTickLabel',[])
        else
          ylabel('Up, mm')
        end
    end
    %% Legend
    subplot(3,1,1)
    ylimits = get(gca,'YLim');
    xlimits = get(gca,'XLim');
    ytext = ylimits(2)-0.10*diff(ylimits);
    xtext = xlimits(1) + 0.05*diff(xlimits);
    text(xtext,ytext,'Outliers indicated in red','Color','r');
else
%    format_print('    Error Occurred!!\n\n',0);                     % Display Errors (0)
    format_print('    NEU Positions do not exist\n',0)              % Display Errors (0)
end
end
