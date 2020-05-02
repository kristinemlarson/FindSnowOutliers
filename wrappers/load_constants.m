function [constants]=load_constants(input)
%LOAD_CONSTANTS -  Loads a structure containing constants
%   Modify this wrapper to change the values of the desired constants
%
% Syntax:   [constants]=load_constants()
%           [constants]=load_constants(input)
%
% Input:
%   input(optional) structure containing default constant values to use
%
% Output:
%   constants       structure containing all constants
%       .version                current version number
%       .demo_mode              logical toggle for if this is a demo or not
%   === file names ===
%       .bad_sites_file         filename of bad sites list
%       .global_bad_days_file   filename of list of global bad days
%       .local_bad_days_file    filename of list of local bad days
%       .site_change_info_file  filename of site change information file
%       .sites_list_file        filename of sites list
%       .offset_file            filename of list of extra offset information
%   === Toggles ===
%       .remove_bad             logical to perform segment
%       .remove_mask            logical to perform segment
%       .remove_offsets         logical to perform segment
%       .remove_cut1            logical to perform segment
%       .remove_cut2            logical to perform segment
%       .remove_cut3            logical to perform segment
%       .save_data              logical to save SNR data
%       .make_plots             logical to make plots
%       .save_plots             logical to save plots
%       .close_all              logical to close all station plots after saving (Version 1.1)
%       .use_sopac              logical to use SOPAC for NEU position data (Version 2.0)
%   === Preferences ===
%       .sid_length             number of characters in an id
%       .case_sensitive         logical if the site ids are case sensitive
%       .equal_yrs              logical true if leap years are ignored for year length
%       .yr_length              length of an average year if all yrs are equal
%   === SNR Data Properties ===
%       .snr_types              number of snr data types being used
%       .snr_yr_min             earliest year for snr data
%       .snr_yr_max             latest day for snr data
%       .snr_yrs                range of years that are to be included
%   === Predelcared Lists ===
%       .bad_sites              list of sites not to load
%       .global_bad_days        list of bad days
%       .local_bad_days         cell of arrays of bad days
%       .local_bad_sids         cell string of ids
%   === Tolerances ===
%       .bad_snr_min            minimum snr allowed by SNR mask
%       .bad_snr_max            maximum snr allowed by SNR mask
%       .offset_range           [year.dec] number of days to use for an offset mean
%       .offset_min_pts         minimum number of points required to take a mean
%       .cut1_outliers          [low;high] logicals to remove low/high outliers
%       .cut3_outliers          [low;high] logicals to remove low/high outliers
%       .cut1_sigma             number of standard deviations to allow
%       .cut3_sigma             number of standard deviations to allow
%       .summer_range           [start_doy end_doy] range of days for summer
%       .summer_min_pts         minimum number of points for the summer
%       .summer_min_index       index of sorted summer list to use as min
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN

% Author: Kyle Wolma
%   University of Colorado at Boulder
% February 27, 2013; Last revision: October 10, 2013
% Current Version: 2.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: main_plotter.m (1.1)


%% Handle Input
if(nargin<1||~isstruct(input))
    defaults=true;                              % use defaults for all constants values
else
    defaults=false;                             % use the input constant values wherever possible
end

%% Version=================================================================
%%=========================================================================
constants.version='Version: 1.1';               % Only Default value

%% DEMO Mode===============================================================
%%=========================================================================
if(defaults||...                                % Use Default
        ~isfield(input,'demo_mode')||...        % No input specified
        ~islogical(input.demo_mode))            % Wrong input format
    
    constants.demo_mode=false;                  % Default value
else
    constants.demo_mode=input.demo_mode;        % Use input value
end


%% Filenames
%%=========================================================================
%% Bad Sites List
if(defaults||...                                % Use Default
        ~isfield(input,'bad_sites_file')||...       % No input specified
        ~ischar(input.bad_sites_file))           % Wrong input format
    if(constants.demo_mode)
        constants.bad_sites_file='demo/bad_sites_list';  % Default filename
    else
        constants.bad_sites_file='/gipsy/files/snr_outliers/bad_sites_list';  % Default filename
    end
else
    constants.bad_sites_file=input.bad_sites_file;      % Use input value
