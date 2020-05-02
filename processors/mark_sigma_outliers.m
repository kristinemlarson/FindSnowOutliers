function [indices,parameters]=mark_sigma_outliers(data,sigma_tol,outliers)
%MARK_SIGMA_OUTLIERS - Finds data points that are outside a specified
% standard deviation range from the mean. 
% Either low, high or both can be specified.
%
% Syntax:   [indices,parameters]=mark_sigma_outliers(data,sigma_tol)
%           [indices,parameters]=mark_sigma_outliers(data,sigma_tol,outliers)
%
% Inputs:
%   data                [Nx4] [year doy year.dec snr] data to remove
%                       outliers from
%   sigma_tol           Ex: 3. Tolerance for the number of standard
%                       deviations away the data can be
%   outliers            [2x1] logical   [low;high] outliers to remove
%                       default is [true;true] if no input is used
%
% Outputs:
%   indices             [Nx1] index logicals of the original data set that
%                       correspond to the outlier data
%   parameters          [1x3] [start_date end_date sigma]
%
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN
%
% Author: Kyle Wolma
%   University of Colorado at Boulder
% April 05, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Predeclare
if(nargin>0)
    [nr,~]=size(data);
    indices=false(nr,1);                                                    % Array of false values equal to the length of input data
    parameters=[data(1,3),data(end,3),0];
else
    indices=[];
    parameters=[];
end

%% Handle Inputs
if(nargin<2||length(data)<1)
    format_print('  Not Enough Inputs for Outlier Removal\n\n',0);          % Display Errors (0)
    format_print('Removing no Data Points\n\n',0);                          % Display Errors (0)
    return
end
if(nargin<3||~islogical(outliers))
    outliers=[true;true];                           % Default outliers matrix
end
outliers_low=outliers(1,1);
outliers_high=outliers(2,1);

%% Calculate Sample Statistics
sigma=std(data(:,4));
parameters(1,3)=sigma;
mu=mean(data(:,4));

%% Find and Mark Outliers
if(outliers_low)                                % Outliers are less than mean-3sigma
    inds_low=data(:,4)<(mu-sigma_tol*sigma);
    indices=indices|inds_low;                                               % OR the two arrays so that the low values can be added
end

if(outliers_high)                               % Outliers are greater than mean+3sigma
    inds_high=data(:,4)>(mu+sigma_tol*sigma);
    indices=indices|inds_high;                                              % OR the two arrays so that the high values can be added
end

%% Display Results
temp=ones(length(indices),1);
num_pts=sum(temp(indices));
format_print(sprintf('       Between %7.3f and %7.3f   :',data(1,3),data(end,3)),1000); % Display All (1000)
format_print(sprintf(' Removed %3d Points sigma=%4.2f mu=%4.2f\n',num_pts,sigma,mu),1000);  % Display All (1000)

