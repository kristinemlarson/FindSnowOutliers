function [format]=load_format(format_in)
%LOAD_FORMAT -  Loadss a structure containing formatting information
%   Modify this wrapper to change the default values of the desired format
%
% Syntax:   [format]=load_format()
%           [format]=load_format(format_in)
%
% Input:
%   format_in   format values to override defaults for any or all entries
%
% Output:
%   format      structure containing plot format variables
%   === Display Settings ===
%       .text_out       [0,1,10,100,1000] Choose How much text to display to screen
%       .font_size      10
%   === Plot Settings ===
%       .plot_xlim      [max_x min_x]       X axis limits
%       .line_style     'none' Default line style 
%       .marker         '.'     (Version 1.1)
%       .marker_size    6   Default marker size
%       .color          [3xN]   Colors for different data segments and snr types
%           .raw        Raw SNR data [orange/cyan]
%           .bad        All bad data points [blue]
%           .bad_days   Bad SNR days [blue]         Default to .bad
%           .bad_mask   Bad SNR Mask days [blue]    Default to .bad
%           .bad_cut1   Bad First Cut [red]         Default to .bad
%           .bad_cut2   Bad Second Cut [green]      Default to .bad
%           .bad_cut3   Bad Third Cut [magenta]     Default to .bad
%           .no_offsets SNR data with offsets removed  [black]
%           .summer     Summer Data Points    [blue]
%           .summer_min Line for Summer Minimum [blue]
%           .data       SNR data points [black]
%           .cut3_fit   Sinusoid Color  [.5;.5;.5] Gray
%           .cut3_sigma Sinusoid Outlier Color [blue]
%           .offset_marks  Lines for each offset [black]
%           .equip_marks   Lines for each equipment change [black]
%           .antenna_marks Lines for each antenna change [blue]
%           .receiver_marks Lines for each antenna change [red]
%
%       .line_style_bad             'none'
%       .marker_bad                 '.'     (Version 1.1)
%       .line_style_bad_days        'none'
%       .marker_bad_days            '*'     (Version 1.1)
%       .line_style_bad_mask        'none'  (Version 1.1)
%       .marker_bad_mask            '.'     (Version 1.1)
%       .line_style_bad_cut1        'none'  (Version 1.1)
%       .marker_bad_cut1            '*'     (Version 1.1)
%       .line_style_bad_cut2        'none'  (Version 1.1)
%       .marker_bad_cut2            '*'     (Version 1.1)
%       .line_style_bad_cut3        'none'  (Version 1.1)
%       .marker_bad_cut3            '*'     (Version 1.1)
%       .line_style_summer          'none'
%       .marker_summer              '.'     (Version 1.1)
%       .line_style_summer_min      '--'
%       .line_width_summer          1
%       .line_width_summer_min      1
%       .line_style_offset_marks    '--'
%       .line_width_offset_marks    1
%       .line_style_equip_marks     '--'
%       .line_width_equip_marks     1
%
%
% Wrapper function for the snr_outliers MATLAB code suite
% See also: SNR_OUTLIERS_MAIN

% Author: Kyle Wolma
%   University of Colorado at Boulder
% February 27, 2013; Last revision: August 13, 2013
% Current Version: 1.2
% Backward Compatible Version: 1.0
% Precedent Versions: N/A
% Dependent Versions:
%   plot_bad_days.m;plot_bad_first_cut.m;plot_bad_second_cut.m;
%   plot_bad_snr_mask.m;plot_bad_third_cut.m;plot_first)cut.m;
%   plot_no_offsets.m;plot_raw.m;plot_second_cut.m;plot_summer.m; (1.1)

%% Handle Input
if(nargin<1||~isstruct(format_in))
    defaults=true;                                  % use defaults for all format values
else
    defaults=false;                                 % use the input format values wherever possible
end


%% DISPLAY SETTINGS========================================================
%%=========================================================================
%% Text Display Settings  -Verboseness
% 0         Errors Only
% >=1       Sections Only
% >=10      Site Names Only
% >=100     Site Progress Only
% >=1000    All [Default]
if(defaults||...                                % Default
        ~isfield(format_in,'text_out')||...     % No input specified
        ~isnumeric(format_in.text_out))         % Wrong input format
    
    format.text_out=1000;                           % Default Value 