end

%% Global Bad Days
if(defaults||...                                % Use Default
        ~isfield(input,'global_bad_days_file')||...       % No input specified
        ~ischar(input.global_bad_days_file))           % Wrong input format
    
    if(constants.demo_mode)
        constants.global_bad_days_file='demo/global_bad_days';  % Default filename
    else
        constants.global_bad_days_file='/gipsy/files/snr_outliers/global_bad_days';  % Default filename
    end
    
else
    constants.global_bad_days_file=input.global_bad_days_file;      % Use input value
end

%% Local Bad Days
if(defaults||...                                % Use Default
        ~isfield(input,'local_bad_days_file')||...       % No input specified
        ~ischar(input.local_bad_days_file))           % Wrong input format
    
    if(constants.demo_mode)
        constants.local_bad_days_file='demo/local_bad_days';  % Default filename
    else
        constants.local_bad_days_file='/gipsy/files/snr_outliers/local_bad_days';  % Default filename
    end
else
    constants.local_bad_days_file=input.local_bad_days_file;      % Use input value
end

%% Site Change Information
if(defaults||...                                % Use Default
        ~isfield(input,'site_change_info_file')||...       % No input specified
        ~ischar(input.site_change_info_file))           % Wrong input format
    
    constants.site_change_info_file='demo/site_change_info';  % Default filename
else
    constants.site_change_info_file=input.site_change_info_file;      % Use input value
end

%% Sites List
if(defaults||...                                % Use Default
        ~isfield(input,'sites_list_file')||...       % No input specified
        ~ischar(input.sites_list_file))           % Wrong input format
    if(constants.demo_mode)
        constants.sites_list_file='demo/sites_list';  % Default filename
    else
        constants.sites_list_file='/gipsy/files/masterlist';         % Default filename for non demo mode
    end
else
    constants.sites_list_file=input.sites_list_file;      % Use input value
end

%% Offsets List
if(defaults||...                                % Use Default
        ~isfield(input,'offsets_file')||...       % No input specified
        ~ischar(input.offsets_file))           % Wrong input format
    
    if(constants.demo_mode)
        constants.offsets_file='demo/offsets';  % Default filename
    else
        constants.offsets_file='/gipsy/files/snr_outliers/offsets';  % Default filename
    end
else
    constants.offsets_file=input.offsets_file;      % Use input value
end

%% Segment Toggles=========================================================
%%=========================================================================
%% Toggle Remove Bad SNR Days
if(defaults||...                                % Use Default
        ~isfield(input,'remove_bad')||...       % No input specified
        ~islogical(input.remove_bad))           % Wrong input format
    
    constants.remove_bad=true;                  % Default value
else
    constants.remove_bad=input.remove_bad;      % Use input value
end

%% Toggle Remove SNR Mask
if(defaults||...                                % Use Default
        ~isfield(input,'remove_mask')||...      % No input specified
        ~islogical(input.remove_mask))          % Wrong input format
    
    constants.remove_mask=true;                 % Default value
else
    constants.remove_mask=input.remove_mask;    % Use input value
end

%% Toggle Remove Offsets
if(defaults||...                                % Use Default
        ~isfield(input,'remove_offsets')||...   % No input specified
        ~islogical(input.remove_offsets))       % Wrong input format
    
    constants.remove_offsets=true;              % Default value
else
    constants.remove_offsets=input.remove_offsets;   % Use input value
end

%% Toggle Remove First Cut
if(defaults||...                                % Use Default
        ~isfield(input,'remove_cut1')||...      % No input specified
        ~islogical(input.remove_cut1))          % Wrong input format
    
    constants.remove_cut1=true;                 % Default value
else
    constants.remove_cut1=input.remove_cut1;    % Use input value
end

%% Toggle Remove Second Cut
if(defaults||...                                % Use Default
        ~isfield(input,'remove_cut2')||...      % No input specified
        ~islogical(input.remove_cut2))          % Wrong input format
    
    constants.remove_cut2=true;                 % Default value
else
    constants.remove_cut2=input.remove_cut2;    % Use input value
end

