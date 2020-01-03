/*********************************************
 * OPL 12.6.3.0 Model
 * Author: pt428
 * Creation Date: 25 Oct 2016 at 13:52:31
 *********************************************/

 

//Define sets
{string} StartCountry = ...;
{string} TerminateCountry = ...;
{string} RunStartCountry = ...;
{string} RunTerminateCountry = ...;

//{string} Technology = ...;

range RunStartXRunTerminate = 1..784;
range StartXTerminateXRunStartXRunTerminate = 1..614656;


//Define parameters to be populated through Excel data
float transcostEx[RunStartXRunTerminate] = ...;
float neighbourEx[StartXTerminateXRunStartXRunTerminate] = ...;


//Convert Excel data to multi-dimensional CPLEX data
//cost
float transcost[RunStartCountry][RunTerminateCountry];
int i = 1;
execute {
	for (var rs in RunStartCountry) {
		for (var rt in RunTerminateCountry) {
			transcost[rs][rt] = transcostEx[i];
			i = i + 1; 
			}
	}
}	

//Neighbouring countries
float neighbour[StartCountry][TerminateCountry][RunStartCountry][RunTerminateCountry];
int k = 1;
execute {
	for (var s in StartCountry) {
		for (var t in TerminateCountry) {
			for (var rs in RunStartCountry) {
				for (var rt in RunTerminateCountry) {		
					neighbour[s][t][rs][rt] = neighbourEx[k];
					k = k + 1; 
 				}			
			}
		}			
	}
}	


//Define decision variable
dvar float+ x_bin[StartCountry][TerminateCountry][RunStartCountry][RunTerminateCountry];



//Calculate adjusted parameters and variables
dexpr float Objcost = sum (s in StartCountry, t in TerminateCountry, rs in RunStartCountry, rt in RunTerminateCountry) x_bin[s][t][rs][rt] * transcost[rs][rt];
  

//Solve  
minimize Objcost;
  


//Define constraints 
subject to {
	
	//Shortest path constraint implementation
	forall(s in StartCountry, t in TerminateCountry : t != s)
	cSP1: (sum(rt in RunTerminateCountry) x_bin[s][t][s][rt]) - (sum(rt in RunTerminateCountry) x_bin[s][t][rt][s]) == 1;
	
	forall(s in StartCountry, t in TerminateCountry, rs in RunStartCountry : rs != s && rs != t)
	cSP2: (sum(rt in RunTerminateCountry) x_bin[s][t][rs][rt]) - (sum(rt in RunTerminateCountry) x_bin[s][t][rt][rs]) == 0;
	
	forall(s in StartCountry, t in TerminateCountry : t != s)
	cSP3: (sum(rt in RunTerminateCountry) x_bin[s][t][t][rt]) - (sum(rt in RunTerminateCountry) x_bin[s][t][rt][t]) == -1;
  
  	
  	forall(s in StartCountry, t in TerminateCountry, rs in RunStartCountry, rt in RunTerminateCountry : rt == s && rt == t && rt == rs)
  	cCircle: x_bin[s][t][rs][rt] == 1; 
  	
  	//Multiple shortest path mapping 
  	//forall(s in StartCountry, t in TerminateCountry, rs in RunStartCountry : rs != , rt in RunTerminateCountry)
  	//cMapping1: x_bin[s][d][rs][rt] == 0;  
  	
  	//forall(s in StartCountry, d in DashStartCountry, b in BarTerminateCountry, t in TerminateCountry : t != b)
  	//cMapping2: x_bin[s][d][b][t] == 0;  
  	
  	//Define neighbouring countries
  	forall(s in StartCountry, t in TerminateCountry, rs in RunStartCountry, rt in RunTerminateCountry)
  	cNeighbour: x_bin[s][t][rs][rt] <= neighbour[s][t][rs][rt];
  	
/*
  // Satisfy demand in all countries during all time periods
  forall(d in DemandCountry, y in Year)
    ctDemand: sum(s in SupplyCountry, t in Technology) quantity[s][d][t][y]
           >= demand[d][y];


 // Dont exceed supply, assuming 25% more of maximal Potential can be brought online within 5 years
  forall(s in SupplyCountry, t in Technology, y in Year)
    ctSupply: sum(d in DemandCountry) quantity[s][d][t][y]
            <= maxPotSupply[s][t][y];       


  // Use infrastructure built in former time periods
  forall(s in SupplyCountry, t in Technology)
    ctInfrastructure1: sum(d in DemandCountry) quantity[s][d][t]["2020"]
    		>= sum(d in DemandCountry) quantity[s][d][t]["2015"];     
           
  forall(s in SupplyCountry, t in Technology)
    ctInfrastructure2: sum(d in DemandCountry) quantity[s][d][t]["2025"]
    		>= sum(d in DemandCountry) quantity[s][d][t]["2020"];    
  
  forall(s in SupplyCountry, t in Technology)
    ctInfrastructure3: sum(d in DemandCountry) quantity[s][d][t]["2030"]
    		>= sum(d in DemandCountry) quantity[s][d][t]["2025"]; 
*/           
}




//Post estimation calculations for data export to Excel
float x_binLong[StartXTerminateXRunStartXRunTerminate];
int p = 1;
execute {
	for (var s in StartCountry) {
		for (var t in TerminateCountry) {
			for (var rs in RunStartCountry) {
				for (var rt in RunTerminateCountry) {			
				x_binLong[p] = x_bin[s][t][rs][rt];
				p = p + 1; 
  				}				
			}		
		}
	}
}	

/*
float supplyLong[SupplyXDemandXTechnologyXYear];
int q = 1;
execute {
	for (var s in SupplyCountry) {
		for (var d in DemandCountry) {
			for (var t in Technology) {
				for (var y in Year) {			
				supplyLong[q] = maxPotSupply[s][t][y];
				q = q + 1; 
  				}				
			}		
		}
	}
}


float PR3InstitutionalIssuesSC2030[SupplyCountry];
float PR4InstabilitySC2030[SupplyCountry];
float PR5CorruptionSC2030[SupplyCountry];
float PR6LandAccessSC2030[SupplyCountry];
execute {
	for (var s in SupplyCountry) {
	PR3InstitutionalIssuesSC2030[s] = PR3InstitutionalIssuesSC[s]["2030"];
	PR4InstabilitySC2030[s] = PR4InstabilitySC[s]["2030"];
	PR5CorruptionSC2030[s] = PR5CorruptionSC[s]["2030"];  
	PR6LandAccessSC2030[s] = PR6LandAccessSC[s]["2030"]; 
	}
}
*/