function [sites_list]=load_sites_list(list_in)
%LOAD_SITES_LIST - Loads a list of sites to use not including bad sites
%   Modify this wrapper to allow a list of sites to be put into the system
%
% Syntax:   [sites_list]=load_sites_list()
%           [sites_list]=load_sites_list(list_in)
%
% Inputs:
%   list_in         {Nx1}(Optional) Cell String Exclusive list of sites to
%                                   be used.  An input list will not load
%                                   from the default site list file and
%                                   will also include sites even if they
%                                   are listed as bad sites.
%
% Outputs:
%   sites_list(i)   - A structure array containing each site
%       .sid                    - Site ID
%       .antenna_changes        []  place holder for load_site_change_info
%       .receiver_changes       []  place holder for load_site_change_info
%       .firmware_changes       []  place holder for load_site_change_info
%       .equipment_changes      []  place holder for load_site_change_info
%       .offset_dates           []  place holder for load_site_change_info
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN LOAD_BAD_SITES_LIST

% Author: Kyle Wolma
%   University of Colorado at Boulder
% February 20, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants


%% Handle Inputs
if(nargin<1||~iscellstr(list_in))
    list_in={};
end


%% Load List of Site Names
% Read List if the input list is empty
if(isempty(list_in))
    format_print(sprintf('  Reading List: %s \n',constants.sites_list_file),1);     % Display Section (1)
    site_ids=read_sites_list(constants.sites_list_file);        % returns an {Nx1} Cell String.  Each row is a site id    
else
    format_print('  Using Input List\n',1);                                   % Display Section (1)
    site_ids=list_in;
end


%% Predeclare structure array fields
[num_sites,~]=size(site_ids);                       % number of sites in the list
init_size=num_sites-length(constants.bad_sites);    % Initial Size guess number of sites less the number of bad sites
                                                    % This is a conservative estimate and will be <= the total number of sites
if(init_size<1)
    init_size=1;                                    % Set to 1 in case a small list is passed with a large bad sites list
end
% Predeclare
sites_list(init_size).sid='';
sites_list(init_size).antenna_changes=[];
sites_list(init_size).receiver_changes=[];
sites_list(init_size).firmware_changes=[];
sites_list(init_size).equipment_changes=[];
sites_list(init_size).offset_dates=[];
offset=0;                                           % Number of rows to offset the index by when adding to the new array

%% Process Each Site in the Sites ID List
for ind=1:num_sites
    %% Check if this is a Bad Site
    current_id=site_ids{ind,1};
    if(constants.case_sensitive)
        inds=strcmp(current_id,constants.bad_sites);
    else
        inds=strcmpi(current_id,constants.bad_sites);
    end
    
    %% Add Site ID to the Structure Array
    % Add if there are no bad sites isempty(inds), if it is not in the Bad
    % list (~max(inds), or if it is an input override (~isempty(list_in)
    if(isempty(inds)||~max(inds)||~isempty(list_in))
        sites_list(ind-offset).sid=current_id;                              % add sid to the structure array 'char'
    else
        offset=offset+1;                % Increment offset
    end
    
end     % Done with list of all sites

%% Remove any Blank Sites
    if(constants.case_sensitive)
        inds=strcmp('',{sites_list.sid});                   % Cast sites_list.sid as a Cell String 
    else
        inds=strcmpi('',{sites_list.sid});
    end
    sites_list=sites_list(~inds);

end % function