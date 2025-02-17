classdef PMDTApp < matlab.apps.AppBase

    % PMDT APP - Minduli Wijayatunga 
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        LeftPanel                       matlab.ui.container.Panel
        OptimizelaunchdateCheckBox      matlab.ui.control.CheckBox
        LaunchDateDatePicker            matlab.ui.control.DatePicker
        LaunchDateDatePickerLabel       matlab.ui.control.Label
        SequenceofDebristobeRemovedLabel  matlab.ui.control.Label
        Debris3DropDown                 matlab.ui.control.DropDown
        Debris3DropDownLabel            matlab.ui.control.Label
        Debris2DropDown                 matlab.ui.control.DropDown
        Debris2DropDownLabel            matlab.ui.control.Label
        Debris1DropDown                 matlab.ui.control.DropDown
        Debris1DropDownLabel            matlab.ui.control.Label
        RDV2DurationdaysEditField       matlab.ui.control.NumericEditField
        RDV2DurationdaysEditFieldLabel  matlab.ui.control.Label
        RDV1DurationdaysEditField       matlab.ui.control.NumericEditField
        RDV1DurationdaysEditFieldLabel  matlab.ui.control.Label
        DownlegtargetaltitudekmEditField  matlab.ui.control.NumericEditField
        DownlegtargetaltitudekmEditFieldLabel  matlab.ui.control.Label
        TrajectoryParametersLabel       matlab.ui.control.Label
        FrontalAreasqmEditField         matlab.ui.control.NumericEditField
        FrontalAreasqmEditFieldLabel    matlab.ui.control.Label
        DragCoefficientEditField        matlab.ui.control.NumericEditField
        DragCoefficientEditFieldLabel   matlab.ui.control.Label
        MasskgEditField                 matlab.ui.control.NumericEditField
        MasskgEditFieldLabel            matlab.ui.control.Label
        ServicerParametersLabel         matlab.ui.control.Label
        SpecificImpulsesEditField       matlab.ui.control.NumericEditField
        SpecificImpulsesEditFieldLabel  matlab.ui.control.Label
        DutyRatio01EditField            matlab.ui.control.NumericEditField
        DutyRatio01EditFieldLabel       matlab.ui.control.Label
        MaxThrustmNEditField            matlab.ui.control.NumericEditField
        MaxThrustmNEditFieldLabel       matlab.ui.control.Label
        ThrustSettingsLabel             matlab.ui.control.Label
        InputsLabel                     matlab.ui.control.Label
        RightPanel                      matlab.ui.container.Panel
        TotalDVmsEditField              matlab.ui.control.EditField
        TotalDVmsEditFieldLabel         matlab.ui.control.Label
        TotalTOFdEditField              matlab.ui.control.EditField
        TotalTOFdEditFieldLabel         matlab.ui.control.Label
        RunPMDTButton                   matlab.ui.control.Button
        TOFlimitdEditField              matlab.ui.control.NumericEditField
        TOFlimitdEditFieldLabel         matlab.ui.control.Label
        DVlimitmsEditField              matlab.ui.control.NumericEditField
        DVlimitmsEditFieldLabel         matlab.ui.control.Label
        TabGroup                        matlab.ui.container.TabGroup
        Leg2Tab                         matlab.ui.container.Tab
        Leg3Tab                         matlab.ui.container.Tab
        Leg4Tab                         matlab.ui.container.Tab
        Leg5Tab                         matlab.ui.container.Tab
        Leg1Tab                         matlab.ui.container.Tab
        UIAxes                          matlab.ui.control.UIAxes
        FuelortimeoptimalButtonGroup    matlab.ui.container.ButtonGroup
        TimeoptimalButton               matlab.ui.control.ToggleButton
        FueloptimalButton               matlab.ui.control.ToggleButton
        UIAxes1
        UIAxes2
        UIAxes3
        UIAxes4
        UIAxes5
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

      


        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {274, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Preliminary Mission Design Tool (PMDT)';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {274, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.BackgroundColor = [1 1 1];
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create InputsLabel
            app.InputsLabel = uilabel(app.LeftPanel);
            app.InputsLabel.HorizontalAlignment = 'center';
            app.InputsLabel.FontWeight = 'bold';
            app.InputsLabel.Position = [116 444 44 22];
            app.InputsLabel.Text = 'Inputs ';

            % Create ThrustSettingsLabel
            app.ThrustSettingsLabel = uilabel(app.LeftPanel);
            app.ThrustSettingsLabel.HorizontalAlignment = 'center';
            app.ThrustSettingsLabel.FontAngle = 'italic';
            app.ThrustSettingsLabel.Position = [12 423 89 22];
            app.ThrustSettingsLabel.Text = 'Thrust Settings ';

            % Create MaxThrustmNEditFieldLabel
            app.MaxThrustmNEditFieldLabel = uilabel(app.LeftPanel);
            app.MaxThrustmNEditFieldLabel.HorizontalAlignment = 'right';
            app.MaxThrustmNEditFieldLabel.Position = [17 401 94 22];
            app.MaxThrustmNEditFieldLabel.Text = 'Max Thrust (mN)';

            % Create MaxThrustmNEditField
            app.MaxThrustmNEditField = uieditfield(app.LeftPanel, 'numeric');
            app.MaxThrustmNEditField.Position = [140 401 78 22];
            app.MaxThrustmNEditField.Value = 60;

            % Create DutyRatio01EditFieldLabel
            app.DutyRatio01EditFieldLabel = uilabel(app.LeftPanel);
            app.DutyRatio01EditFieldLabel.HorizontalAlignment = 'right';
            app.DutyRatio01EditFieldLabel.Position = [17 380 89 22];
            app.DutyRatio01EditFieldLabel.Text = 'Duty Ratio (0-1)';

            % Create DutyRatio01EditField
            app.DutyRatio01EditField = uieditfield(app.LeftPanel, 'numeric');
            app.DutyRatio01EditField.Position = [140 380 78 22];
            app.DutyRatio01EditField.Value = 0.5;

            % Create SpecificImpulsesEditFieldLabel
            app.SpecificImpulsesEditFieldLabel = uilabel(app.LeftPanel);
            app.SpecificImpulsesEditFieldLabel.HorizontalAlignment = 'right';
            app.SpecificImpulsesEditFieldLabel.Position = [17 359 109 22];
            app.SpecificImpulsesEditFieldLabel.Text = 'Specific Impulse (s)';

            % Create SpecificImpulsesEditField
            app.SpecificImpulsesEditField = uieditfield(app.LeftPanel, 'numeric');
            app.SpecificImpulsesEditField.Position = [140 359 78 22];
            app.SpecificImpulsesEditField.Value = 1300;

            % Create ServicerParametersLabel
            app.ServicerParametersLabel = uilabel(app.LeftPanel);
            app.ServicerParametersLabel.HorizontalAlignment = 'center';
            app.ServicerParametersLabel.FontAngle = 'italic';
            app.ServicerParametersLabel.Position = [7 335 113 22];
            app.ServicerParametersLabel.Text = 'Servicer Parameters';

            % Create MasskgEditFieldLabel
            app.MasskgEditFieldLabel = uilabel(app.LeftPanel);
            app.MasskgEditFieldLabel.HorizontalAlignment = 'right';
            app.MasskgEditFieldLabel.Position = [23 315 57 22];
            app.MasskgEditFieldLabel.Text = 'Mass (kg)';

            % Create MasskgEditField
            app.MasskgEditField = uieditfield(app.LeftPanel, 'numeric');
            app.MasskgEditField.Position = [140 315 78 22];
            app.MasskgEditField.Value = 800;

            % Create DragCoefficientEditFieldLabel
            app.DragCoefficientEditFieldLabel = uilabel(app.LeftPanel);
            app.DragCoefficientEditFieldLabel.HorizontalAlignment = 'right';
            app.DragCoefficientEditFieldLabel.Position = [24 294 95 22];
            app.DragCoefficientEditFieldLabel.Text = 'Drag Coefficient ';

            % Create DragCoefficientEditField
            app.DragCoefficientEditField = uieditfield(app.LeftPanel, 'numeric');
            app.DragCoefficientEditField.Position = [140 294 78 22];
            app.DragCoefficientEditField.Value = 2.2;

            % Create FrontalAreasqmEditFieldLabel
            app.FrontalAreasqmEditFieldLabel = uilabel(app.LeftPanel);
            app.FrontalAreasqmEditFieldLabel.HorizontalAlignment = 'right';
            app.FrontalAreasqmEditFieldLabel.Position = [24 273 113 22];
            app.FrontalAreasqmEditFieldLabel.Text = 'Frontal Area  (sq. m)';

            % Create FrontalAreasqmEditField
            app.FrontalAreasqmEditField = uieditfield(app.LeftPanel, 'numeric');
            app.FrontalAreasqmEditField.Position = [140 273 78 22];
            app.FrontalAreasqmEditField.Value = 5;

            % Create TrajectoryParametersLabel
            app.TrajectoryParametersLabel = uilabel(app.LeftPanel);
            app.TrajectoryParametersLabel.HorizontalAlignment = 'center';
            app.TrajectoryParametersLabel.FontAngle = 'italic';
            app.TrajectoryParametersLabel.Position = [7 254 121 22];
            app.TrajectoryParametersLabel.Text = 'Trajectory Parameters';

            % Create DownlegtargetaltitudekmEditFieldLabel
            app.DownlegtargetaltitudekmEditFieldLabel = uilabel(app.LeftPanel);
            app.DownlegtargetaltitudekmEditFieldLabel.HorizontalAlignment = 'right';
            app.DownlegtargetaltitudekmEditFieldLabel.Position = [12 230 159 22];
            app.DownlegtargetaltitudekmEditFieldLabel.Text = 'Down leg target altitude (km)';

            % Create DownlegtargetaltitudekmEditField
            app.DownlegtargetaltitudekmEditField = uieditfield(app.LeftPanel, 'numeric');
            app.DownlegtargetaltitudekmEditField.Position = [191 231 78 22];
            app.DownlegtargetaltitudekmEditField.Value = 350;

            % Create RDV1DurationdaysEditFieldLabel
            app.RDV1DurationdaysEditFieldLabel = uilabel(app.LeftPanel);
            app.RDV1DurationdaysEditFieldLabel.HorizontalAlignment = 'right';
            app.RDV1DurationdaysEditFieldLabel.Position = [15 209 126 22];
            app.RDV1DurationdaysEditFieldLabel.Text = 'RDV 1 Duration (days) ';

            % Create RDV1DurationdaysEditField
            app.RDV1DurationdaysEditField = uieditfield(app.LeftPanel, 'numeric');
            app.RDV1DurationdaysEditField.Position = [191 209 78 22];
            app.RDV1DurationdaysEditField.Value = 45;

            % Create RDV2DurationdaysEditFieldLabel
            app.RDV2DurationdaysEditFieldLabel = uilabel(app.LeftPanel);
            app.RDV2DurationdaysEditFieldLabel.HorizontalAlignment = 'right';
            app.RDV2DurationdaysEditFieldLabel.Position = [15 188 126 22];
            app.RDV2DurationdaysEditFieldLabel.Text = 'RDV 2 Duration (days) ';

            % Create RDV2DurationdaysEditField
            app.RDV2DurationdaysEditField = uieditfield(app.LeftPanel, 'numeric');
            app.RDV2DurationdaysEditField.Position = [191 188 78 22];
            app.RDV2DurationdaysEditField.Value = 30;

            % Create Debris1DropDownLabel
            app.Debris1DropDownLabel = uilabel(app.LeftPanel);
            app.Debris1DropDownLabel.HorizontalAlignment = 'right';
            app.Debris1DropDownLabel.Position = [23 80 50 22];
            app.Debris1DropDownLabel.Text = 'Debris 1';

            % Create Debris1DropDown
            app.Debris1DropDown = uidropdown(app.LeftPanel);
            app.Debris1DropDown.Items = {'H2AF15', 'ALOS2', 'GOSAT'};
            app.Debris1DropDown.Position = [88 80 100 22];
            app.Debris1DropDown.Value = 'H2AF15';

            % Create Debris2DropDownLabel
            app.Debris2DropDownLabel = uilabel(app.LeftPanel);
            app.Debris2DropDownLabel.HorizontalAlignment = 'right';
            app.Debris2DropDownLabel.Position = [23 50 50 22];
            app.Debris2DropDownLabel.Text = 'Debris 2';

            % Create Debris2DropDown
            app.Debris2DropDown = uidropdown(app.LeftPanel);
            app.Debris2DropDown.Items = {'H2AF15', 'ALOS2', 'GOSAT'};
            app.Debris2DropDown.Position = [88 50 100 22];
            app.Debris2DropDown.Value = 'ALOS2';

            % Create Debris3DropDownLabel
            app.Debris3DropDownLabel = uilabel(app.LeftPanel);
            app.Debris3DropDownLabel.HorizontalAlignment = 'right';
            app.Debris3DropDownLabel.Position = [23 21 50 22];
            app.Debris3DropDownLabel.Text = 'Debris 3';

            % Create Debris3DropDown
            app.Debris3DropDown = uidropdown(app.LeftPanel);
            app.Debris3DropDown.Items = {'H2AF15', 'ALOS2', 'GOSAT'};
            app.Debris3DropDown.Position = [88 21 100 22];
            app.Debris3DropDown.Value = 'GOSAT';

            % Create SequenceofDebristobeRemovedLabel
            app.SequenceofDebristobeRemovedLabel = uilabel(app.LeftPanel);
            app.SequenceofDebristobeRemovedLabel.HorizontalAlignment = 'center';
            app.SequenceofDebristobeRemovedLabel.FontAngle = 'italic';
            app.SequenceofDebristobeRemovedLabel.Position = [12 109 200 22];
            app.SequenceofDebristobeRemovedLabel.Text = 'Sequence of Debris to be removed ';

            % Create LaunchDateDatePickerLabel
            app.LaunchDateDatePickerLabel = uilabel(app.LeftPanel);
            app.LaunchDateDatePickerLabel.HorizontalAlignment = 'right';
            app.LaunchDateDatePickerLabel.Position = [15 165 73 22];
            app.LaunchDateDatePickerLabel.Text = 'Launch Date';
           
            % Create LaunchDateDatePicker
            app.LaunchDateDatePicker = uidatepicker(app.LeftPanel);
            app.LaunchDateDatePicker.Position = [159 165 110 22];
            app.LaunchDateDatePicker.Value = datetime(2022, 03, 25, 6, 37, 13);

            % % Create OptimizelaunchdateCheckBox
            % app.OptimizelaunchdateCheckBox = uicheckbox(app.LeftPanel);
            % app.OptimizelaunchdateCheckBox.Text = 'Optimize launch date?';
            % app.OptimizelaunchdateCheckBox.Position = [21 144 142 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.BackgroundColor = [1 1 1];
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create FuelortimeoptimalButtonGroup
            app.FuelortimeoptimalButtonGroup = uibuttongroup(app.RightPanel);
            app.FuelortimeoptimalButtonGroup.TitlePosition = 'centertop';
            app.FuelortimeoptimalButtonGroup.Title = 'Fuel or time optimal ? ';
            app.FuelortimeoptimalButtonGroup.Position = [11 380 135 82];

            % Create FueloptimalButton
            app.FueloptimalButton = uitogglebutton(app.FuelortimeoptimalButtonGroup);
            app.FueloptimalButton.Text = 'Fuel optimal';
            app.FueloptimalButton.Position = [18 30 100 23];
            app.FueloptimalButton.Value = true;

            % Create TimeoptimalButton
            app.TimeoptimalButton = uitogglebutton(app.FuelortimeoptimalButtonGroup);
            app.TimeoptimalButton.Text = 'Time optimal ';
            app.TimeoptimalButton.Position = [18 8 100 23];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.RightPanel);
            app.TabGroup.Position = [16 9 330 257];

            % Create Leg1Tab
            app.Leg1Tab = uitab(app.TabGroup);
            app.Leg1Tab.Title = 'Leg 1';

         

            % Create Leg2Tab
            app.Leg2Tab = uitab(app.TabGroup);
            app.Leg2Tab.Title = 'Leg 2';

            % Create Leg3Tab
            app.Leg3Tab = uitab(app.TabGroup);
            app.Leg3Tab.Title = 'Leg 3';

            % Create Leg4Tab
            app.Leg4Tab = uitab(app.TabGroup);
            app.Leg4Tab.Title = 'Leg 4';

            % Create Leg5Tab
            app.Leg5Tab = uitab(app.TabGroup);
            app.Leg5Tab.Title = 'Leg 5';

               % Create UIAxes


            % Create DVlimitmsEditFieldLabel
            app.DVlimitmsEditFieldLabel = uilabel(app.RightPanel);
            app.DVlimitmsEditFieldLabel.HorizontalAlignment = 'right';
            app.DVlimitmsEditFieldLabel.Position = [164 433 76 22];
            app.DVlimitmsEditFieldLabel.Text = '$\Delta v$ limit (m/s)';
            app.DVlimitmsEditFieldLabel.Interpreter = 'latex'; 


            % Create DVlimitmsEditField
            app.DVlimitmsEditField = uieditfield(app.RightPanel, 'numeric');
            app.DVlimitmsEditField.Position = [254 433 100 22];
            app.DVlimitmsEditField.Value = 1500;

            % Create TOFlimitdEditFieldLabel
            app.TOFlimitdEditFieldLabel = uilabel(app.RightPanel);
            app.TOFlimitdEditFieldLabel.HorizontalAlignment = 'right';
            app.TOFlimitdEditFieldLabel.Position = [170 410 70 22];
            app.TOFlimitdEditFieldLabel.Text = 'TOF limit (d)';

            % Create TOFlimitdEditField
            app.TOFlimitdEditField = uieditfield(app.RightPanel, 'numeric');
            app.TOFlimitdEditField.Position = [254 410 100 22];
            app.TOFlimitdEditField.Value = 1825;

            % Create RunPMDTButton
            app.RunPMDTButton = uibutton(app.RightPanel, 'push');
            app.RunPMDTButton.BackgroundColor = [0.302 0.7451 0.9333];
            app.RunPMDTButton.Position = [141 348 84 22];
            app.RunPMDTButton.ButtonPushedFcn =  @app.runOptimization;
            app.RunPMDTButton.Text = 'Run PMDT';

            % Create TotalTOFdEditFieldLabel
            app.TotalTOFdEditFieldLabel = uilabel(app.RightPanel);
            app.TotalTOFdEditFieldLabel.HorizontalAlignment = 'right';
            app.TotalTOFdEditFieldLabel.Position = [42 312 73 22];
            app.TotalTOFdEditFieldLabel.Text = 'Total TOF (d)';
            

            % Create TotalTOFdEditField
            app.TotalTOFdEditField = uieditfield(app.RightPanel, 'text');
            app.TotalTOFdEditField.Position = [130 310 125 26];
            app.TotalTOFdEditField.Editable = 'off'; 


            % Create TotalDVmsEditFieldLabel
            app.TotalDVmsEditFieldLabel = uilabel(app.RightPanel);
            app.TotalDVmsEditFieldLabel.HorizontalAlignment = 'right';
            app.TotalDVmsEditFieldLabel.Position = [36 287 79 22];
            app.TotalDVmsEditFieldLabel.Text = 'Total $\Delta v$ (m/s)';
            app.TotalDVmsEditFieldLabel.Interpreter = 'latex'; 

            % Create TotalDVmsEditField
            app.TotalDVmsEditField = uieditfield(app.RightPanel, 'text');
            app.TotalDVmsEditField.Position = [130 285 125 26];
            app.TotalDVmsEditField.Editable = 'off'; 

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        function runOptimization(app, ~, ~)
            addpath('SGP4routines_NAIF');
            addpath('CoordinateConversions/')
            addpath('Pertubations/')
            addpath('Data/')
            addpath('PMDT/')
            addpath('/Users/minduli/mice/src/mice/')
            addpath('/Users/minduli/mice/lib')
            cspice_furnsh('SGP4routines_NAIF/kernel.txt')
            constants;

            debrisID = {'H2AF15', 'ALOS2', 'GOSAT'};
            allPermutations = perms(debrisID);
            % 
            param.m_wet_servicer =(app.MasskgEditField.Value);
            param.T = (app.MaxThrustmNEditField.Value)/1e3;
            param.Isp = (app.SpecificImpulsesEditField.Value);
            param.target_altitude = (app.DownlegtargetaltitudekmEditField.Value)*1e3;
            param.dvLimit = (app.DVlimitmsEditField.Value);
            param.t0 = juliandate(app.LaunchDateDatePicker.Value);
            
            param.a_pchangeLimit = 0.01;
            param.dutyRatio = (app.DutyRatio01EditField.Value);
            param.Cd =  app.DragCoefficientEditField.Value;
            param.Area =  app.FrontalAreasqmEditField.Value;
            param.RDV1 = app.RDV1DurationdaysEditField.Value* param.TU;
            param.RDV2 =app.RDV2DurationdaysEditField.Value* param.TU;
            param.waitTimeLimit = app.TOFlimitdEditField.Value;
    
            param.Topt =  app.TimeoptimalButton.Value;
            param.optimt0 = 0 ; %app.OptimizelaunchdateCheckBox.Value;
            param.krange = -20:1:20;
            param.dragfactor = 1;
            param.eclipses = false; 
            param.drag = false; 

            param.plots = false; % generate plots?
            param.eclipses = false; % consider eclipses?
            param.drag = false; % consider drag?


            param.debrisID = {app.Debris1DropDown.Value,app.Debris2DropDown.Value,app.Debris3DropDown.Value};
            [~, ub, lb] = getInitGuess(param);

            x0 = [7668.55873489256, 1.73887318895310, 7459.17412371716, 1.70295207272273];

            options = optimoptions('fmincon', 'Display', 'iter');

            param.t0 = juliandate(datetime(2022, 03, 25, 6, 37, 13));

            app.RunPMDTButton.Text = 'Running PMDT...';   % Change text
            app.RunPMDTButton.BackgroundColor = [1, 0, 0]; % Red background
            app.RunPMDTButton.Enable = 'off';             % Disable button to prevent multiple clicks
            drawnow;  % Force UI update

            try
                % Run the optimization
                [debrisData, fval] = fmincon(@(x) PMDT(x, debrisID, param), x0, ...
                    [], [], [], [], lb, ub, @(x) PMDT_limits(x, debrisID, param), options);
            catch ME
                % If an error occurs, restore button and rethrow the error
                app.RunPMDTButton.Text = 'Run PMDT';
                app.RunPMDTButton.BackgroundColor = [0.94, 0.94, 0.94]; % Default MATLAB button color
                app.RunPMDTButton.Enable = 'on';
                rethrow(ME);
            end

            % Restore the button appearance after execution
            app.RunPMDTButton.Text = 'Run PMDT';   % Reset text
            app.RunPMDTButton.BackgroundColor = [0.94, 0.94, 0.94]; % Default MATLAB button color
            app.RunPMDTButton.Enable = 'on';       % Enable button again
            drawnow;
            param.eclipses = true;
            param.drag = true;
            param.plots = true;
            param.refinement = true;
            param.guidance = false;
            param.gtype = 1;
            
            [result, RAANs, Total_TOF, Total_dV, fuelconsump] = PMDTAppPlot(app,debrisData, debrisID, param);

            app.TotalDVmsEditField.Value = num2str(Total_dV);
            app.TotalTOFdEditField.Value = num2str(Total_TOF);
            
            % resultText = sprintf('Total Time of Flight: %.2f days\nTotal Delta-V: %.2f km/s\nFuel Consumption: %.2f kg', Total_TOF, Total_dV, fuelconsump);
            %  app.ResultsTextArea.Value = resultText;
          end

        % Construct app
        function app = PMDTApp

            % Create UIFigure and components
            createComponents(app) 

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end