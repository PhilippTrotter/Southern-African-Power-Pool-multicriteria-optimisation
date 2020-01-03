cd('C:/Users/pt428/Desktop/PhD/01 Papers/SADC/adjSADCplanningLap')
set(0,'DefaultTextFontname','Times New Roman')

importResult = dataset('File','IngaCapResultPR100.csv','Delimiter',',','ReadVarNames',false);
Result = double(importResult(:,1))

ResultReshape = reshape(Result,[21,21]);


em = 1:21;
em = em / 20 - (1/20);
em = (1 - em) * 100; 
polSov = 1:21;
polSov = (polSov / 20 - (1/20)) * 100;

xlabelstring = sprintf('Allowed CO2 emissions\n[%% of per country maximum]');
ylabelstring = sprintf('Required electricity sovereignty\n[%% of per country demand]');
zlabelstring = sprintf('Optimal required Grand Inga capacity\n[GW]');


DomShare = surf(em, polSov, ResultReshape)
view(131,18)
set(gca,'fontsize',13)

xhandle=xlabel(xlabelstring);
set(xhandle,'Fontname','Times New Roman');
%xlabh = get(gca,'XLabel');
%set(xlabh,'Position',get(xlabh,'Position') + [0 0 0.2]);

yhandle=ylabel(ylabelstring);
set(yhandle,'Fontname','Times New Roman');
%ylabh = get(gca,'YLabel');
%set(ylabh,'Position',get(ylabh,'Position') + [20 5 -0.5]);

zhandle=zlabel(zlabelstring);
set(zhandle,'Fontname','Times New Roman');
set(gca,'Fontname','Times New Roman'); 

axis([-inf,+inf,-inf,+inf,0,40]);
print('GrandIngaCap', '-dpng', '-r600');