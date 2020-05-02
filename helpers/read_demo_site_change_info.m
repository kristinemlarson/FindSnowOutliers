function [antenna,receiver,firmware]=read_demo_site_change_info(site_id)
%READ_DEMO_SITE_CHANGE_INFO - Reads site change information from a 
% specified file and returns it for a desired site
%
%   Modify this wrapper to add antenna and receiver change information to
%   the list of sites
%
% Syntax:  [antenna,receiver,firmware]=read_demo_site_change_info(site_id)
%
% Inputs:
%   site_id         String site ID for a single site
%
% Outputs:
%   antenna         [Nx2]   [year doy]  N>=0    changes in site antenna
%   receiver        [Mx2]   [year doy]  M>=0    changes in site receiver
%   firmware        [Px2]   [year doy]  P>=0    changes in site firmware
%
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN LOAD_SITES_LIST

% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% May 16, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants

%% Predeclare
antenna=zeros(0,2);
receiver=zeros(0,2);
firmware=zeros(0,2);

%% Handle Inputs
if(nargin<1)
    format_print('No Input site for Site Change Info',1000)                 % Display All (1000)
    return
end

%% Get Filename
filename=constants.site_change_info_file;

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
            % Check if the first entry is the site id
            if(constants.case_sensitive)
                site_match=strcmp(site_id,scan{1,1});
            else
                site_match=strcmpi(site_id,scan{1,1});
            end
            if(site_match&&length(scan)>3)
                type=upper(scan{2,1});
                year=str2double(scan{3,1});
                doy=str2double(scan{4,1});
                switch(type)
                    case 'A'            % Antenna
                        antenna=[antenna;year doy];
                    case 'R'            % Receiver
                        receiver=[receiver;year doy];
                    case 'F'            % Firmware
                        firmware=[firmware;year doy];
                    otherwise
                        % Do nothing
                end
            end
        end
        
        
    end % end while loop
    
    %% Close File
    fclose(fid);
        
else % file does not exist
    format_print(sprintf(' Input Site Change file:\n %s \n does not exist\n',filename),0,true)
end