else
    format.text_out=format_in.text_out;             % Input Value
end

%% Font Size
if(defaults||...                                % Default
        ~isfield(format_in,'font_size')||...    % No input specified
        ~isnumeric(format_in.font_size))        % Wrong input format
    
    format.font_size=10;                        % Default Value 
else
    format.font_size=format_in.font_size;       % Input Value
end   

%% PLOT SETTINGS===========================================================
%%=========================================================================
%% Data Axis Limits
% Leave Blank for using constants.snr_yrs limits
if(defaults||...                                % Default
        ~isfield(format_in,'plot_xlim')||...    % No input specified
        ~isnumeric(format_in.plot_xlim))        % Wrong input format
    
    format.plot_xlim=[];                        % Default Value 
else
    format.plot_xlim=format_in.plot_xlim;       % Input Value
end                                   

%% Default Plot Formats
% SNR LineStyle
if(defaults||...                                % Default
        ~isfield(format_in,'line_style')||...   % No input specified
        ~ischar(format_in.line_style))       % Wrong input format
    
    format.line_style='none';                   % Default Value 
else
    format.line_style=format_in.line_style;     % Input Value
end 
% SNR Marker
if(defaults||...                                % Default
        ~isfield(format_in,'marker')||...       % No input specified
        ~ischar(format_in.marker))              % Wrong input format
    
    format.marker='.';                          % Default Value 
else
    format.marker=format_in.marker;             % Input Value
end 

% SNR MarkerSize
if(defaults||...                                % Default
        ~isfield(format_in,'marker_size')||...  % No input specified
        ~isnumeric(format_in.marker_size))      % Wrong input format
    
    format.marker_size=6;                       % Default Value 
else
    format.marker_size=format_in.marker_size;   % Input Value
end 

%% Raw SNR Color
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'raw')||...    % No input specified
        ~isnumeric(format_in.color.raw))        % Wrong input format
    
    format.color.raw(:,1)=[1;.4;0];             % Default type 1 Raw Data Color [1;.4;0] Orange
    format.color.raw(:,2)=[0;1;1];              % Default type 2 Raw Data Color [0;1;1]='c' Cyan
else
    format.color.raw=format_in.color.raw;       % Input Value
end                

%% Bad Data Point Colors
% Default Bad
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'bad')||...    % No input specified
        ~isnumeric(format_in.color.bad))        % Wrong input format
    
    format.color.bad(:,1)=[0;0;1];              % Default Bad Data Color [0;0;1]='b'=Blue 
else
    format.color.bad=format_in.color.bad;       % Input Value
end  

% Bad Days
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'bad_days')||...    % No input specified
        ~isnumeric(format_in.color.bad_days))        % Wrong input format
    
    format.color.bad_days(:,1)=[0;0;1];              % Default Bad Data Color [0;0;1]='b'=Blue 
else
    format.color.bad_days=format_in.color.bad_days;  % Input Value
end  

% Bad SNR Mask
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'bad_mask')||...    % No input specified
        ~isnumeric(format_in.color.bad_mask))        % Wrong input format
    
    format.color.bad_mask(:,1)=[0;0;1];              % Default Bad Data Color [0;0;1]='b'=Blue 
else
    format.color.bad_mask=format_in.color.bad_mask;  % Input Value
end  

% Bad First Cut
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'bad_cut1')||...    % No input specified
        ~isnumeric(format_in.color.bad_cut1))        % Wrong input format
    
    format.color.bad_cut1(:,1)=[1;0;0];              % Default Color for 1st Cut Bad Data [1;0;0]='r'=Red 
else
    format.color.bad_cut1=format_in.color.bad_cut1;  % Input Value
end  

% Bad Second Cut
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'bad_cut2')||...    % No input specified
        ~isnumeric(format_in.color.bad_cut2))        % Wrong input format
    
    format.color.bad_cut2(:,1)=[0;1;0];              % Default Color for 2nd Cut Bad Data [0;1;0]='g'=Green 
