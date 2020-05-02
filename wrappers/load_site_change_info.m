function []=load_site_change_info()
%LOAD_SITE_CHANGE_INFO - Loads information about equipment changes at different sites
%   Modify this wrapper to add antenna and receiver change information to
%   the list of sites that is output by load_sites_list.m
%
% Syntax:  [sites_list]=load_site_change_info(sites_list)
%
% Inputs:
%   sites_list(i)       A structure array containing each site
%       .sid                    Site ID
%
% Outputs:
%
% Changes to Globals:
%   sites_list(i)       The same structure as the input with antenna and
%                               receiver change information added
%       .sid                    Site ID
%       .antenna_changes        [mx3] [year doy ydec] array with year doy
%                               corresponding to each antenna change []
%                               for none
%       .receiver_changes       [nx3] [year doy ydec] array with year doy
%                               corresponding to each receiver change []
%                               for none
%       .firmware_changes       [px3] [year doy ydec] array with year doy
%                               corresponding to each firmware change []
%                               for none
%       .equipment_changes      [qx3] [year doy ydec] array with year doy
%                               corresponding to each antenna and receiver
%                               for none
%       .offset_dates           [px3] [year doy ydec] array with year doy
%                               corresponding to each firmware offset []
%                               for none
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN LOAD_SITES_LIST

% Author: Kyle Wolma
%   University of Colorado at Boulder
% March 20, 2013; Last revision: Aug 7, 2013
% Current Version: 1.1
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants sites_list

%% Predeclare
antenna=zeros(0,3);
receiver=zeros(0,3);
firmware=zeros(0,3);
equipment=zeros(0,3);
first_pass=true;                        % Load info database only once


%% Process Each Site in the Sites ID List
num_sites=length(sites_list);                                               % number of sites in the list

for ind=1:num_sites
    %% Site ID
    current_id=sites_list(ind).sid;                                         % Site ID
    
    %% Load Data
    if(constants.demo_mode)
        % Use Read Function
        [antenna,receiver,firmware]=read_demo_site_change_info(current_id); % returns [y doy] for each change at the site
        
    else % Not DEMO
        %% Load Site Information Database
        if(first_pass)
            storage=load_masterlist;                                        % loads database of site information only once
            first_pass=false;
        end
        %% Load Site Information
        current_site=getsiteinfo_fast(current_id,storage);                  % Load information on this site
        
        %% Load Antenna/Receiver/firmware Change Information
        [antenna,receiver,firmware]=rec_changes_ydoy(current_site);         % returns [y doy] for each change at the site for antenna, receiver, firmware
        
    end % Done With DEMO Check
    
    %% Sort Antenna Changes
    if(isempty(antenna))
        antenna=zeros(0,3);                                                 % Maintain proper size for concatenation
    else
        antenna(:,3)=ydoy2ydec(antenna);                                    % add ydec
        [~,inds,~]=unique(antenna(:,3),'rows');                             % Remove duplicates                
        antenna=antenna(inds,:);                                            % This also sorts the array by year.dec    
        inds=antenna(:,3)<constants.snr_yr_min|antenna(:,3)>(constants.snr_yr_max+1);  % Remove changes outside yr range
        antenna=antenna(~inds,:);
    end
    
    %% Sort Receiver Changes
    if(isempty(receiver))
        receiver=zeros(0,3);                                                % Maintain proper size for concatenation
    else
        receiver(:,3)=ydoy2ydec(receiver);                                  % add ydec
        [~,inds,~]=unique(receiver(:,3),'rows');                            % Remove duplicates
        receiver=receiver(inds,:);                                          % This also sorts the array by year.dec
        inds=receiver(:,3)<constants.snr_yr_min|receiver(:,3)>(constants.snr_yr_max+1);  % Remove changes outside yr range
        receiver=receiver(~inds,:);
    end
    
    %% Sort Firmware Changes
    if(isempty(firmware))
        firmware=zeros(0,3);                                                % Maintain proper size for concatenation
    else
        firmware(:,3)=ydoy2ydec(firmware);                                  % add ydec
        [~,inds,~]=unique(firmware(:,3),'rows');                            % Remove duplicates
        firmware=firmware(inds,:);                                          % This also sorts the array by year.dec
        inds=firmware(:,3)<constants.snr_yr_min|firmware(:,3)>(constants.snr_yr_max+1);  % Remove changes outside yr range
        firmware=firmware(~inds,:);
    end
    
    %% Update Overall Equipment Changes
    equipment=[antenna;receiver];
    if(isempty(equipment))
        equipment=zeros(0,3);                                               % Maintain proper size for concatenation
    else
        equipment(:,3)=ydoy2ydec(equipment);                                % add ydec
        [~,inds,~]=unique(equipment(:,3),'rows');                           % Remove duplicates (antenna/receiver on same day)
        equipment=equipment(inds,:);                                        % This also sorts the array by year.dec
    end
    
    %% Add All Required Information to the Structure Array
    sites_list(ind).antenna_changes=antenna;                                % add antenna changes [y doy ydec]
    sites_list(ind).receiver_changes=receiver;                              % add receiver changes [y doy ydec]
    sites_list(ind).firmware_changes=firmware;                              % add firmware changes [y doy ydec]
    sites_list(ind).equipment_changes=equipment;                            % add equipment changes [y doy ydec]
    sites_list(ind).offset_dates=firmware;                                  % add offsets [y doy ydec]
end

