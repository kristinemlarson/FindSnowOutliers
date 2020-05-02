function [sites] = read_sites_list(filename)
%READ_SITES_LIST - Reads in an input file with a list of sites to use and
% creates a cell string list of unique sites
%
% Syntax:  [sites] = read_sites_list(filename)
%
% Inputs:
%   filename        String  file to read a list of stations from  
%
% Outputs:
%   sites           {Nx1} Cell String containing each site in a row
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% April 05, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants
num_chars=constants.sid_length;

%% Predeclare
sites = {''};


%% Get Filename

if(exist(filename,'file'))
    %% Open File
    fid = fopen(filename,'r');
    if (fid == -1)
        format_print('  Unable to Open Sites List!!\n\n',0);                    % Display Errors (0)
        format_print(filename,0);                                               % Display Errors (0)
        return
    end
    
    %% Process Each line of the file
    ind= 1;
    while ~feof(fid)
        line = fgets(fid);
        if(line~=-1)  % line=-1 for eof
            if (~isspace(line(1))&&line(1) ~= '%') % Ignore lines with a leading space and comment lines
                % Check if it is already in the list
                current_id=line(1:num_chars);
                if(constants.case_sensitive)
                    inds=strcmp(current_id,sites);
                else
                    inds=strcmpi(current_id,sites);
                end
                % Add the current_id if it is not already in the list
                if(~max(inds))                  % max(inds)=false=0 if the site is not in the list
                    sites{ind,1} = current_id;
                    ind=ind+1;
                end
            end
        end
    end
    
    %% Close File
    fclose(fid);
    
else % file does not exist
    format_print(sprintf(' Input Site List file:\n %s \n does not exist\n',filename),0,true)
end
end
