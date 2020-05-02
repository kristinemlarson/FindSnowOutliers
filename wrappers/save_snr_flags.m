function save_snr_flags(site_ind,snr_ind)
%SAVE_SNR_FLAGS - Saves SNR data flags for one site
%   Modify this wrapper to change how data are saved for a given site
%
% Syntax:  save_snr_flags(site_ind,snr_ind)
%
% Inputs:
%   site_ind            index of the site in the sites_list
%   snr_ind             index of the snr data to use
%
% Outputs:
%
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN

% Author: Kyle Wolma
%   University of Colorado at Boulder
% August 07, 2013; Last revision: October 03, 2013
% Current Version: 2.0
% Backward Compatible Version: 1.1
% Precedent Versions: main_processor.m (1.1)
% Dependent Versions: plot_neu_positions.m (2.0)

%% Load Globals
global constants sites_list

%% Predeclare
flags=[];

%% Setup Output Directory
if(constants.demo_mode)
    dir='demo/output/';
else
    dir=['/data/web/',sites_list(site_ind).sid,'/extra/snr_outliers/'];
end

if(~exist(dir,'dir'))
    format_print(sprintf('  Directory %s Does not Exist\n',dir));
    system(['mkdir ' dir]);
end

%% Get Data
data=sites_list(site_ind).snr{snr_ind}.data;
data_type=sites_list(site_ind).snr{snr_ind}.type;
bad=sites_list(site_ind).snr{snr_ind}.all_bad;
ydec=data(:,3);
bad_ydec=bad(:,3);
site=sites_list(site_ind).sid;

%% Check Segment Toggle
if(constants.save_data)
    %% Open File
    filename=[dir,sites_list(site_ind).sid,'_',data_type,'_flag.txt'];
    fid=fopen(filename,'w');
    
    %% Write File Header
    fprintf(fid,'%%SNR Snow Outlier Flags\n');
    fprintf(fid,'%%Station: %s\n',site);
    fprintf(fid,'%%Year:%d to %d\n',constants.snr_yr_min,constants.snr_yr_max);
    hms=clock;
    fprintf(fid,'%%Created:%s %2.0f:%02.0f:%02.0f\n',date,hms(4),hms(5),hms(6));
    fprintf(fid,'%%Created Using:snr_outliers_main %s\n',constants.version);
    fprintf(fid,'%%year doy flag (1-good 0-bad -1-unknown)\n');
end

%% Write File
for year=constants.snr_yrs
    if(leapyear(year))
        doys=(1:366)';
    else
        doys=(1:365)';
    end
    % Calculate year.dec for this year
    year_ydec=ydoy2ydec([year*ones(length(doys),1),doys]);
    flag=-1*ones(length(doys),1); % reset flags
    for ind=1:length(doys)          % check each day
        doy=doys(ind);
        if(ismember(year_ydec(ind),ydec))  % check if the current day is in the list of data
            flag(ind)=1;
        elseif(ismember(year_ydec(ind),bad_ydec))  % in bad list
            flag(ind)=0;
        else  % in neither list
            flag(ind)=-1;
        end
        if(flag(ind)~=-1&&constants.save_data)
            fprintf(fid,'%4.0f %3.0f %1d\n',year,doy,flag(ind));
        end
    end
    %% Store flag data
    flags=[flags;year*ones(length(doys),1),doys,year_ydec,flag];
end

%% Save Flag data to sites_list
sites_list(site_ind).snr{snr_ind}.flags=flags;

%% Check Segment Toggle
if(constants.save_data)
    %% Close File
    fclose(fid);
    
    
    %% Permissions
    check_permissions(filename);
    
    %% Display Success
    format_print(sprintf('       Flags Saved to: %s \n',filename),100)           % Display Section Progress (100)
end
end % function