%% Toggle Remove Third Cut
if(defaults||...                                % Use Default
        ~isfield(input,'remove_cut3')||...      % No input specified
        ~islogical(input.remove_cut3))          % Wrong input format
    
    constants.remove_cut3=true;                 % Default value
else
    constants.remove_cut3=input.remove_cut3;    % Use input value
end

%% Toggle Save Data
if(defaults||...                                % Use Default
        ~isfield(input,'save_data')||...        % No input specified
        ~islogical(input.save_data))            % Wrong input format
        
    if(constants.demo_mode)
        constants.save_data=false;                   % Default value
    else
        constants.save_data=true;                   % Default value
    end
else
    constants.save_data=input.save_data;        % Use input value
end

%% Toggle Make Plots
if(defaults||...                                % Use Default
        ~isfield(input,'make_plots')||...       % No input specified
        ~islogical(input.make_plots))           % Wrong input format
    
    constants.make_plots=true;                  % Default value
else
    constants.make_plots=input.make_plots;      % Use input value
end

%% Toggle Save Plots
if(defaults||...                                % Use Default
        ~isfield(input,'save_plots')||...       % No input specified
        ~islogical(input.save_plots))           % Wrong input format
    
        if(constants.demo_mode)
        constants.save_plots=false;             % Default value
    else
        constants.save_plots=true;              % Default value
    end
else
    constants.save_plots=input.save_plots;      % Use input value
end

%% Toggle Close Plots (Version 1.1)
if(defaults||...                                % Use Default
        ~isfield(input,'close_plots')||...      % No input specified
        ~islogical(input.close_plots))          % Wrong input format
    
    constants.close_plots=true;                 % Default value
else
    constants.close_plots=input.close_plots;    % Use input value
end

%% Toggle Use Sopac (Version 2.0)
if(defaults||...                                % Use Default
        ~isfield(input,'use_sopac')||...        % No input specified
        ~islogical(input.use_sopac))            % Wrong input format
    
    constants.use_sopac=false;                  % Default value
else
    constants.use_sopac=input.use_sopac;        % Use input value
end

%% Preferences=============================================================
%%=========================================================================
%% Site ID Character Length
% Length of a site id Eg. 'p041' is 4 chars long
if(defaults||...                                % Use Default
        ~isfield(input,'sid_length')||...       % No input specified
        ~isnumeric(input.sid_length))           % Wrong input format
    
    constants.sid_length=4;                     % Default value
else
    constants.sid_legnth=input.sid_length;      % Use input value
end

%% Site ID Case Sensitivity
% Set to true if site names are case sensitive ie 'P041' and 'p041' are different
if(defaults||...                                % Use Default
        ~isfield(input,'case_sensitive')||...   % No input specified
        ~islogical(input.case_sensitive))       % Wrong input format
    
    constants.case_sensitive=false;             % Default value
else
    constants.case_sensitive=input.case_sensitive;  % Use input value
end

%% Year Doy to Year.Dec Preference
% true if year.dec=year+doy/365.25 otherwise year.dec=year+doy/#days(365 or 366)
if(defaults||...                                % Use Default
        ~isfield(input,'equal_yrs')||...        % No input specified
        ~islogical(input.equal_yrs))            % Wrong input format
    
    constants.equal_yrs=true;                   % Default value
else
    constants.equal_yrs=input.equal_yrs;        % Use input value
end

%% Year Length
% [days]    Length of a year in days
if(defaults||...                                % Use Default
        ~isfield(input,'yr_length')||...        % No input specified
        ~isnumeric(input.yr_length))            % Wrong input format
    
    constants.yr_length=365.25;                 % Default value
else
    constants.yr_length=input.yr_length;        % Use input value
end


%% SNR Data Properties=====================================================
%%=========================================================================
%% SNR Data Types
% The number of data types
if(defaults||...                                % Use Default
        ~isfield(input,'snr_types')||...        % No input specified
        ~isnumeric(input.snr_types))            % Wrong input format
    
    constants.snr_types=2;                      % Default value
else
    constants.snr_types=input.snr_types;        % Use input value
end
update_colors(constants.snr_types);            % This is required to ensure the right amount of color entries for the data types

