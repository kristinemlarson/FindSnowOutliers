function main_processor(site_ind)
%MAIN_PROCESSOR - Processes a single site by performing all segments to
% remove bad SNR data points.
%
% Syntax:  main_processor(site_ind)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%
% Outputs:
%
% Changes to Globals:
%   sites_list(site_ind).snr{snr_ind}
%       .data
%       .all_bad
%       .raw
%       .missing
%   === Bad Days ===
%       .cleaned
%       .bad_days
%   === SNR Mask ===
%       .masked
%       .bad_snr_mask
%   === Offsets ===
%       .no_offsets
%       .offsets_deltas
%   === First Cut ===
%       .first_cut
%       .bad_first_cut
%       .first_cut_params
%   === Second Cut ===
%       .second_cut
%       .bad_second_cut
%       .second_cut_params
%       .summer_pts
%   === Third Cut ===
%       .third_cut
%       .bad_third_cut
%       .third_cut_fit
%       .third_cut_sigma
%       
%
% See also: SNR_OUTLIERS_MAIN
% Author: Kristine Larson
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% February 27 2013; Last revision: August 07, 2013
% Current Version: 1.1
% Backward Compatible Version: 1.1
% Precedent Versions: N/A
% Dependent Versions: save_snr_flags.m (1.1)

%% Load Globals
global constants sites_list


%% Process Each set of snr data
n_types=length(sites_list(site_ind).snr);

for snr_ind=1:n_types
    if(sites_list(site_ind).snr{snr_ind}.process)       % Process this type
        %% Check Size of SNR Data
        data=sites_list(site_ind).snr{snr_ind}.data;        % Raw SNR data
        [nr,~]=size(data);                                  % Number of rows
        if(nr>0)                                            % There is at least 1 row of data            
            %% Bad Days
            
            format_print('    -Removing Bad Data Points\n',100);                % Display Site Progress (100)
            
            try
                remove_bad_days(site_ind,snr_ind);              % Remove bad data
            catch err
                format_print('      Issue Removing Bad Data Points!!\n\n',0);   % Display Errors (0)
                format_print(getReport(err),0,true);                       % Display Error Message (0)
                format_print('\n',0);
            end
            
            format_print('       Done\n',100);                                  % Display Site Progress (100)
            
            %% SNR Mask
            
            format_print('    -Applying SNR Mask\n',100);                       % Display Site Progress (100)
            
            try
                remove_snr_mask(site_ind,snr_ind);              % Remove points outside mask
            catch err
                format_print('      Issue Removing SNR Mask Points!!\n\n',0);   % Display Errors (0)
                format_print(getReport(err),0,true);                       % Display Error Message (0)
                format_print('\n',0);
            end
            
            format_print('       Done\n',100);                                  % Display Site Progress (100)
                      
            %% Remove Offsets
            format_print('    -Removing Offsets\n',100);                    % Display Site Progress (100)
            try
                remove_offsets(site_ind,snr_ind);               % Remove firmwate offsets
            catch err
                format_print('      Issue Removing Offsets!!\n\n',0);       % Display Errors (0)
                format_print(getReport(err),0,true);                        % Display Error Message (0)
                format_print('\n',0);
            end
            
            format_print('       Done\n',100);                                  % Display Site Progress (100)
                       
            %% First Cut
            format_print('    -Removing First Cut:',100);                       % Display Site Progress (100)
            format_print(sprintf('%2d Sigma Outliers\n',constants.cut1_sigma),100); % Display Site Progress (100)
            try
                remove_first_cut(site_ind,snr_ind);             % Remove first cut
            catch err
                format_print('      Issue During First Cut!!\n\n',0);           % Display Errors (0)
                format_print(getReport(err),0,true);                       % Display Error Message (0)
                format_print('\n',0);
            end
            
            format_print('       Done\n',100);                                  % Display Site Progress (100)
            
            %% Second Cut
            format_print('    -Removing Second Cut:',100);                      % Display Site Progress (100)
            format_print(' Summer Defined Outliers\n',100);                     % Display Site Progress (100)
            try
                remove_second_cut(site_ind,snr_ind);            % Remove second cut
            catch err
                format_print('      Issue During Second Cut!!\n\n',0);          % Display Errors (0)
                format_print(getReport(err),0,true);                       % Display Error Message (0)
                format_print('\n',0);
            end
            
            format_print('       Done\n',100);                                  % Display Site Progress (100)
                       
            %% Third Cut
            format_print('    -Removing Third Cut:',100);                       % Display Site Progress (100)
            format_print(sprintf('%2d Sigma Sinusoidal Outliers\n',constants.cut3_sigma),100); % Display Site Progress (100)
            try
                remove_third_cut(site_ind,snr_ind);             % Remove third cut
            catch err
                format_print('      Issue During Third Cut!!\n\n',0);           % Display Errors (0)
                format_print(getReport(err),0,true);                       % Display Errors (0)
                format_print('\n',0);
            end
            
            format_print('       Done\n',100);                                  % Display Site Progress (100)
            
            %% Save Data
            format_print('    -Saving SNR Data\n',100);                        % Display Site Progress (100)
            
            try
                save_snr_data(site_ind,snr_ind);               % Save Current site snr
                save_snr_flags(site_ind,snr_ind);              % Save Current site flags
            catch err
                format_print('    Issue Saving SNR Data!!\n\n',0);                  % Display Errors (0)
                format_print(getReport(err),0,true);                                % Display Error Message (0)
                format_print('\n',0);
            end
            
            format_print('       Done\n',100);                                  % Display Site Progress (100)
            
            
        else                                                % Number of rows was not more than 0
            format_print('     No Data Points to Process\n',100);           % Display Site Progress (100)
        end
    end                                             % Done processing this type
end

end % function
