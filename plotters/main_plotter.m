function main_plotter(site_ind)
%MAIN_PLOTTER - Creates a set of plots for processed snr data for each site
%
% Syntax:  main_plotterr(site_ind)
%
% Inputs:
%   site_ind            index of site within sites_list structure
%
% Outputs:
%                       1 plot of both raw SNR data sets
%                       1 plot of the second data set as it is processed
%
% See also: SNR_OUTLIERS_MAIN
%
% Programmer: Kyle Wolma
%   University of Colorado at Boulder
% April 12, 2013; Last revision: September 11, 2013
% Current Version: 2.0
% Backward Compatible Version: 1.1
% Precedent Versions: load_constants.m (1.1)
% Dependent Versions: N/A

%% Load Globals
global constants format sites_list

%% Predeclare Legend Entries
h=[];                                       % Handle Array for Legend Entries
legendstr={};                               % String Array for Legend Entries
sp_ratio=4;                                 % 3 is a 2 to 1 subplot to legend ratio

n_types=length(sites_list(site_ind).snr);

%% Plot 1 Compare All Sets of SNR Data
if(~isempty(sites_list(site_ind).snr{1}.data)&&~isempty(sites_list(site_ind).snr{2}.data))
    figure
    fignum=gcf;
    set(gca,'FontSize',format.font_size);
    
    for snr_ind=1:n_types
        if(snr_ind==1)
            subplot(n_types*sp_ratio+1,1,(1:sp_ratio)+sp_ratio*(snr_ind-1));
        else
            subplot(n_types*sp_ratio+1,1,(1:sp_ratio)+sp_ratio*(snr_ind-1)+1);
        end
        set(gca,'FontSize',format.font_size);
        h=[];                                       % Handle Array for Legend Entries
        legendstr={};                               % String Array for Legend Entries
        
        %% Plot Raw
        h_raw=plot_raw(site_ind,snr_ind,fignum);
        
        %% Plot Processed Data
        if(sites_list(site_ind).snr{snr_ind}.process)   % Process/Plot this type
            h_no=plot_no_offsets(site_ind,snr_ind,fignum);
        end
        
        %% Plot Offset Marks
        if(sites_list(site_ind).snr{snr_ind}.process)   % Process/Plot this type
            h_marks=plot_offset_marks(site_ind,snr_ind,fignum);
            if(~isempty(h_marks))                        % Update Legend Entries
                h=[h;h_marks];
                legendstr{length(h),1}='Offsets(F/W)';
            end
        end
        
        %% Plot Antenna and Receiver Changes
        h_ant=plot_antenna_changes(site_ind,snr_ind,fignum);
        h_rec=plot_receiver_changes(site_ind,snr_ind,fignum);
        if(~isempty(h_ant))        % Update Legend Entries
            h=[h;h_ant];
            legendstr{length(h),1}='Antenna Changes';
        end
        if(~isempty(h_rec))                 % Update Legend Entries
            h=[h;h_rec];
            legendstr{length(h),1}='Receiver Changes';
        end
        
        %% Label
        if(snr_ind==1)
            titlestr=sprintf('%s Mean SNR data (55-60 degrees)',sites_list(site_ind).sid);
            title(titlestr);
        else
            xlabel('Year')
        end
        ylabelstr=sprintf('%s SNR, dBHz',sites_list(site_ind).snr{snr_ind}.type);
        ylabel(ylabelstr)
        grid on
        
        %% Adjust Axes
        % X limit
        if(isfield(format,'plot_xlim')&&~isempty(format.plot_xlim))
            xlimit=reshape(format.plot_xlim,1,2);
        else
            xlimit=[constants.snr_yrs(1) constants.snr_yrs(end)+1];                   % Use SNR data endpoints
        end
        xlim(xlimit);
        % Y limit
        if(isfield(format,'plot_ylim')&&~isempty(format.plot_ylim))
            ylimit=reshape(format.plot_ylim,1,2);
            ylim(ylimit);
        else
            % Reset Y lim to SNR min at bottom to eliminate 0s
            lims=ylim();
            miny=lims(1);
            maxy=lims(2);
            if(miny==0)
                yp=get(h_raw,'ydata');
                inds=yp>0;
                miny=floor(min(yp(inds))/5)*5;  % round non zero min down to nearest 5
            end
            ylimit=[miny maxy];
            ylim(ylimit) % reset Y limit to the new min/max range
        end
        
        %% Label SNR Type in top left corner
        text(min(xlimit+.1), interp1([0 1],ylimit,.95),'Raw','Color',get(h_raw,'Color'));
        if(sites_list(site_ind).snr{snr_ind}.process)   % Process/Plot this type
            text(min(xlimit+.1), interp1([0 1],ylimit,.85),'Processed','Color',get(h_no,'Color'));
        end
        
    end % Done with loop over all snr types
    
    %% Create Subplot Legend
    sp_handle=subplot(n_types*sp_ratio+1,1,sp_ratio+1);
    set(gca,'FontSize',format.font_size);
    sp_position=get(sp_handle,'position');      % Subplot Position
    if(~isempty(legendstr))
        l_handle=legend(sp_handle,h,legendstr,'Orientation','Horizontal','Location','North');     % Legend Handle
    end
    axis(sp_handle,'off')
    
    
    %% Save Plot
    if(constants.demo_mode)
        plot_name=['demo/output/',sites_list(site_ind).sid,'_1.png'];
    else
        plot_name=['/data/web/',sites_list(site_ind).sid,'/extra/snr_outliers/',sites_list(site_ind).sid,'_1.png'];
    end
    if(constants.save_plots)
        save_plot(plot_name);
        format_print(sprintf('    Plot Saved to: %s\n',plot_name),100); % Display Site Progress (100)
    else
        format_print('    Plot Not Saved\n',100);                       % Display Site Progress (100)
    end
    
