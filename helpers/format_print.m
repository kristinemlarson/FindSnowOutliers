function [] = format_print(input,importance,iserror)
%FORMAT_PRINT - Prints the input string to the standard output depending on
% the format print text specifications.  
%
% Syntax:   format_print(input)
%           format_print(input,importance)
%           format_print(input,importance,iserror)
%
% Inputs:
%   input           String to be printed to the console
%   importance      [0;1;100;1000] default(1000)
%                   integer that specifies what priority the string has for
%                   printing to the console.  this value is compared to
%                   format.text_out and the string only prints if the input
%                   importance is smaller than the text_out cutoff
%   iserror         logical  default(false)
%                   if the input message is a MATLAB error message, it is
%                   printed to the standard error instead of the standard
%                   output
%
%
% Helper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN LOAD_FORMAT
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% May 13, 2013; Last revision: June 13, 2013
% Current Version: 1.0
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions: N/A

%% Load Globals
global format

%% Handle Inputs
if(nargin<3||~islogical(iserror))
    iserror=false;
end

if(nargin<2)
    importance=1000;                    % Default is the lowest priority
end

%% Print the Message
if(iserror)                         
    if(format.text_out>=importance)
        fprintf(2,input);               % Print to the error buffer
    end
else
    if(format.text_out>=importance)
        fprintf(1,input);               % Print to the screen
    end
end

end % function