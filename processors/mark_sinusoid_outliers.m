function [indices,data_fit,parameters]=mark_sinusoid_outliers(data,sigma_tol,outliers)
%MARK_SINUSOID_OUTLIERS - Finds a sinusoidal fit and finds data points that
% are outside a specified standard deviation range from the fit. 
% Either low, high or both can be specified.
% The sinusoidal fit is a sinusoid with a period of 1 year to match the
% seasonal variation of SNR data.
%
% Syntax:   [indices,data_fit,parameters]=mark_sinusoid_outliers(data,sigma_tol)
%           [indices,data_fit,parameters]=mark_sinusoid_outliers(data,sigma_tol,outliers)
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
%   data_fit            [Nx4] [year doy year.dec snr] Simulated Sinusoidal
%                       data used to find outliers
%   parameters          [sigma_tol*sigma]
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
    data_fit=data;
else
    data_fit=zeros(0,4);
end
parameters=zeros(0,2);

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

%% Remove First Year Offset from Year.dec
snr_ydec=data(:,3)-data(1,1);                       % subtract first year value

%% Setup Least Squares Matrix
[nr,~]=size(data);
T=1;                                                % [yr] Period of Sinusoid=1 year
A=[ones(nr,1), snr_ydec, cos(2*pi*snr_ydec/T), sin(2*pi*snr_ydec/T)];       % Each row is [1 t cos(2*pi*t/T) sin(2*pi*t/T]

%% Calculate Least Squares Solution
x_hat=A\data(:,4);                                  % Find coefficients for the least squares fit
x_fit=A*x_hat;                                      % Find the estimate based on the coefficients
data_fit(:,4)=x_fit;                                % Add to the 4th column of the data_fit output

%% Calculate Residuals and Their Statistics
residuals=data(:,4)-x_fit;                          % distance of the data from the fit at that point
sigma=std(residuals);                               % standard deviation of the residual data

%% Find and Mark Outliers
if(outliers_low)                                % Outliers are less than mean-3sigma
    inds_low=data(:,4)<(x_fit-sigma_tol*sigma);
    indices=indices|inds_low;                                               % OR the two arrays so that the low values can be added
end

if(outliers_high)                               % Outliers are greater than mean+3sigma
    inds_high=data(:,4)>(x_fit+sigma_tol*sigma);
    indices=indices|inds_high;                                              % OR the two arrays so that the high values can be added
end

%% Display Results
temp=ones(length(indices),1);
num_pts=sum(temp(indices));
format_print(sprintf('       Between %7.3f and %7.3f   :',data(1,3),data(end,3)),1000); % Display All (1000)
format_print(sprintf(' Removed %3d Points sigma=%4.2f\n',num_pts,sigma),1000);          % Display All (1000)

%% Return Parameters
parameters=[sigma_tol*sigma];
