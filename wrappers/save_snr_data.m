function save_snr_data(site_ind,snr_ind)
%SAVE_SNR_DATA - Saves SNR data for one site
%   Modify this wrapper to change how data are saved for a given site
%
% Syntax:  save_snr_data(site_ind,snr_ind)
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
% June 07, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants sites_list

%% Check Segment Toggle
if(constants.save_data)
    
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
    data_type=sites_list(site_ind).snr{snr_ind}.type;
    data=sites_list(site_ind).snr{snr_ind}.data;
    site=sites_list(site_ind).sid;
    year=data(:,1);
    doy=data(:,2);
    snr=data(:,4);
    
    %% Open File
    filename=[dir,sites_list(site_ind).sid,'_',data_type,'_out.txt'];
    fid=fopen(filename,'w');
    
    %% Write File Header
    fprintf(fid,'%%SNR Snow Outlier Output Data\n');
    fprintf(fid,'%%Station: %s',site);
    fprintf(fid,'%%Year:%d to %d\n',site,constants.snr_yr_min,constants.snr_yr_max);
    hms=clock;
    fprintf(fid,'%%Created:%s %2.0f:%02.0f:%02.0f\n',date,hms(4),hms(5),hms(6));
    fprintf(fid,'%%Created Using:snr_outliers_main %s\n',constants.version);
    fprintf(fid,'%%year doy SNR(%s)\n',data_type);
    
    %% Write File    
    for ind=1:length(data)
        fprintf(fid,'%4.0f %3.0f %5.2f \n',year(ind,1),doy(ind,1),snr(ind,1));
    end
    
    %% Close File
    fclose(fid);
    
    %% Permissions
    check_permissions(filename);
    
    %% Display Success
    format_print(sprintf('       Data Saved to: %s \n',filename),100)           % Display Section Progress (100)
    
end
end % function