else
    format.color.bad_cut2=format_in.color.bad_cut2;  % Input Value
end  

% Bad Third Cut
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'bad_cut3')||...    % No input specified
        ~isnumeric(format_in.color.bad_cut3))        % Wrong input format
    
    format.color.bad_cut3(:,1)=[1;0;1];              % Default Color for 3rd Cut Bad Data [1;0;1]='m'=Magenta 
else
    format.color.bad_cut3=format_in.color.bad_cut3;  % Input Value
end  

%% Bad Data Point Formats
% Default Bad
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_bad')||...   % No input specified
        ~ischar(format_in.line_style_bad))       % Wrong input format
    
    format.line_style_bad='none';               % Default Value 
else
    format.line_style_bad=format_in.line_style_bad;     % Input Value
end 
% Default Bad Marker
if(defaults||...                                % Default
        ~isfield(format_in,'marker_bad')||...   % No input specified
        ~ischar(format_in.marker_bad))          % Wrong input format
    
    format.marker_bad='.';                      % Default Value 
else
    format.marker_bad=format_in.marker_bad;     % Input Value
end 

%% Bad Days Formats
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_bad_days')||...   % No input specified
        ~ischar(format_in.line_style_bad_days))       % Wrong input format
    
    format.line_style_bad_days='none';                      % Default Value 
else
    format.line_style_bad_days=format_in.line_style_bad_days;     % Input Value
end 
% Bad Days Marker
if(defaults||...                                % Default
        ~isfield(format_in,'marker_bad_days')||...   % No input specified
        ~ischar(format_in.marker_bad_days))       % Wrong input format
    
    format.marker_bad_days='*';                 % Default Value 
else
    format.marker_bad_days=format_in.marker_bad_days;     % Input Value
end 

%% Bad Mask Formats
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_bad_mask')||...   % No input specified
        ~ischar(format_in.line_style_bad_mask))       % Wrong input format
    
    format.line_style_bad_mask='none';                      % Default Value 
else
    format.line_style_bad_mask=format_in.line_style_bad_mask;     % Input Value
end 
% Bad Mask Marker
if(defaults||...                                % Default
        ~isfield(format_in,'marker_bad_mask')||...   % No input specified
        ~ischar(format_in.marker_bad_mask))       % Wrong input format
    
    format.marker_bad_mask='.';                 % Default Value 
else
    format.marker_bad_mask=format_in.marker_bad_mask;     % Input Value
end 

%% Bad Cut 1 Formats
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_bad_cut1')||...   % No input specified
        ~ischar(format_in.line_style_bad_cut1))       % Wrong input format
    
    format.line_style_bad_cut1='none';                      % Default Value 
else
    format.line_style_bad_cut1=format_in.line_style_bad_cut1;     % Input Value
end 
% Bad Cut1 Marker
if(defaults||...                                % Default
        ~isfield(format_in,'marker_bad_cut1')||...   % No input specified
        ~ischar(format_in.marker_bad_cut1))       % Wrong input format
    
    format.marker_bad_cut1='*';                 % Default Value 
else
    format.marker_bad_cut1=format_in.marker_bad_cut1;     % Input Value
end 

%% Bad Cut 2 Formats
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_bad_cut2')||...   % No input specified
        ~ischar(format_in.line_style_bad_cut2))       % Wrong input format
    
    format.line_style_bad_cut2='none';                      % Default Value 
else
    format.line_style_bad_cut2=format_in.line_style_bad_cut2;     % Input Value
end 
% Bad Cut2 Marker
if(defaults||...                                % Default
        ~isfield(format_in,'marker_bad_cut2')||...   % No input specified
        ~ischar(format_in.marker_bad_cut2))       % Wrong input format
    
    format.marker_bad_cut2='*';                 % Default Value 
else
    format.marker_bad_cut2=format_in.marker_bad_cut2;     % Input Value
end 

%% Bad Cut 3 Formats
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_bad_cut3')||...   % No input specified
        ~ischar(format_in.line_style_bad_cut3))       % Wrong input format
    
    format.line_style_bad_cut3='none';                      % Default Value 
