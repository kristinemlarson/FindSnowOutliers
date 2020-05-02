function [h_out]=plot_summer_min(site_ind,snr_ind,fignum)
%PLOT_SUMMER_MIN - Plots a horizontal line across each year that a summer
% is used
%
% Syntax:  [h_out]=plot_summer_min(site_ind,snr_ind,fignum)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%   fignum              figure number to plot the first cut data on
%
% Global Parameters:
%   format
%       .line_style_summer_min  default '--'
%       .line_width_summer_min  default 1
%       .color.summer_min       default 'b'
%
% Outputs:
%   h_out               [Nx1]Plot Handles for each summer min line
%
%
% See also: SNR_OUTLIERS_MAIN
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% May 15, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global format sites_list

%% Predeclare
h_out=[];

%% Get SNR Data
if(isfield(sites_list(site_ind).snr{snr_ind},'second_cut_params'))
    params=sites_list(site_ind).snr{snr_ind}.second_cut_params;
else
    params=zeros(0,4);
end
if(isempty(params))
    return
end

%% Load Format Variables
% Line Style
if(isfield(format,'line_style_summer_min'))         % Specific
    line_style=format.line_style_summer_min;
elseif(isfield(format,'line_style'))                % SNR Default
    line_style=format.line_style;
else                                                % Default
    line_style='-';
end
% Line Width
if(isfield(format,'line_width_summer_min'))         % Specific
    line_width=format.line_width_summer_min;
elseif(isfield(format,'line_width'))                % SNR Default
    line_width=format.line_width;
else                                                % Default
    line_width=2;
end
% Color
if(isfield(format.color,'summer_min'))              % Specific
    color=format.color.summer_min(:,snr_ind);
elseif(isfield(format.color,'summer'))              % Summer
    color=format.color.summer(:,snr_ind);
else
    color=[0;0;1];                                  % Default
end



%% Change to Figure
figure(fignum)

%% Sort Each Summer
[nr,~]=size(params);
for ind=1:nr
    %% Plot Each Summer
    yr=[floor(params(ind,1)),floor(params(ind,1)+1)];  % use years as end points for line
    min=[params(ind,3);params(ind,3)];
    hold on
    h_out(ind)=plot(yr,min,'LineStyle',line_style,'LineWidth',line_width,'Color',color);
    
end