%% SNR Data Range Year Limits==============================================
%%=========================================================================
%% Starting Year year
% The earliest year that snr data are available(or desired)
if(defaults||...                                % Use Default
        ~isfield(input,'snr_yr_min')||...       % No input specified
        ~isnumeric(input.snr_yr_min))           % Wrong input format
    
    constants.snr_yr_min=2007;                  % Default value
else
    constants.snr_yr_min=input.snr_yr_min;      % Use input value
end

%% Ending Year
% The latest year that snr data are available(or desired)
if(defaults||...                                % Use Default
        ~isfield(input,'snr_yr_max')||...       % No input specified
        ~isnumeric(input.snr_yr_max))           % Wrong input format
    
%    constants.snr_yr_max=2013;                  % Default value
    constants.snr_yr_max=final_year;                  % Default value
else
    constants.snr_yr_max=input.snr_yr_max;      % Use input value
end

%% Year Range
% Each year to get SNR Data for.  Input does not have to be sequential
% years eg [2007,2008,2010] if 2009 is not desired
if(defaults||...                                % Use Default
        ~isfield(input,'snr_yrs')||...          % No input specified
        ~isnumeric(input.snr_yrs))              % Wrong input format
    
    constants.snr_yrs=constants.snr_yr_min:constants.snr_yr_max;   % Default value is range from min to max
else
    constants.snr_yrs=input.snr_yrs;            % Use input value
end



%% Predeclared Lists=======================================================
%%=========================================================================
%% Bad Sites
% {sid} Cell String containing a list of sites not to process load_bad_sites_list
if(defaults||...                                % Use Default
        ~isfield(input,'bad_sites')||...        % No input specified
        ~iscellstr(input.bad_sites))            % Wrong input format
    
    constants.bad_sites={};                     % Default Value
else
    constants.bad_sites=input.bad_sites;        % Use input value
end

%% Bad Global Days
% [year doy year.dec]  Placeholder for load_bad_snr_days list
if(defaults||...                                % Use Default
        ~isfield(input,'global_bad_days')||...  % No input specified
        ~iscellstr(input.global_bad_days))      % Wrong input format
    
    constants.global_bad_days=zeros(0,3);       % Default Value
else
    constants.global_bad_days=input.global_bad_days;    % Use input value
end

%% Bad Local Days
% [year doy year.dec]  Placeholder for load_bad_snr_days list
if(defaults||...                                % Use Default
        ~isfield(input,'local_bad_days')||...   % No input specified
        ~iscellstr(input.local_bad_days))       % Wrong input format
    
    constants.local_bad_days={};                % Default Value
else
    constants.local_bad_days=input.local_bad_days;  % Use input value
end

%% Bad Local Sids
% {sid} Cell String containing a list of site ids corresponding to each day listed as a bad local day
if(defaults||...                                % Use Default
        ~isfield(input,'local_bad_sids')||...   % No input specified
        ~iscellstr(input.local_bad_sids))       % Wrong input format
    
    constants.local_bad_sids={};                % Default Value
else
    constants.local_bad_sids=input.local_bad_sids;  % Use input value
end


%% Tolerances==============================================================
%%=========================================================================
%% SNR Mask Data Range
% [dbHz] Minimum SNR value to qualify as a useful value
if(defaults||...                                % Use Default
        ~isfield(input,'bad_snr_min')||...   % No input specified
        ~isnumeric(input.bad_snr_min))       % Wrong input format
    
    constants.bad_snr_min=40;                % Default Value
else
    constants.bad_snr_min=input.bad_snr_min;  % Use input value
end

% Maximum
% [dbHz] Maximum SNR value to qualify as a useful value
if(defaults||...                                % Use Default
        ~isfield(input,'bad_snr_max')||...   % No input specified
        ~isnumeric(input.bad_snr_max))       % Wrong input format
    
    constants.bad_snr_max=50;                % Default Value
else
    constants.bad_snr_max=input.bad_snr_max;  % Use input value
end

% Percent Maxmimum Removal
if(defaults||...                                % Use Default
        ~isfield(input,'snr_mask_pct')||...     % No input specified
        ~isnumeric(input.snr_mask_pct))         % Wrong input format
    
    constants.snr_mask_pct=5;                   % Default Value