else
    format.line_style_bad_cut3=format_in.line_style_bad_cut3;     % Input Value
end 
% Bad Cut3 Marker
if(defaults||...                                % Default
        ~isfield(format_in,'marker_bad_cut3')||...   % No input specified
        ~ischar(format_in.marker_bad_cut3))       % Wrong input format
    
    format.marker_bad_cut3='*';                 % Default Value 
else
    format.marker_bad_cut3=format_in.marker_bad_cut3;     % Input Value
end 

%% Firmware Offset Color
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'no_offsets')||...    % No input specified
        ~isnumeric(format_in.color.no_offsets))        % Wrong input format
    
    format.color.no_offsets(:,1)=[0;0;0];       % Default Value
else
    format.color.no_offsets=format_in.color.no_offsets;       % Input Value
end                               

%% Summer Plot Formats
% Summer Data Line Style
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_summer')||...   % No input specified
        ~ischar(format_in.line_style_summer))       % Wrong input format
    
    format.line_style_summer='none';                      % Default Value 
else
    format.line_style_summer=format_in.line_style_summer;     % Input Value
end 
% Summer Data Marker
if(defaults||...                                        % Default
        ~isfield(format_in,'marker_summer')||...        % No input specified
        ~ischar(format_in.marker_summer))               % Wrong input format
    
    format.marker_summer='.';                           % Default Value 
else
    format.marker_summer=format_in.marker_summer;       % Input Value
end 

% Summer Minimum Line Style
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_summer_min')||...   % No input specified
        ~ischar(format_in.line_style_summer_min))       % Wrong input format
    
    format.line_style_summer_min='--';                      % Default Value 
else
    format.line_style_summer_min=format_in.line_style_summer_min;     % Input Value
end 

% Summer Min Line Width
format.line_width_summer_min=1;

if(defaults||...                                % Default
        ~isfield(format_in,'line_width_summer_min')||...   % No input specified
        ~isnumeric(format_in.line_width_summer_min))       % Wrong input format
    
    format.line_width_summer_min=1;                      % Default Value 
else
    format.line_width_summer_min=format_in.line_width_summer_min;     % Input Value
end 

%% Summer Plot Colors
% Summer SNR Data Points
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'summer')||... % No input specified
        ~isnumeric(format_in.color.summer))     % Wrong input format
    
    format.color.summer(:,1)=[0;0;1];           % Default Value
else
    format.color.summer=format_in.color.summer; % Input Value
end   

% Summer Minimum
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'summer_min')||... % No input specified
        ~isnumeric(format_in.color.summer_min))     % Wrong input format
    
    format.color.summer_min(:,1)=[0;0;1];           % Default Value
else
    format.color.summer_min=format_in.color.summer_min; % Input Value
end    

%% Third Cut Sinusoid Fit Formats
% Sinusoid Line Style
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_cut3_fit')||...   % No input specified
        ~ischar(format_in.line_style_cut3_fit))       % Wrong input format
    
    format.line_style_cut3_fit='-';                      % Default Value 
else
    format.line_style_cut3_fit=format_in.line_style_cut3_fit;     % Input Value
end 

% Sinusoid Line Width
if(defaults||...                                % Default
        ~isfield(format_in,'line_width_cut3_fit')||...   % No input specified
        ~isnumeric(format_in.line_width_cut3_fit))       % Wrong input format
    
    format.line_width_cut3_fit=2;                      % Default Value 
else
    format.line_width_cut3_fit=format_in.line_width_cut3_fit;     % Input Value
end 

% Sinusoid Sigma Line Style
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_cut3_sigma')||...   % No input specified
        ~ischar(format_in.line_style_cut3_sigma))       % Wrong input format
    
    format.line_style_cut3_sigma='--';                      % Default Value 
else
    format.line_style_cut3_sigma=format_in.line_style_cut3_sigma;     % Input Value
end 

% Sinusoid Sigma Line Width
if(defaults||...                                % Default
        ~isfield(format_in,'line_width_cut3_sigma')||...   % No input specified
        ~isnumeric(format_in.line_width_cut3_sigma))       % Wrong input format
    
    format.line_width_cut3_sigma=1;                      % Default Value 
