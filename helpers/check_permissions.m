function [] = check_permissions(filename)
%CHECK_PERMISSIONS - Checks the input file to see if the permissions are
% correct
% 
%
% Syntax:   check_permissions(filename)
%
% Inputs:
%   filename    file to be checked
%
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN 
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% June 07, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A


%% Check Permissions
[~, u] = system(['group-rw ' filename]);
% remove the tab or EOL at the end of userID

%% Check that there is rw
if (u(2:2) == 'w')      % There is read/write
else                    % No read/write
  system(['chmod 664 ' filename]);
end

end % function