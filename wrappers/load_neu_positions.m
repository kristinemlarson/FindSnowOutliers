function [] = load_neu_positions(site_ind)
%LOAD_NEU_POSITIONS - Load North, East, Up position data for specified site
%
% Syntax:  [] = load_neu_positions(site_ind)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%
% Global Parameters:
%   constants
%       .use_sopac      boolean to use sopac instead of unavco position
%                       data (v 2.0) default false
%
% Outputs:
%
% Changes to Globals:
%   sites_list(site_ind).neu
%       .year           [Nx1]
%       .doy            [Nx1]
%       .neu            [Nx3] [North East Up] (m) Position data
%       .neusig         [Nx3] [Nsig Esig Usig] (m) Position Sigma Values
%       .source         'SOPAC' or 'PBO' Position source
%
%
% See also: SNR_OUTLIERS_MAIN
%
% Author: Kristine Larson, Kyle Wolma
%   University of Colorado at Boulder
% October 08, 2013; Last revision: October 08, 2013
% Current Version: 2.0
% Backward Compatible Version: 2.0
% Precedent Versions: N/A
% Dependent Versions: plot_neu_positions.m (2.0)

%% Load Globals
global constants sites_list format

%% Check sopac Toggle
if(isfield(constants,'use_sopac'))
    use_sopac=constants.use_sopac;
else
    use_sopac=false;
end

%% Get SID
sid=sites_list(site_ind).sid;

%% Predeclare
year =[];
doy = [];
neu = [];
neusig= [];

%% Load Specified Position data
if(use_sopac) % Load SOPAC
    if(constants.demo_mode)
        filename=['demo/sopac_raw/',sid,'r.neu.txt'];
    else
        filename=['/data/sopac_raw/',sid,'r.neu.txt'];
    end
    %% Load File
    data=load_without_crash(filename);
    
    %% Process File
    if(~isempty(data))
        %% Trim data years
        inds=find(data(:,1)>=min(constants.snr_yrs));
        data=data(inds,:);
        
        %% Store year entry by flooring
        year = floor(data(:,1));
        
        %% Process each entry
        for ind=1:length(data)
            leap=leapyear(year(ind));
            if(leap)
                doys=366;
            else
                doys=365;
            end
            doy_frac = data(ind,1) - floor(data(ind,1));
            % Store doy, neu, neusig
            doy(ind,1) = round(doys*doy_frac +0.5);
            neu(ind,1:3) = data(ind,2:4);
            neusig(ind,1:3) = data(ind,5:7);
        end
    end
    source = 'SOPAC';
else % Load UNAVCO PBO
    if(constants.demo_mode)
        filename=['demo/pbo_raw/',sid, '.pos.csv'];
    else
        filename=['/data/web/',sid, '/eo/pos.csv'];
    end
    %% Load File
    data=load_without_crash(filename);
    %% Process File
    if(~isempty(data))
        %% Trim data years
        inds=find(data(:,1)>=min(constants.snr_yrs));
        data=data(inds,:);
        
        %% Store year entry by flooring
        year = data(:,1);
        [nr,~]=size(data);
        doy=datenum(data(:,1),data(:,2),data(:,3))- datenum(data(:,1),zeros(nr,1),zeros(nr,1));  % convert ymd to doy
        neu = data(:,4:6)/1000;             % mm to m
        neusig = data(:,7:9)/1000;          % mm to m
        
    end
    source = 'PBO';
end

%% Store Data in global
sites_list(site_ind).neu.year=year;
sites_list(site_ind).neu.doy=doy;
sites_list(site_ind).neu.neu=neu;
sites_list(site_ind).neu.neusig=neusig;
sites_list(site_ind).neu.source=source;