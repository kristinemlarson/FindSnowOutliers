function [h_out]=plot_raw(site_ind,snr_ind,fignum)
%PLOT_RAW - Plots raw SNR data
%
% Syntax:  [h_out]=plot_raw(site_ind,snr_ind,fignum)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%   fignum              figure number to plot the first cut data on
%
% Global Parameters:
%   format
%       .line_style_raw         default 'none'
%       .marker_raw             default '.'
%       .marker_size_raw        default 6
%       .color.raw              default 'k'
%
% Outputs:
%   h_out               Plot Handle
%
%
% See also: SNR_OUTLIERS_MAIN
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% April 12, 2013; Last revision: August 07, 2013
% Current Version: 1.1
% Backward Compatible Version: 1.1
% Precedent Versions: load_format.m (1.1)
% Dependent Versions: N/A

%% Load Globals
global format constants sites_list

%% Predeclare
h_out=[];

%% Get SNR Data

if(isfield(sites_list(site_ind).snr{snr_ind},'raw'))
    data=sites_list(site_ind).snr{snr_ind}.raw;
else
    data=zeros(0,4);
end

if(isempty(data))
    return
end
ydec=data(:,3);
snr=data(:,4);

%% Load Format Variables
% Line Style
if(isfield(format,'line_style_raw'))                % Specific
    line_style=format.line_style_raw;
elseif(isfield(format,'line_style'))                % SNR Default
    line_style=format.line_style;
else                                                % Default
    line_style='none';
end
% Marker
if(isfield(format,'marker_raw'))                    % Specific
    marker=format.marker_raw;
elseif(isfield(format,'marker'))                    % SNR Default
    marker=format.marker;
else                                                % Default
    marker='.';
end
% Marker Size
if(isfield(format,'marker_size_raw'))              % Specific
    marker_size=format.marker_size_raw;
elseif(isfield(format,'marker_size'))               % SNR Default
    marker_size=format.marker_size;
else                                                % Default
    marker_size=6;
end
% Color
if(isfield(format.color,'raw'))                    % Specific
    color=format.color.raw(:,snr_ind);
else
    color='k';                                      % Default
end


%% Change to Figure
figure(fignum)

%% Plot
hold on
h_out=plot(ydec,snr,'Marker',marker,'LineStyle',line_style,'MarkerSize',marker_size,'Color',color);

%% Adjust Axes
% X limit
if(isfield(format,'plot_xlim')&&~isempty(format.plot_xlim))
    xlimit=reshape(format.plot_xlim,1,2);
else
    xlimit=[constants.snr_yrs(1) constants.snr_yrs(end)+1];                   % Use SNR data endpoints
end
xlim(xlimit);
