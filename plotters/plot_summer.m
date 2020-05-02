function [h_out]=plot_summer(site_ind,snr_ind,fignum)
%PLOT_SUMMER - Plots the summer SNR data points
%
% Syntax:  [h_out]=plot_summer(site_ind,snr_ind,fignum)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%   fignum              figure number to plot the first cut data on
%
% Global Parameters:
%   format
%       .line_style_summer      default 'none'
%       .marker_summer          default '.'
%       .marker_size_summer     default 6
%       .color.summer           default 'k'
%
% Outputs:
%   h_out               Plot Handle
%
%
% See also: SNR_OUTLIERS_MAIN REMOVE_SECOND_CUT
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% May 15, 2013; Last revision: August 07, 2013
% Current Version: 1.1
% Backward Compatible Version: 1.1
% Precedent Versions: load_format.m (1.1)
% Dependent Versions: N/A

%% Load Globals
global format sites_list

%% Predeclare
h_out=[];

%% Get SNR Data
if(isfield(sites_list(site_ind).snr{snr_ind},'summer_pts'))
    data=sites_list(site_ind).snr{snr_ind}.summer_pts;
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
if(isfield(format,'line_style_summer'))             % Specific
    line_style=format.line_style_summer;
elseif(isfield(format,'line_style'))                
    line_style=format.line_style;
else                                                % Default
    line_style='none';                     
end
% Marker
if(isfield(format,'marker_summer'))             % Specific
    marker=format.marker_summer;
elseif(isfield(format,'marker'))                
    marker=format.marker;
else                                                % Default
    marker='.';                     
end
% Marker Size
if(isfield(format,'marker_size_summer'))            % Specific
    marker_size=format.marker_size_summer;
elseif(isfield(format,'marker_size'))               % Bad Data Default
    marker_size=format.marker_size;
else                                                % Default
    marker_size=6;                     
end
% Color
if(isfield(format.color,'summer'))                  % Specific
    color=format.color.summer(:,snr_ind);
else
    color='b';                                      % Default
end



%% Change to Figure
figure(fignum)

%% Plot
h_out=plot(ydec,snr,'Marker',marker,'LineStyle',line_style,'MarkerSize',marker_size,'Color',color);