else
    constants.snr_mask_pct=input.snr_mask_pct;  % Use input value
end

%% Offset Removal Bin Number of Days
% # days offset from the firmware point.  /366 to account for possible leap years
% Default is 10 days.  use 10.5/366 to include anything within 10 days
if(defaults||...                                % Use Default
        ~isfield(input,'offset_range')||...     % No input specified
        ~isnumeric(input.offset_range))         % Wrong input format
    
    constants.offset_range=10.5/366;             % Default Value
else
    constants.offset_range=input.offset_range;  % Use input value
end

%% Offset Removal Minimum Number of Points
% Minimum number of points to use for a succesful firmware offset calculation
if(defaults||...                                % Use Default
        ~isfield(input,'offset_min_pts')||...   % No input specified
        ~isnumeric(input.offset_min_pts))       % Wrong input format
    
    constants.offset_min_pts=3;                 % Default Value
else
    constants.offset_min_pts=input.offset_min_pts;  % Use input value
end

%% Outliers to Remove
% Create [2x1] Matrix for [low;high] outlier removal for mean+-tolerance*sigma.
% low are outliers less than mean-tol*sigma
% high are outliers greater than mean+tol*sigma
% First cut
if(defaults||...                                % Use Default
        ~isfield(input,'cut1_outliers')||...    % No input specified
        ~max(islogical(input.cut1_outliers)))   % Wrong input format
    
    constants.cut1_outliers=[true;false];       % Default Value  Only remove low outliers for first cut
else
    constants.cut1_outliers=input.cut1_outliers;% Use input value
end

% Third Cut
if(defaults||...                                % Use Default
        ~isfield(input,'cut3_outliers')||...    % No input specified
        ~max(islogical(input.cut3_outliers)))   % Wrong input format
    
    constants.cut3_outliers=[true;true];        % Default Value Only remove low outliers for third cut
else
    constants.cut3_outliers=input.cut3_outliers;% Use input value
end

%% First Cut Outlier Tolerance
% Remove data points outside this sigma value
if(defaults||...                                % Use Default
        ~isfield(input,'cut1_sigma')||...   % No input specified
        ~isnumeric(input.cut1_sigma))       % Wrong input format
    
    constants.cut1_sigma=3;                 % Default Value
else
    constants.cut1_sigma=input.cut1_sigma;  % Use input value
end

%% Third Cut Outlier Tolerance
% Remove data points outside this sigma value
if(defaults||...                                % Use Default
        ~isfield(input,'cut3_sigma')||...   % No input specified
        ~isnumeric(input.cut3_sigma))       % Wrong input format
    
    constants.cut3_sigma=3;                 % Default Value
else
    constants.cut3_sigma=input.cut3_sigma;  % Use input value
end

%% Second Cut Tolerances
% Summer Doy Range
% [doy;doy] for the range of days to use for "summer" 180 approx june 29 ->240 approx Aug 28
if(defaults||...                                % Use Default
        ~isfield(input,'summer_range')||...   % No input specified
        ~isnumeric(input.summer_range))       % Wrong input format
    
    constants.summer_range=[180;240];                 % Default Value
else
    constants.summer_range=input.summer_range;  % Use input value
end

% Summer Minimum Number of Points
% Minimum number of points to define a single "summer"
if(defaults||...                                % Use Default
        ~isfield(input,'summer_min_pts')||...   % No input specified
        ~isnumeric(input.summer_min_pts))       % Wrong input format
    
    constants.summer_min_pts=1;                 % Default Value
% try this KL 13dec03
%    constants.summer_min_pts=2;                 % Default Value
else
    constants.summer_min_pts=input.summer_min_pts;  % Use input value
end

% Summer Minimum Index Number   Index of sorted SNR data values to use as
% min value.  For absolute summer minimum this should be 1.
% must be <=summer_min_pts and >0
if(defaults||...                                % Use Default
        ~isfield(input,'summer_min_index')||...   % No input specified
        ~isnumeric(input.summer_min_index))       % Wrong input format
    
%    constants.summer_min_index=2;                 % Default Value
% KL change 13dec03
    constants.summer_min_index=1;                 % Default Value
else
    constants.summer_min_index=input.summer_min_index;  % Use input value
end



