cd('X:\MechEng\ResearchProjects\MCMcManus\EB-ME1243\03 Papers\12 Uganda elec planning\Analyses_II\UgandaOpt')
set(0,'DefaultTextFontname','Times New Roman')

importResult = dataset('File','resultUgandaOptElecGoal.csv','Delimiter',';','ReadVarNames',false);
UrbRurInd = double(importResult(:,1));
RegionalInd = double(importResult(:,2));
ResultImp = double(importResult(:,3))/1000000000;
Result = ResultImp / min(ResultImp) * 100;

ResultReshape = reshape(Result,[11,11]);

urbrur = 1:11;
urbrur = urbrur / 10 - (1/10);
 
regional = 1:11;
regional = regional / 10 - (1/10);


xlabelstring = sprintf('Urban-rural energy equality\n[%%]');
ylabelstring = sprintf('Sub-national energy equality\n[%%]');
zlabelstring = sprintf('Percent of total system cost\n[%%]');


ParetoFront = surf(urbrur, regional, ResultReshape)
view(306,13)
set(gca,'fontsize',13)

xhandle=xlabel(xlabelstring);
set(xhandle,'Fontname','Times New Roman');

yhandle=ylabel(ylabelstring);
set(yhandle,'Fontname','Times New Roman');
%ylabh = get(gca,'YLabel');
%set(ylabh,'Position',get(ylabh,'Position') + [0 0 0]);

zhandle=zlabel(zlabelstring);
set(zhandle,'Fontname','Times New Roman');
set(gca,'Fontname','Times New Roman');


print('ParetoScenMed', '-dpng', '-r600');