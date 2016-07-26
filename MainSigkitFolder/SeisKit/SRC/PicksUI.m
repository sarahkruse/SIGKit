function Keep = PicksUI(varargin)
%Use this function to set the gain on the waveform figures and control when picking begins.
   
Tmin =varargin{1};
Tmax = varargin{2};
ax = varargin{3};
Keep=0;
%create the pick activation button

btn = uicontrol('Style', 'pushbutton', 'String', 'Change Pick', 'Position',...
   [950 100 75 20], 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(rand(1));');

%create a button for keeping pick
btn2 = uicontrol('Style', 'pushbutton', 'String', 'Keep Pick', 'Position',...
   [850 100 75 20], 'ButtonDownFcn', @keeppick);

% btn2 = uicontrol('Style', 'togglebutton', 'String', 'Keep Pick', 'Position',...
%    [850 100 75 20], 'Value',0,'Callback', @keeppick);

    
   % Create slider to adjust gain
    sld = uicontrol('Style', 'slider',...
        'Min',Tmin,'Max',Tmax,'Value',0,...
        'Position',[180 100 120 20],...
        'Callback', @plotylim); 
					
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[180 112 120 20],...
        'String','Gain');
    
    % Make figure visble after adding all components
    f.Visible = 'on';
    % This code uses dot notation to set properties. 
    % Dot notation runs in R2014b and later.
    % For R2014a and earlier: set(f,'Visible','on');
    

    function plotylim(source,callbackdata)
        val = 1- source.Value;

        ylim(ax,[-val val]);
    end

    function keeppick(source,callbackdata)
        display('Keeping original pick');
                  Keep = Keep + 1;
    end
end
