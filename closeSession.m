%% Closes session by displaying ending message and closing Psychtoolbox screens
%  Created by - Shalini Purwar (purwar@ece.neu.edu)

function [success] = closeSession(PTBstruct,PTBoldLevels)
txt.font = 'Monospaced'; txt.size = 40; txt.style = 0; % 0 = Normal / 1 = Bold / 2 = Italics
color = [255 255 255];
Screen('TextSize',PTBstruct.handle,txt.size);
Screen('TextFont',PTBstruct.handle,txt.font);
Screen('TextStyle',PTBstruct.handle,txt.style);
saveStimilus=0;
try
    DrawFormattedText(PTBstruct.handle ,'Session finished !','center','center',color);
    Screen('Flip',PTBstruct.handle);
    if(saveStimilus)
    imageArray = Screen('GetImage', PTBstruct.handle);
    imwrite(imageArray, 'SessionEnd.jpg');
    end
    pause(1);
    sca;
    % Restore PTB defaults
    Screen('Preference', 'VisualDebuglevel', PTBoldLevels.visualDebuglevel);
    Screen('Preference', 'Verbosity', [PTBoldLevels.verbosity]);
    ShowCursor;
    
    % Close Window
%     Screen('CloseAll');
    success = 1;
catch
    success = 0;
end
