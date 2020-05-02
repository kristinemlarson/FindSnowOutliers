function []=read_local_bad_days()
%READ_LOCAL_BAD_DAYS - Reads a list of bad days to not use for individual
% sites
%
% Syntax:   read_local_bad_days()
%
% Changes to Globals:
%   constants
%       .local_bad_sids{Nx1}    list of sids corresponding to array of bad
%                               days.  Updated to include information from
%                               the local_bad_days file
%       .local_bad_days{NX1}    array of bad days.  Updated to include 
%                               information from the local_bad_days file
% 
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN

% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% May 17, 2013; Last revision: October 09, 2013
% Current Version: 2.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants

%% Predeclare
local_bad_sids={};
local_bad_days={};

%% Get Filename
filename=constants.local_bad_days_file;

if(exist(filename,'file'))
    %% Open File
    fid = fopen(filename,'r');
    
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
            if(length(scan)>3)
                % Check if the first entry is already in the list
                % Read each line   [sid year start_doy end_doy]
                sid=scan{1,1};
                year=str2double(scan{2,1});
                start_doy=str2double(scan{3,1});
                end_doy=str2double(scan{4,1});
                % Check for proper doy ranges
                if(end_doy<1||start_doy<1||end_doy>366||start_doy>366||end_doy<start_doy)  % doy range must be from 1-366 with end>=start
                else                                % Good doy range
                    % Create array of bad days
                    days=(start_doy:1:end_doy)';      % range of days from start to finish
                    bad_days=[year*ones(length(days),1),days];  % [year doy] [Mx2] for each item in days
                    bad_days(:,3)=ydoy2ydec(bad_days);          % [year doy year.dec] [Mx3]
                    % Find the site in the list of bad days
                    inds=strcmp(sid,local_bad_sids);
                    if(max(inds)) % Already in the list
                        local_bad_days{inds}=unique(sort_by_ydec([local_bad_days{inds};bad_days]),'rows');   % add to existing list and sort it
                    else         % Not Already in the list
                        local_bad_sids{end+1}=sid;
                        local_bad_days{end+1}=bad_days;
                    end
                end     % end doy range check
            end     % end scanning valid line
        end % end skipping comments/whitespace
        
    end
       
    %% Close File
    fclose(fid);

else % file does not exist
    format_print(sprintf(' Input Bad Local Days file:\n %s \n does not exist\n',filename),0,true)
end

%% Update Global
if(isempty(constants.local_bad_sids))
    constants.local_bad_sids=local_bad_sids;
else
    constants.local_bad_sids={constants.local_bad_sids{:};local_bad_sids{:}};
end
if(isempty(constants.local_bad_days))
    constants.local_bad_days=local_bad_days;
else
    constants.local_bad_days={constants.local_bad_days{:};local_bad_days{:}};
end