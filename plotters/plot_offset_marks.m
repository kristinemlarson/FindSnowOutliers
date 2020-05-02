function [h_out]=plot_offset_marks(site_ind,snr_ind,fignum)
%PLOT_OFFSET_MARKS - Plots a vertical line for each offset
%
% Syntax:  [h_out]=plot_offset_marks(site_ind,snr_ind,fignum)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%   fignum              figure number to plot the first cut data on
%
% Global Parameters:
%   format
%       .line_style_offset_marks default '--'
%       .line_width_offset_marks default 1
%       .color.offset_marks      default 'k'
%
% Outputs:
%   h_out               Plot Handle
%
%
% See also: SNR_OUTLIERS_MAIN REMOVE_OFFSETS
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% May 28, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global format sites_list

%% Predeclare
h_out=[];

%% Get Offset Data
if(isfield(sites_list(site_ind).snr{snr_ind},'offset_deltas'))
    offsets=sites_list(site_ind).snr{snr_ind}.offset_deltas;
else
    offsets=zeros(0,1);
end
if(isempty(offsets))
    return
end
ydec=offsets(:,1);


%% Load Format Variables
% Line Style
if(isfield(format,'line_style_offset_marks'))       % Specific
    line_style=format.line_style_offset_marks;
elseif(isfield(format,'line_style'))                % SNR Default
    line_style=format.line_style;
else                                                % Default
    line_style='--';                     
end
% Line Width
if(isfield(format,'line_width_offset_marks'))       % Specific
    line_width=format.line_width_offset_marks;
else                                                % Default
    line_width=1;                     
end
% Color
if(isfield(format.color,'offset_marks'))            % Specific
    color=format.color.offset_marks(:,snr_ind);
else
    color='k';                                      % Default
end



%% Change to Figure
figure(fignum)
hold on

%% Plot
ylims=ylim;
for ind=1:length(ydec)
    
    h_out=plot([ydec(ind,1) ydec(ind,1)],ylims,'LineStyle',line_style,'LineWidth',line_width,'Color',color);

end
