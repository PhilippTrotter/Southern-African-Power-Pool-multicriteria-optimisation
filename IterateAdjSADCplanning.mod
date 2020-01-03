/*********************************************
 * OPL 12.7.0.0 Model
 * Author: pt428
 * Creation Date: 15 Feb 2017 at 10:09:09
 *********************************************/



main {
  var source = new IloOplModelSource("adjSADCplanningLap.mod");
  var cplex = new IloCplex();
  var def = new IloOplModelDefinition(source);
  var opl = new IloOplModel(def,cplex);
  var data = new IloOplDataSource("adjSADCplanningLap.dat");
  var result = new IloOplOutputFile("resultPR85.csv");
  
  var i = 0;
  
  for(var EmissInd=1;EmissInd>-0.00001;EmissInd=EmissInd-(1/20))
  	{
  	for(var PolSovInd=0;PolSovInd<1.00001;PolSovInd=PolSovInd+(1/20))
  		{
	  		var opl = new IloOplModel(def,cplex);
	     	i = i + 1;
	 		var data2 = new IloOplDataElements();
	  		data2.maxEmissions = EmissInd;
			data2.minPolSov = PolSovInd;
			data2.indexPoint = i;
			opl.addDataSource(data);
	  		opl.addDataSource(data2);
	 
	  		opl.generate();
	
	  		if (cplex.solve()) {
	     		opl.postProcess();
	     		result.writeln(EmissInd + ";" + PolSovInd + ";" + cplex.getObjValue());
	  		} else {
	     		writeln("No solution");
	  		}
			data2.end();
	 		opl.end();
 		}
	}  
 
}