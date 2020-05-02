function [h_out]=plot_third_cut_sigma(site_ind,snr_ind,fignum)
%PLOT_THIRD_CUT_SIGMA - Plots the sigma line for the third cut sinusoidal fit
%
% Syntax:  [h_out]=plot_third_cut_simga(site_ind,snr_ind,fignum)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%   fignum              figure number to plot the first cut data on
%
% Global Parameters:
%   format
%       .line_style_cut3_sigma  default '--'
%       .line_width_cut3_sigma  default 1
%       .color.cut3_sigma       default 'b'
%
% Outputs:
%   h_out               [low,high]Plot Handle for both boundaries
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
global format constants sites_list

%% Predeclare
h_out=[];

%% Get SNR Data
if(isfield(sites_list(site_ind).snr{snr_ind},'third_cut_sigma'))
    data=sites_list(site_ind).snr{snr_ind}.third_cut_sigma;
else
    data=zeros(0,4);
end

if(isempty(data))
    return
end

ydec=data(:,3);
low=data(:,4);
high=data(:,5);

%% Load Format Variables
% Line Style
if(isfield(format,'line_style_cut3_sigma'))         % Specific
    line_style=format.line_style_cut3_sigma;
elseif(isfield(format,'line_style'))                % SNR Default
    line_style=format.line_style;
else                                                % Default
    line_style='--';                     
end
% Line Width
if(isfield(format,'line_width_cut3_sigma'))         % Specific
    line_width=format.line_width_cut3_sigma;
elseif(isfield(format,'line_width'))                % SNR Default
    line_width=format.line_width;
else                                                % Default
    line_width=1;                     
end
% Color
if(isfield(format.color,'cut3_sigma'))              % Specific
    color=format.color.cut3_sigma(:,snr_ind);
elseif(isfield(format.color,'cut3_fit'))            % Fit Default
    color=format.color.cut3_fit(:,snr_ind);
else
    color=[0;0;1];                                  % Default
end



%% Change to Figure
figure(fignum)

%% Plot
hold on
if(constants.cut3_outliers(1))  % Plot low if low was removed
    h_out(1)=plot(ydec,low,'LineStyle',line_style,'LineWidth',line_width,'Color',color);
end  
if(constants.cut3_outliers(2))  % Plot high if high was removed
    h_out(2)=plot(ydec,high,'LineStyle',line_style,'LineWidth',line_width,'Color',color);
end
