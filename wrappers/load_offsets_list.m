function []=load_offsets_list()
%LOAD_OFFSETS_LIST - Loads information from a specified list of offsets to
% be removed
%   Modify this wrapper to add antenna and receiver change information to
%   the list of sites that is output by load_sites_list.m
%
% Syntax:  load_offsets_list()
%
% Inputs:
%
% Global Parameters:
%       constants
%           .offsets_list           filename to read in
%
% Outputs:
%
% Changes to Globals:
%       sites_list(i)
%           .offset_dates           [year doy year.dec] dates of all
%                                   offsets listed in the offset list added
%                                   to the list already present for each
%                                   site
%

%%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN

% Author: Kyle Wolma
%   University of Colorado at Boulder
% May 17, 2013; Last revision: October 09, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants sites_list

%% Load File
filename=constants.offsets_file;

if(exist(filename,'file'))  
    %% Open File
    fid=fopen(filename,'r');    
    
    %% Read Each Line
    while(~feof(fid))
        line=fgets(fid);
        if(line==-1)        % EOF
            break;
        end
        % Check for Comments or leading space
        if (~isspace(line(1))&&line(1) ~= '%')      % Ignore lines with a leading space and comment lines
            line=strcat(line);                      % Convert line to string
            scan=textscan(line,'%s');               % Text scan into an array of Strings
            scan=scan{1,1};
            
            % Check if the first entry is the site id
            if(constants.case_sensitive)
                site_match=strcmp(scan{1,1},{sites_list.sid});
            else
                site_match=strcmpi(scan{1,1},{sites_list.sid});
            end
            % Check to be sure the scan has at least 3 cells
            if(max(site_match)&&length(scan)>2)
                % Pull out year doy
                year=str2double(scan{2,1});
                doy=str2double(scan{3,1});
                % Calculate year.dec
                change=[year,doy];
                change(1,3)=ydoy2ydec(change);
                % Add to site info
                sites_list(site_match).offset_dates=unique(sort_by_ydec([sites_list(site_match).offset_dates;change]),'rows');
                
            end
        end
        
        
    end % end while loop
    
    %% Close File
    fclose(fid);
    
else    % file did not exist
    format_print('  Offset List Does not Exist.\n',1)
    format_print('  No Offsets Loaded\n',1)
    
end
