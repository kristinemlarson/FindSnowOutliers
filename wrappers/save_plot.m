function save_plot(plot_name,dps)
%SAVE_PLOT - Save a Plot to the specified plot file name at a given
%resolution
%   Modify this wrapper to change how plots are saved
%
% Syntax:  save_plot(plot_name,dps)
%
% Inputs:
%   plot_name           filename for output  eg: p041_1.jpg 
%   dps (optional)      print resolution dots per inch [150]
%
% Outputs:
%
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN

% Author: Kyle Wolma
%   University of Colorado at Boulder
% June 07, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A


%% Handle Inputs
if(nargin<2)
    dps=150;
end




%% Print Plot as Color EPS
print('-depsc',['-r' num2str(dps)], plot_name(1:end-4));

%% Convert to input plot name
system(['convert -density ' num2str(dps) ' ' plot_name(1:end-4) '.eps ' plot_name]);

%% Remove EPS file
system(['rm ' plot_name(1:end-4) '.eps']);

%% Permissions
check_permissions(plot_name);

end % function