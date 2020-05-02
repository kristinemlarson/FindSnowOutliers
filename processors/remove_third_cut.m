function remove_third_cut(site_ind,snr_ind)
%REMOVE_THIRD_CUT - Removes standard deviation based outliers from a
% sinusoidal fit to the SNR data.
% Outliers are determined for each section of data that occur between 
% different equipment changes.
%
% Syntax:  remove_third_cut(site_ind,snr_ind)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%   snr_ind             index of the snr data set to use within the
%                       sites_list structure for the given site
%
% Global Parameters:
%   constants
%       .remove_cut3    logical Perform this segment or not
%       .cut3_sigma     number of standard deviations away from the mean
%       .cut3_outliers  [2x1] logical [low;high] remove low/high outliers
%
% Outputs:
%
% Changes to Globals:
%   sites_list(site_ind).snr{snr_ind}
%       .data           [Nx4] [year doy year.dec snr] updated snr data set 
%       .all_bad        [Mx4] [year doy year.dec snr] update set of all bad
%                       data points so far
%       .third_cut      [Nx4] [year doy year.dec snr] updated snr data set
%       .bad_third_cut  [Rx4] [year doy year.dec snr] days marked as
%                           outliers in this segment
%       .third_cut_fit  [(N+R)x4] [year doy year.dec snr] Sinusoidal fit
%       .third_cut_sigma[(N+R)x5] [year doy year.dec fit- fit+] Sinusoidal
%                           fit +- sigma
%
% See also: SNR_OUTLIERS_MAIN MARK_SINUSOID_OUTLIERS
% Author: Kristine Larson
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% April 10, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global constants sites_list


%% Predeclare
good_data=zeros(0,4);
bad_data=zeros(0,4);
fit=zeros(0,4);
fit_sigma=zeros(0,5);

%% Get SNR Data
data=sites_list(site_ind).snr{snr_ind}.data;

%% Check Segment Toggle
if(constants.remove_cut3)
    %% Check SNR Data Size
    [nr,~]=size(data);
    if(nr>0)
        %% Discretize Station Equipment Changes
        equipment_changes=sites_list(site_ind).equipment_changes;
        % Remove values that occur outside the data range
        if(~isempty(equipment_changes))
            inds=equipment_changes(:,3)<data(1,3)|equipment_changes(:,3)>data(end,3);
            equipment_changes=equipment_changes(~inds,:);
        end
        [nr,~]=size(equipment_changes);                         % Update size for loop
        
        %% Remove Third Cut Outliers
        if(nr>0)
            %% Process Each Segment
            for change=0:nr
                %% Find Data Set Endpoints
                if(change==0)       % first segment
                    % Endpoints
                    tmin=data(1,3);
                    tmax=equipment_changes(change+1,3);
                elseif(change==nr)  % last segment
                    tmin=equipment_changes(change,3);
                    tmax=data(end,3)+0.00001;                       % Last point plus a small positive offset so that it is included in <tmax
                else
                    tmin=equipment_changes(change,3);
                    tmax=equipment_changes(change+1,3);
                end
                
                %% Trim data set
                inds=(data(:,3)>=tmin & data(:,3)<tmax);
                segment_data=data(inds,:);
                
                %% Process Segment
                if(~isempty(segment_data))                  % Enough Data to process
                    [indices,segment_fit,parameters]=mark_sinusoid_outliers(segment_data,constants.cut3_sigma,constants.cut3_outliers);
                    good_data=[good_data;segment_data(~indices,:)];
                    bad_data=[bad_data;segment_data(indices,:)];
                    fit=[fit;segment_fit];                                  % Store Sinusoid Fit
                    if(~isempty(parameters))                                % Ensure there was a sigma value
                        fit_sigma=[fit_sigma;segment_fit(:,1:3),segment_fit(:,4)-parameters(1),segment_fit(:,4)+parameters(1)];
                    end
                end
            end
        else
            %% Process Whole Timeseries
            [indices,segment_fit,parameters]=mark_sinusoid_outliers(data,constants.cut3_sigma,constants.cut3_outliers);
            good_data=data(~indices,:);
            bad_data=data(indices,:);
            fit=segment_fit;
            if(~isempty(parameters))                                    % Ensure there was a sigma value
                fit_sigma=[segment_fit(:,1:3),segment_fit(:,4)-parameters(1),segment_fit(:,4)+parameters(1)];
            end
            
        end
        %% Display Total Results
        format_print(sprintf('       Removed %4d Bad Points\n',length(bad_data)),1000);      % Display All (1000)
    else        % No Data Points
        good_data=data;
        format_print('       No Data Points\n',1000);                           % Display All (100)
    end
else            % Toggle is Off
    good_data=data;
    format_print('       Segment Toggle is Off\n',1000);                           % Display All (1000)
end
%% Add Back to sites_list
sites_list(site_ind).snr{snr_ind}.data=good_data;
sites_list(site_ind).snr{snr_ind}.all_bad=sort_by_ydec([sites_list(site_ind).snr{snr_ind}.all_bad;bad_data]);
sites_list(site_ind).snr{snr_ind}.third_cut=good_data;
sites_list(site_ind).snr{snr_ind}.bad_third_cut=bad_data;
sites_list(site_ind).snr{snr_ind}.third_cut_fit=fit;
sites_list(site_ind).snr{snr_ind}.third_cut_sigma=fit_sigma;
