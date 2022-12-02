function saveImage(saveName, fig, type)
% function for saving figure 
%
% explorted figure can be a jpeg, png, tiff, pdf, fig, or svg
%
% saveImage(saveName, fig, type)
% saveName = [array] name and path of saved image
% fig = [figure handle] figure to be saved
% type = [double] type of file to save as

% create the fileName from SaveName
idx = find(saveName == '\');
if isempty(idx) % catch for Macs
    idx = find(saveName == '/');
end
if isempty(idx) % catch
    idx = 1;
end
fn = saveName(idx(end)+1:end-4);

% have to do some reformating to save
scrsiz = get(0,'ScreenSize');
f = figure('visible','off');
copiedAxes = copyobj(fig, f);
title(strrep(fn, '_', '-'))
f.Children.Position = [25, 25, f.Children.Position(3), f.Children.Position(4)];
f.Position = [round(scrsiz(3)/2 - (f.Children.Position(3)+50)/2),...
    round(scrsiz(4)/2 - (f.Children.Position(4)+50)/2),...
    f.Children.Position(3)+50, f.Children.Position(4)+50];

% based on type of figure to save, save appropriately
if strcmp(type, '*.fig')% matlab figure
    savefig(f, saveName)
else % png, jpg, tif, pdf, svg
    saveas(f, saveName, type(3:end))
end

close(f)

return