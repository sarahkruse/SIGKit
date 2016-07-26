function PicksUI(varargin)
%Use this function to set the gain on the waveform figures and control when picking begins.
   
Tmin =varargin{1};
Tmax = varargin{2};
ax = varargin{3};

%create the pick activation button

btn = uicontrol('Style', 'pushbutton', 'String', 'Make Pick', 'Position',...
   [950 100 75 20], 'Callback', 'btn_gcbf = gcbf;  btn_gcbf.Name = num2str(rand(1));');

    
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

end
