function []=load_bad_sites_list()
%LOAD_BAD_SITES_LIST - Loads a list of sites not to use
%   Modify this wrapper to allow a list of bad sites to be put into the
%   system
%
% Syntax:  load_bad_sites_list()
%
%
% Global Parameters:
%       constants
%           .bad_sites_file filename of a list of bad sites
%
%
% Changes to Globals:
%       constants
%           .bad_sites      list of sites that are considered bad and
%                           should not be loaded from the sites list.
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN LOAD_SITES_LIST

% Author: Kyle Wolma
%   University of Colorado at Boulder
% April 05, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants

%% Predeclare List
bad_sites={};                                                               % Cell String of bad sites

%% Load List of Bad Site Names
bad_sites=read_sites_list(constants.bad_sites_file);                    % returns an {Nx1} Cell String.  Each row is a site id

%% Add to Constants
constants.bad_sites=bad_sites;

