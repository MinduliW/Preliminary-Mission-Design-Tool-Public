% Function turns the figure background white, increases font sizes, and
% allows mathematical formulae be inputted as figure titles. 
% (Makes figures appropriate for a Latex report)
function plot_latex(plt, xtitle, ytitle,ztitle, tl ,str)
% set the plot legend 
if isempty(str) == false 
    lgd = legend(str, 'Interpreter','latex','Orientation', 'horizontal'); 
    lgd.FontSize = 12;
end 

% set x label, y label and title of the graph, as interpreted using latex 
xlabel(xtitle,'fontsize',12,'Interpreter','latex');
ylabel(ytitle,'fontsize',12,'Interpreter','latex');
zlabel(ztitle,'fontsize',12,'Interpreter','latex');
title(tl,'fontsize',12,'Interpreter','latex');

% sets the fontsize of the values on the axes.
set(gca,'fontsize',12)

% the default matlab plot background is grey, this turns it to white 
set(gcf,'color','w');


% increase the width of lines plotted on the graph
% set(plt , 'linewidth',2);
set(findall(gca, 'Type', 'Line'),'LineWidth',3);


grid off;
box on;


% fullscreen 
% figure('units','normalized','outerposition',[0 0 1 1])

end 
