function [h_out]=plot_third_cut_fit(site_ind,snr_ind,fignum)
%PLOT_THIRD_CUT_FIT - Plots the sinusoidal fit for the third cut
%
% Syntax:  [h_out]=plot_third_cut_fit(site_ind,snr_ind,fignum)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%   fignum              figure number to plot the first cut data on
%
% Global Parameters:
%   format
%       .line_style_cut3_fit    default '--'
%       .line_width_cut3_fit    default 1
%       .color.cut3_fit         default [.5;.5;.5;]
%
% Outputs:
%   h_out               Plot Handle
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
if(isfield(sites_list(site_ind).snr{snr_ind},'third_cut_fit'))
    data=sites_list(site_ind).snr{snr_ind}.third_cut_fit;
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
if(isfield(format,'line_style_cut3_fit'))           % Specific
    line_style=format.line_style_cut3_fit;
elseif(isfield(format,'line_style'))                % SNR Default
    line_style=format.line_style;
else                                                % Default
    line_style='-';                     
end
% Line Width
if(isfield(format,'line_width_cut3_fit'))           % Specific
    line_width=format.line_width_cut3_fit;
elseif(isfield(format,'line_width'))                % SNR Default
    line_width=format.line_width;
else                                                % Default
    line_width=2;                     
end
% Color
if(isfield(format.color,'cut3_fit'))                % Specific
    color=format.color.cut3_fit(:,snr_ind);
else
    color=[0.5;0.5;0.5];                            % Default
end



%% Change to Figure
figure(fignum)

%% Plot
hold on
h_out=plot(ydec,snr,'LineStyle',line_style,'LineWidth',line_width,'Color',color);
