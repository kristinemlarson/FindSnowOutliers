function [h_out]=plot_bad_snr_mask(site_ind,snr_ind,fignum)
%PLOT_BAD_SNR_MASK - Plots the data points marked as bad by the SNR mask
%
% Syntax:  [h_out]=plot_bad_snr_mask(site_ind,snr_ind,fignum)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%   fignum              figure number to plot the first cut data on
%
% Global Parameters:
%   format
%       .line_style_bad_bask    default 'none'
%       .marker_bad_mask        default '.'
%       .marker_size_bad_mask   default 6
%       .color.bad_mask         default 'b'
%
% Outputs:
%   h_out               Plot Handle
%
%
% See also: SNR_OUTLIERS_MAIN REMOVE_SNR_MASK
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% May 14, 2013; Last revision: August 07, 2013
% Current Version: 1.1
% Backward Compatible Version: 1.1
% Precedent Versions: load_format.m (1.1)
% Dependent Versions: N/A

%% Load Globals
global constants format sites_list

%% Predeclare
h_out=[];

%% Get SNR_Data
if(isfield(sites_list(site_ind).snr{snr_ind},'bad_snr_mask'))
    data=sites_list(site_ind).snr{snr_ind}.bad_snr_mask;
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
if(isfield(format,'line_style_bad_mask'))           % Specific
    line_style=format.line_style_bad_mask;
elseif(isfield(format,'line_style_bad'))            % Bad Data Default
    line_style=format.line_style_bad;
elseif(isfield(format,'line_style'))                
    line_style=format.line_style;
else                                                % Default
    line_style='none';                     
end
% Marker
if(isfield(format,'marker_bad_mask'))               % Specific
    marker=format.marker_bad_mask;
elseif(isfield(format,'marker_bad'))                % Bad Data Default
    marker=format.marker_bad;
elseif(isfield(format,'marker'))                
    marker=format.marker;
else                                                % Default
    marker='.';                     
end
% Marker Size
if(isfield(format,'marker_size_bad_mask'))          % Specific
    marker_size=format.marker_size_bad_mask;
elseif(isfield(format,'marker_size_bad'))           % Bad Data Default
    marker_size=format.marker_size_bad;
else                                                % Default
    marker_size=6;                     
end
% Color
if(isfield(format.color,'bad_mask'))                % Specific
    color=format.color.bad_mask(:,snr_ind);
elseif(isfield(format.color,'bad'))                 % Bad Data Default
    color=format.color.bad(:,snr_ind);
else
    color='b';                                      % Default
end



%% Change to Figure
figure(fignum)

%% Plot
h_out=plot(ydec,snr,'Marker',marker,'LineStyle',line_style,'MarkerSize',marker_size,'Color',color);
