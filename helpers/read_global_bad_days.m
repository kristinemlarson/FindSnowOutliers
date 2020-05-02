function []=read_global_bad_days()
%READ_GLOBAL_BADL_DAYS - Reads a list of bad days to not use for individual
% sites
%
% Syntax:   read_global_bad_days()
%
% Changes to Globals:
%   constants
%       .global_bad_days    [year doy year.dec] days listed as bad for all
%                           sites
% 
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% May 30, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants

%% Predeclare
global_bad_days=zeros(0,3);

%% Get Filename
filename=constants.global_bad_days_file;

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
            scan=textscan(line,'%f');               % Text scan into an array of Strings
            scan=scan{1,1};
            if(length(scan)>2)
                % Check if the first entry is already in the list
                % Read each line   [year start_doy end_doy]
                year=scan(1,:);
                start_doy=scan(2,:);
                end_doy=scan(3,:);
                % Check for proper doy ranges
                if(end_doy<1||start_doy<1||end_doy>366||start_doy>366||end_doy<start_doy)  % doy range must be from 1-366 with end>=start
                else                                % Good doy range
                    % Create array of bad days
                    days=(start_doy:1:end_doy)';      % range of days from start to finish
                    bad_days=[year*ones(length(days),1),days];  % [year doy] [Mx2] for each item in days
                    bad_days(:,3)=ydoy2ydec(bad_days);          % [year doy year.dec] [Mx3]
                    % Add to list
                    global_bad_days=sort_by_ydec([global_bad_days;bad_days]);
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
    constants.global_bad_days=[constants.global_bad_days;global_bad_days];