else
    format.line_width_cut3_sigma=format_in.line_width_cut3_sigma;     % Input Value
end 

%% Third Cut Sinusoid Fit Colors
% Sinusoid Fit Color
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'cut3_fit')||... % No input specified
        ~isnumeric(format_in.color.cut3_fit))     % Wrong input format
    
    format.color.cut3_fit(:,1)=[.5;.5;.5];        % Default Value [.5;.5;.5] gray
else
    format.color.cut3_fit=format_in.color.cut3_fit; % Input Value
end   

% Sinusoid Fit Color
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'cut3_sigma')||... % No input specified
        ~isnumeric(format_in.color.cut3_sigma))     % Wrong input format
    
    format.color.cut3_sigma(:,1)=[0;0;1];        % Default Value Blue
else
    format.color.cut3_sigma=format_in.color.cut3_sigma; % Input Value
end   

%% SNR Data Color
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'data')||...   % No input specified
        ~isnumeric(format_in.color.data))       % Wrong input format
    
    format.color.data(:,1)=[0;0;0];             % Default Data Color [0;0;0]='k'=Black
else
    format.color.data=format_in.color.data;     % Input Value
end  

%% Offset Line Marks Formats
% Offset Mark Line Style
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_offset_marks')||...   % No input specified
        ~ischar(format_in.line_style_offset_marks))       % Wrong input format
    
    format.line_style_offset_marks='-.';                      % Default Value 
else
    format.line_style_offset_marks=format_in.line_style_offset_marks;     % Input Value
end 

% Offset Mark Line Width
if(defaults||...                                % Default
        ~isfield(format_in,'line_width_offset_marks')||...   % No input specified
        ~isnumeric(format_in.line_width_offset_marks))       % Wrong input format
    
    format.line_width_offset_marks=1;                      % Default Value 
else
    format.line_width_offset_marks=format_in.line_width_offset_marks;     % Input Value
end 

%% Offset Line Marks Color
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'offset_marks')||... % No input specified
        ~isnumeric(format_in.color.offset_marks))     % Wrong input format
    
    format.color.offset_marks(:,1)=[0;0;0];     % Default Value
else
    format.color.offset_marks=format_in.color.offset_marks; % Input Value
end   

%% Equipment Line Marks Formats
% Equipment Mark Line Style
if(defaults||...                                % Default
        ~isfield(format_in,'line_style_equip_marks')||...   % No input specified
        ~ischar(format_in.line_style_equip_marks))       % Wrong input format
    
    format.line_style_equip_marks='--';                      % Default Value 
else
    format.line_style_equip_marks=format_in.line_style_equip_marks;     % Input Value
end 

% Offset Mark Line Width
if(defaults||...                                % Default
        ~isfield(format_in,'line_width_equip_marks')||...   % No input specified
        ~isnumeric(format_in.line_width_equip_marks))       % Wrong input format
    
    format.line_width_equip_marks=1;                      % Default Value 
else
    format.line_width_equip_marks=format_in.line_width_equip_marks;     % Input Value
end 

%% Equipment Line Marks Color
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'equip_marks')||... % No input specified
        ~isnumeric(format_in.color.equip_marks))     % Wrong input format
    
    format.color.equip_marks(:,1)=[0;0;0];     % Default Value
else
    format.color.equip_marks=format_in.color.equip_marks; % Input Value
end 
% antenna change
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'antenna_marks')||... % No input specified
        ~isnumeric(format_in.color.antenna_marks))     % Wrong input format
    
    format.color.antenna_marks(:,1)=[0;0;1];     % Default Value
else
    format.color.antenna_marks=format_in.color.antenna_marks; % Input Value
end   
% receiver change
if(defaults||...                                % Default
        ~isfield(format_in,'color')||...        % No color subfield
        ~isfield(format_in.color,'receiver_marks')||... % No input specified
        ~isnumeric(format_in.color.receiver_marks))     % Wrong input format
    
    format.color.receiver_marks(:,1)=[1;0;0];     % Default Value
else
    format.color.receiver_marks=format_in.color.receiver_marks; % Input Value
end     