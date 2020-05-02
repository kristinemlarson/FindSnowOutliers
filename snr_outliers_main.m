function []=snr_outliers_main(varargin)
%SNR_OUTLIERS_MAIN - This function is the main function for the snr outlier
% removal code suite.
%
%
% Syntax:   []=snr_outliers_main()
%           []=snr_outliers_main('Mode','Demo',...)
%           []=snr_outliers_main('Sites',list,...)
%           []=snr_outliers_main('Format',format,...)
%           []=snr_outliers_main('Constants','constants,...)
%
% Inputs:
%       Input Pairs
%       'Mode' , 'Demo'         Enters Demonstration Mode
%       'Sites', list           list={'site';'site'} Cell String of sites
%       'Format', format        format structure to be input when loading
%                               format defaults
%       'Constants',constants   constants structure to be input when
%                               loading constants defaults
%
% Outputs:
%
% Globals:
%       sites_list
%       format
%       constants
%
% See also:

% Author: Kristine Larson
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% February 20 2013; Last revision: October 08, 2013
% Current Version: 2.0


%% Handle Inputs
% Predeclare Inputs
format_in=[];                                               % Predeclare format input
constants_in=[];                                            % Predeclare constants input
list_in={};                                                 % Predeclare input sites list
% Check Inputs
if(nargin>0)                    % At least 1 input
    num_ins=length(varargin);                               % Number of Inputs
    
    if(num_ins<2)               % Check to ensure there are at least 2 inputs if there is one
        fprintf(1,'Not Enough Inputs\n');                                   % Display Error (0)
        fprintf(1,'Now Exiting\n');                                         % Display Error (0)
        return;
    else                        % There are enough inputs
        % Loop through inputs
        ind=1;                                              % Input index number
        
        while(ind<num_ins)                  % Ensure there is at least 1 entry following the current one
            
            if(ischar(varargin{ind}))       % First input must be a character string
                
                % Compare String to expected inputs
                input=upper(varargin{ind});                 % Input string
                switch input
                    case 'MODE' %% MODE
                        %% Set Mode
                        if(ischar(varargin{ind+1}))
                            if(strcmpi(varargin{ind+1},'Demo'))
                                fprintf(1,'Setting Demo Mode\n\n');         % Display Mode Selection (1)
                                % SET DEMO MODE
                                constants_in.demo_mode=true;
                            else
                                fprintf(1,'Input:( %s ) is not a Mode Type\n',varargin{ind+1});       % Display Error (0)
                            end
                        else
                            fprintf(1,'Input #%d is not a String.\n',ind+1);% Display Error (0)
                        end
                        
                    case 'FORMAT' %% FORMAT
                        %% Check Input Format
                        if(isstruct(varargin{ind+1}))
                            fprintf(1,'Using Input Format\n');              % Display Format Usage
                            format_in=varargin{ind+1};
                        else
                            fprintf(1,'Input Format is not a struct\n');    % Display Error (0)
                        end
                        
                    case 'CONSTANTS' %% CONSTANTS
                        %% Check Input Constants
                        if(isstruct(varargin{ind+1}))
                            fprintf(1,'Using Input Constants\n');           % Display Constants Usage
                            constants_in=varargin{ind+1};
                        else
                            fprintf(1,'Input Constants is not a struct\n'); % Display Error (0)
                        end
                        
                    case 'SITES'  %% Sites List
                        %% Pass in input Site List
                        if(iscellstr(varargin{ind+1}))
                            fprintf(1,'Using Input List\n');                % Display Format Usage
                            list_in=varargin{ind+1};
                        else
                            fprintf(1,'Input List is not a Cell String\n'); % Display Error (0)
                        end
                        
                    otherwise %% UNRECOGNIZED INPUT
                        %% Unrecognized
                        fprintf(1,'Input:( %s ) Unrecognized\n',varargin{ind}); % Display Error (0)
                        
                end     % End switch statement for the input
                
            else                        % Input is not a String
                fprintf(1,'Input #%d is not a String.\n',ind);              % Display Error (0)
                
            end                         % Done Checking Index
            
            ind=ind+2;                                      % Increment index
        end             % End while loop for all indices
    end
end                     % No Inputs Specified


%% Setup Path
mainscript=mfilename('fullpath');                           % Get full filename of this function
[maindir,~,~]=fileparts(mainscript);                        % Get the folder of this function
pathscript=sprintf('%s/wrappers/modify_path.m',maindir);    % Add
run(pathscript);                                            % Run wrapper function modify_path.m
clear pathscript mainscript maindir
clc


%% Load Format Defaults
global format                                               % Make format global
if(~isempty(format_in))
    [format]=load_format(format_in);                        % Run wrapper function with inputs
else
    [format]=load_format();                                 % Run wrapper function
end

format_print('Loading Format:\n',1);                                        % Display Section (1)
format_print(' -Done\n\n',1)                                                % Display Section (1)


%% Load Constants
format_print('Loading Constants:\n',1);                                     % Display Section (1)

global constants                                            % Make constants global
if(~isempty(constants_in))
    [constants]=load_constants(constants_in);               % Run wrapper function with inputs
else
    [constants]=load_constants();                           % Run wrapper function
end

format_print(' -Done\n\n',1);                                               % Display Section (1)


%% Load Bad Days Lists
format_print('Loading Bad Days List:\n',1);                                 % Display Section (1)

try
    read_global_bad_days();                                 % Run wrapper function
    read_local_bad_days();                                  % Run wrapper function
catch err
    format_print('  Badness Loading Bad Days Lists!!\n\n',0);                  % Display Errors (0)
    format_print(getReport(err),0,true);                                    % Display Error Message (0)
    format_print('\n',0);
end

format_print(' -Done\n\n',1);                                               % Display Section (1)


%% Load List of Bad Sites
format_print('Loading List of Bad Sites:\n',1);                             % Display Section (1)

try
    load_bad_sites_list();                                  % Run wrapper function
catch err
    format_print('  Badness Occurred Loading Bad Sites List!!\n\n',0);        % Display Errors (0)
    format_print(getReport(err),0,true);                                    % Display Error Message (0)
    format_print('\n',0);
end

format_print(' -Done\n\n',1);                                               % Display Section (1)


%% Load List of Sites
format_print('Loading List of Sites:\n',1);                                 % Display Section (1)

global sites_list                                           % Make sites_list global
try
    if(~isempty(list_in))
        [sites_list]=load_sites_list(list_in);              % Run wrapper function with input list
    else
        [sites_list]=load_sites_list();                     % Run wrapper function
    end
    
    % Make Sure there is at least 1 site in the list
    if(isempty(sites_list))
        format_print('  Site List is Empty\n',0);                           % Display Errors (0)
        format_print('\n  Now Returning\n\n',0);                            % Display Errors (0)
        return
    end
catch err
    format_print('  Badness Occurred Loading Sites List!!\n\n',0);            % Display Errors (0)
    format_print(getReport(err),0,true);                                    % Display Error Message (0)
    format_print('\n  Now Returning\n\n',0);                                % Display Errors (0)
    return
end

format_print(' -Done\n\n',1);                                               % Display Section (1)


%% Load Site Change Information
format_print('Loading Site Change Information:\n',1);                       % Display Section (1)

try
    load_site_change_info();                                % Run wrapper function
catch err
    format_print('  Badness Loading Site Change Info!!\n\n',0);               % Display Errors (0)
    format_print(getReport(err),0,true);                                    % Display Error Message (0)
    format_print('\n',0);
    % Note the code will continue to function because all the change arrays
    % were predeclared.  The code will just function as if each station has
    % not had any changes of its antenna, receiver or firmware
end

format_print(' -Done\n\n',1);                                               % Display Section (1)


%% Load Offsets
format_print('Loading Other Offsets:\n',1);                                 % Display Section (1)

try
    load_offsets_list();                                    % Run wrapper function
catch err
    format_print('  Badness Loading Offsets!!\n\n',0);                        % Display Errors (0)
    format_print(getReport(err),0,true);                                    % Display Error Message (0)
    format_print('\n',0);
end

format_print(' -Done\n\n',1);                                               % Display Section (1)


%% Process List of Stations
format_print('========================================\n',1);               % Display Section (1)
format_print('Processing Sites:\n\n',1);                                    % Display Section (1)
format_print('========================================\n',1);               % Display Section (1)

% Loop Through Each Site
num_sites=length(sites_list);                               % Total number of sites in the list
for ind=1:num_sites                                         % Loop through each site
    %% Display the Current Site ID
    string=sprintf('====Site: %s=========%4d of %4d=========\n',sites_list(ind).sid,ind,num_sites);
    format_print(string,10);                                                % Display Site Name (10)
    
    %% Load Raw SNR Data
    format_print('  Loading SNR\n',100);                                    % Display Site Progress (100)
    
    try
        load_snr_data(ind);                                 % Load Current site snr
    catch err
        format_print('    Badness Loading SNR Data!!\n\n',0);                 % Display Errors (0)
        format_print(getReport(err),0,true);                                % Display Error Message (0)
        format_print('\n',0);
    end
    
    %% Load NEU Position Data
    format_print('  Loading NEU Position Data\n',100);                      % Display Site Progress (100)
    
    try
        load_neu_positions(ind);
    catch err
        format_print('    Badness Loading NEU Data!!\n\n',0);                 % Display Errors (0)
        format_print(getReport(err),0,true);                                % Display Error Message (0)
        format_print('\n',0);
    end
    
    
    
    %% Process Current Site
    format_print('  Processing Site\n',100);                                % Display Site Progress (100)
    
    try
        main_processor(ind);                                % Process the current site
    catch err
        format_print('    Badness Occurred!!\n\n',0);                         % Display Errors (0)
        format_print(getReport(err),0,true);                                % Display Error Message (0)
        format_print('\n',0);
    end
    
    format_print('   -Done \n',100);                                        % Display Site Progress (100)
    
    %% Plot Site Results
    if(constants.make_plots)
        format_print('  Plotting Site\n',100);                              % Display Site Progress (100)
        
        try
            
            main_plotter(ind);                              % Plot the current site
        catch err
            format_print('    Badness Occurred!!\n\n',0);                     % Display Errors (0)
            format_print(getReport(err),0,true);                            % Display Error Message (0)
            format_print('\n',0);
        end
        
        format_print('   -Done\n',100);                                     % Display Site Progress (100)
    end
    
    %% Finished with Site
    format_print(' -Done with Site\n',100);                                 % Display Site Progress (100)
    
end                                                         % Done looping through all sites


%% Finished Processing All Sites
format_print(' -Done Processing All Sites\n\n',1);                          % Display Section (1)


%% Cleanup Workspace
modify_path('c');                                           % Cleanup the Path
end % function