else
    format_print('     No Raw Data Points to Plot\n',100);                  % Display Site Progress (100)
end






%% Plot 2 Plot Each set of SNR Data On a Separate Figure
for snr_ind=1:n_types
    if(sites_list(site_ind).snr{snr_ind}.process&&~isempty(sites_list(site_ind).snr{snr_ind}.data))   % Plot this type
        %% Setup figure
        figure                                              % Create new figure
        fignum=gcf;                                         % Get Current figure number
        
        %% Raw, Bad, Shifted, Bad First Cut in Subplot 1
        subplot(3,sp_ratio,1:(sp_ratio-1));   % All columns but far right
        set(gca,'FontSize',format.font_size);
        
        %% Predeclare Legend Entries
        h=[];                                       % Handle Array for Legend Entries
        legendstr={};                               % String Array for Legend Entries
        
        %% Plot No Offset
        h_no=plot_no_offsets(site_ind,snr_ind,fignum);
        if(~isempty(h_no))                        % Update Legend Entries
            h=[h;h_no];
            legendstr{length(h),1}='No Offsets';
        end
        
        %% Plot Bad Points
        h_bad_days=plot_bad_days(site_ind,snr_ind,fignum);
        if(~isempty(h_bad_days))                    % Update Legend Entries
            h=[h;h_bad_days];
            legendstr{length(h),1}='Bad Days';
        end
        
        %% Plot Bad SNR Mask
        h_mask=plot_bad_snr_mask(site_ind,snr_ind,fignum);
        if(~isempty(h_mask))                        % Update Legend Entries
            h=[h;h_mask];
            legendstr{length(h),1}='SNR Mask';
        end
        
        %% Plot Bad First Cut
        h_cut1=plot_bad_first_cut(site_ind,snr_ind,fignum);
        if(~isempty(h_cut1))                        % Update Legend Entries
            h=[h;h_cut1];
            legendstr{length(h),1}='1^s^t Cut';
        end
        
        %% Plot Antenna and Receiver Changes
        h_ant=plot_antenna_changes(site_ind,snr_ind,fignum);
        h_rec=plot_receiver_changes(site_ind,snr_ind,fignum);
        
        %% Label
        titlestr=sprintf('A. %s SNR 1^s^t cut',sites_list(site_ind).sid);
        title(titlestr);
        set(gca,'xtickLabel',[]);            % Remove x Tick labels
        ylabel('SNR, dBHz')
        grid on
        
        %% Adjust Axes
        % Y limit
        if(isfield(format,'plot_ylim')&&~isempty(format.plot_ylim))
            ylimit=reshape(format.plot_ylim,1,2);
            ylim(ylimit);
        else
            % Reset Y lim to SNR min at bottom to eliminate 0s
            lims=ylim();
            miny=lims(1);
            if(miny==0)
                yp=get(h_no,'ydata');
                inds=yp>0;
                miny=floor(min(yp(inds))/5)*5;  % round non zero min down to nearest 5
            end
            ylimit=[miny maxy];
            ylim(ylimit) % reset Y limit to the new min/max range
        end
        
        %% Create Legend
        sp_handle=subplot(3,sp_ratio,1*sp_ratio);   % Right Column
        set(gca,'FontSize',format.font_size);
        sp_position=get(sp_handle,'position');      % Subplot Position
        if(~isempty(legendstr))
            l_handle=legend(sp_handle,h,legendstr,'Location','NorthWest');     % Legend Handle
        end
        axis(sp_handle,'off')
        
        
        
        %% First Cut, Bad Second Cut, Summer, Summer min in Subplot 2
        subplot(3,sp_ratio,(1:(sp_ratio-1))+sp_ratio);   % All columns but far right
        set(gca,'FontSize',format.font_size);
        
        %% Predeclare Legend Entries
        h=[];                                       % Handle Array for Legend Entries
        legendstr={};                               % String Array for Legend Entries
        
        %% Plot First Cut
        h_cut1=plot_first_cut(site_ind,snr_ind,fignum);
        if(~isempty(h_cut1))                        % Update Legend Entries
            h=[h;h_cut1];
            legendstr{length(h),1}='After 1^s^t';
        end
        
        %% Plot Summer Points
        h_summer=plot_summer(site_ind,snr_ind,fignum);
        if(~isempty(h_summer))                       % Update Legend Entries
            h=[h;h_summer];
            legendstr{length(h),1}='Summer';
        end
        
        %% Plot Summer Mins
        h_summer_min=plot_summer_min(site_ind,snr_ind,fignum);
        
        %% Plot Bad Second Cut
        h_cut2=plot_bad_second_cut(site_ind,snr_ind,fignum);
        if(~isempty(h_cut2))                        % Update Legend Entries
            h=[h;h_cut2];
            legendstr{length(h),1}='2^n^d Cut';
        end
        
        %% Label
        titlestr=sprintf('B. %s SNR 2^n^d Cut',sites_list(site_ind).sid);
        title(titlestr);
        set(gca,'xtickLabel',[]);            % Remove x Tick labels
        ylabel('SNR, dBHz')
        grid on
        
        
        %% Create Legend
        sp_handle=subplot(3,sp_ratio,2*sp_ratio);   % Right Column
        set(gca,'FontSize',format.font_size);
        sp_position=get(sp_handle,'position');      % Subplot Position
        if(~isempty(legendstr))
            l_handle=legend(sp_handle,h,legendstr,'Location','NorthWest');     % Legend Handle
        end
        axis(sp_handle,'off')
        
        
        
        
        
        %% Third Cut and Fits on Subplot 3
        subplot(3,sp_ratio,(1:(sp_ratio-1))+sp_ratio*2);   % All columns but far right
        set(gca,'FontSize',format.font_size);
        
        %% Predeclare Legend Entries
        h=[];                                       % Handle Array for Legend Entries
        legendstr={};                               % String Array for Legend Entries
        
        %% Plot Second Cut
        h_cut2=plot_second_cut(site_ind,snr_ind,fignum);
        if(~isempty(h_cut2))                        % Update Legend Entries
            h=[h;h_cut2];
            legendstr{length(h),1}='After 2^n^d';
        end
        
        %% Plot Bad Third Cut
        h_cut3=plot_bad_third_cut(site_ind,snr_ind,fignum);
        if(~isempty(h_cut3))                         % Update Legend Entries
            h=[h;h_cut3];
            legendstr{length(h),1}='3^r^d Cut';
        end
        
        %% Plot Third Cut Fit
        h_cut3_fit=plot_third_cut_fit(site_ind,snr_ind,fignum);
        
        %% Plot Third Cut Fit Outlier Line
        h_cut3_sigma=plot_third_cut_sigma(site_ind,snr_ind,fignum);
        
        %% Plot Antenna and Receiver Changes
        h_ant=plot_antenna_changes(site_ind,snr_ind,fignum);
        h_rec=plot_receiver_changes(site_ind,snr_ind,fignum);
        
        %% Label
        titlestr=sprintf('C. %s SNR 3^r^d Cut',sites_list(site_ind).sid);
        title(titlestr);
        ylabel('SNR, dBHz')
        xlabel('Year')
        grid on
        
        %% Create Legend
        sp_handle=subplot(3,sp_ratio,3*sp_ratio);   % Right Column
        set(gca,'FontSize',format.font_size);
        sp_position=get(sp_handle,'position');      % Subplot Position
        if(~isempty(legendstr))
            l_handle=legend(sp_handle,h,legendstr,'Location','NorthWest');     % Legend Handle
        end
        axis(sp_handle,'off')
        
        
        
        %% Save Plot
        if(constants.demo_mode)
            plot_name=['demo/output/',sites_list(site_ind).sid,'_2.png'];
        else
            plot_name=['/data/web/',sites_list(site_ind).sid,'/extra/snr_outliers/',sites_list(site_ind).sid,'_2.png'];
        end
        if(constants.save_plots)
            save_plot(plot_name);
            format_print(sprintf('    Plot Saved to: %s\n',plot_name),100); % Display Site Progress (100)
        else
            format_print('    Plot Not Saved\n',100);                       % Display Site Progress (100)
        end
        
        
    end                                             % Done plotting this type
end






%% Plot 3 Plot Position Data with Outlier Detection
for snr_ind=1:n_types
    if(sites_list(site_ind).snr{snr_ind}.process&&~isempty(sites_list(site_ind).snr{snr_ind}.data))   % Plot this type
        %% Setup Figure
        figure
        fignum = gcf;
        set(gca,'FontSize',format.font_size);
        
        %% Plot Position Data
        plot_neu_positions(site_ind,snr_ind,fignum);
        
        %% Save Plot
        if(constants.demo_mode)
            plot_name=['demo/output/',sites_list(site_ind).sid,'_3.png'];
        else
            plot_name=['/data/web/',sites_list(site_ind).sid,'/extra/snr_outliers/',sites_list(site_ind).sid,'_3.png'];
        end
        if(constants.save_plots)
            save_plot(plot_name);
            format_print(sprintf('    Plot Saved to: %s\n',plot_name),100); % Display Site Progress (100)
        else
            format_print('    Plot Not Saved\n',100);                       % Display Site Progress (100)
        end
        
    end                                             % Done plotting this type
end






%% Close figures
if(constants.close_plots)                           % Close all figures
    close all
end

end % function