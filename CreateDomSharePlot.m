cd('X:\MechEng\ResearchProjects\MCMcManus\EB-ME1243\03 Papers\12 Uganda elec planning\Analyses_II\UgandaOpt')
set(0,'DefaultTextFontname','Times New Roman')

importResult = dataset('File','DomShareResultPR100.csv','Delimiter',',','ReadVarNames',false);
Result = double(importResult(:,1))

ResultReshape = reshape(Result,[21,21]);
%ResultReshape = 100 - ResultReshape;

em = 1:21;
em = em / 20 - (1/20);
em = (1 - em) * 100; 
polSov = 1:21;
polSov = (polSov / 20 - (1/20)) * 100;

xlabelstring = sprintf('Allowed CO2 emissions\n[%% of per country maximum]');
ylabelstring = sprintf('Required electricity sovereignty\n[%% of per country demand]');
zlabelstring = sprintf('Optimal domestic generation\n[%% of total generation]');


DomShare = surf(em, polSov, ResultReshape)
view(46,13)
set(gca,'fontsize',13)

xhandle=xlabel(xlabelstring);
set(xhandle,'Fontname','Times New Roman');
xlabh = get(gca,'XLabel');
%set(xlabh,'Position',get(xlabh,'Position') + [0 0 0.2]);

yhandle=ylabel(ylabelstring);
set(yhandle,'Fontname','Times New Roman');
ylabh = get(gca,'YLabel');
%set(ylabh,'Position',get(ylabh,'Position') + [20 5 -0.5]);

zhandle=zlabel(zlabelstring);
set(zhandle,'Fontname','Times New Roman');
set(gca,'Fontname','Times New Roman');

print('DomShare2', '-dpng', '-r600');