/*********************************************
 * OPL 12.6.3.0 Model
 * Author: pt428
 * Creation Date: 1 Mar 2017 at 06:47:06
 *********************************************/

 /*********************************************
 * OPL 12.7.0.0 Model
 * Author: pt428
 * Creation Date: 3 Feb 2017 at 10:32:25
 *********************************************/

 
//Define sets
{string} SupplyCountry = ...;
{string} Technology = ...;
{string} DemandCountry = ...;
{string} Year = ...;

range SupplyXTechnology = 1..72;
range DemandXYear = 1..240;
range TechnologyRange = 1..6;
range YearRange = 1..20;
range SupplyXTechnologyXDemand = 1..864;
range SupplyXTechnologyXYear = 1..1440;
range SupplyXTechnologyXDemandXYear = 1..17280;
range SupplyXTechnologyXDemandXYearDash = 1..14400;

float maxPotential2030 = ...;
float fossilRestriction = ...;
float minPolSov = ...;
float maxEmissions = ...;

int indexPoint = ...;

//Define parameters to be populated through Excel data
float supplyInput[SupplyXTechnology] = ...;
float demandInput[DemandXYear] = ...;
float gencostInput[SupplyXTechnologyXYear] = ...;
float transcostInput[SupplyXTechnologyXDemand] = ...;
float demandTotalInput[YearRange] = ...;
float CO2EmissionsInput[TechnologyRange] = ...;


//Convert Excel data to multi-dimensional CPLEX data
//Supply
float supply[SupplyCountry][Technology];
int i = 1;
execute {
	for (var s in SupplyCountry) {
		for (var t in Technology) {
				supply[s][t] = supplyInput[i];
				i = i + 1; 		
		}
	}
}	


//Demand
float demand[DemandCountry][Year];
int j = 1;
execute {
	for (var d in DemandCountry) {
		for (var y in Year) {	
			demand[d][y] = demandInput[j];
			j = j + 1;
  		}				 		
	}
}
	

float demandTotal[Year];
int t = 1;
execute {
	for (var y in Year) {	
		demandTotal[y] = demandTotalInput[t];
		t = t + 1;
  	}				 		
}
	


	
//Cost data
float gencost[SupplyCountry][Technology][Year];
int k = 1;
execute {
	for (var s in SupplyCountry) {
		for (var t in Technology) {
			for (var y in Year) {		
			gencost[s][t][y] = gencostInput[k];
			k = k + 1; 				
			}	
 		}				
	}
}	


float transcost[SupplyCountry][Technology][DemandCountry];
int l = 1;
execute {
	for (var s in SupplyCountry) {
		for (var t in Technology) {
			for (var d in DemandCountry) {		
				transcost[s][t][d] = transcostInput[l];
				l = l + 1; 				
			}		
		}
	}
}	



//CO2Emissions
float CO2Emissions[Technology];
int n = 1;
execute {
	for (var t in Technology) {
			CO2Emissions[t] = CO2EmissionsInput[n];
			n = n + 1; 		
	}
}


//Impose restriction on maximum supply for all years
float maxPotSupply[SupplyCountry][Technology];
execute {
	for (var s in SupplyCountry) {
		for (var t in Technology) {
			if(t == "Coal" || t == "Oil"){		
			maxPotSupply[s][t] = supply[s][t] * maxPotential2030 * fossilRestriction; 		
			} else {
			maxPotSupply[s][t] = supply[s][t] * maxPotential2030;
			}
		}		
	}
}




//Define decision variable
dvar float+ quantity[SupplyCountry][Technology][DemandCountry][Year];


//Calculate adjusted parameters and variables
dexpr float generationCost = 
	sum (s in SupplyCountry, t in Technology) (
	(20 * gencost[s][t]["2011"] *  (sum(d in DemandCountry) quantity[s][t][d]["2011"])) + 
	(19 * gencost[s][t]["2012"] * ((sum(d in DemandCountry) quantity[s][t][d]["2012"]) - (sum(d in DemandCountry) quantity[s][t][d]["2011"]))) + 
	(18 * gencost[s][t]["2013"] * ((sum(d in DemandCountry) quantity[s][t][d]["2013"]) - (sum(d in DemandCountry) quantity[s][t][d]["2012"]))) +
	(17 * gencost[s][t]["2014"] * ((sum(d in DemandCountry) quantity[s][t][d]["2014"]) - (sum(d in DemandCountry) quantity[s][t][d]["2013"]))) +
	(16 * gencost[s][t]["2015"] * ((sum(d in DemandCountry) quantity[s][t][d]["2015"]) - (sum(d in DemandCountry) quantity[s][t][d]["2014"]))) +
	(15 * gencost[s][t]["2016"] * ((sum(d in DemandCountry) quantity[s][t][d]["2016"]) - (sum(d in DemandCountry) quantity[s][t][d]["2015"]))) +
	(14 * gencost[s][t]["2017"] * ((sum(d in DemandCountry) quantity[s][t][d]["2017"]) - (sum(d in DemandCountry) quantity[s][t][d]["2016"]))) +
	(13 * gencost[s][t]["2018"] * ((sum(d in DemandCountry) quantity[s][t][d]["2018"]) - (sum(d in DemandCountry) quantity[s][t][d]["2017"]))) +
	(12 * gencost[s][t]["2019"] * ((sum(d in DemandCountry) quantity[s][t][d]["2019"]) - (sum(d in DemandCountry) quantity[s][t][d]["2018"]))) +
	(11 * gencost[s][t]["2020"] * ((sum(d in DemandCountry) quantity[s][t][d]["2020"]) - (sum(d in DemandCountry) quantity[s][t][d]["2019"]))) +
	(10 * gencost[s][t]["2021"] * ((sum(d in DemandCountry) quantity[s][t][d]["2021"]) - (sum(d in DemandCountry) quantity[s][t][d]["2020"]))) +
	( 9 * gencost[s][t]["2022"] * ((sum(d in DemandCountry) quantity[s][t][d]["2022"]) - (sum(d in DemandCountry) quantity[s][t][d]["2021"]))) +
	( 8 * gencost[s][t]["2023"] * ((sum(d in DemandCountry) quantity[s][t][d]["2023"]) - (sum(d in DemandCountry) quantity[s][t][d]["2022"]))) +
	( 7 * gencost[s][t]["2024"] * ((sum(d in DemandCountry) quantity[s][t][d]["2024"]) - (sum(d in DemandCountry) quantity[s][t][d]["2023"]))) +
	( 6 * gencost[s][t]["2025"] * ((sum(d in DemandCountry) quantity[s][t][d]["2025"]) - (sum(d in DemandCountry) quantity[s][t][d]["2024"]))) +
	( 5 * gencost[s][t]["2026"] * ((sum(d in DemandCountry) quantity[s][t][d]["2026"]) - (sum(d in DemandCountry) quantity[s][t][d]["2025"]))) +
	( 4 * gencost[s][t]["2027"] * ((sum(d in DemandCountry) quantity[s][t][d]["2027"]) - (sum(d in DemandCountry) quantity[s][t][d]["2026"]))) +
	( 3 * gencost[s][t]["2028"] * ((sum(d in DemandCountry) quantity[s][t][d]["2028"]) - (sum(d in DemandCountry) quantity[s][t][d]["2027"]))) +
	( 2 * gencost[s][t]["2029"] * ((sum(d in DemandCountry) quantity[s][t][d]["2029"]) - (sum(d in DemandCountry) quantity[s][t][d]["2028"]))) +
	( 1 * gencost[s][t]["2030"] * ((sum(d in DemandCountry) quantity[s][t][d]["2030"]) - (sum(d in DemandCountry) quantity[s][t][d]["2029"]))));

//  sum (s in SupplyCountry, t in Technology, d in DemandCountry, y in Year) (gencost[s][t][y] * quantity[s][t][d][y]) ;
  
dexpr float transmissionCost = 
	sum (s in SupplyCountry, t in Technology, d in DemandCountry, y in Year) (transcost[s][t][d] * quantity[s][t][d][y]) ;


//Define objective function
//Note: Adding a negligible positive cost to the political risk factors bounds all risks to their lowest possible value be zero where multiple solutions exist
dexpr float cost = generationCost + transmissionCost;


//Solve  
minimize cost;
  


//Define constraints 
subject to {
  // Satisfy demand in all countries during all time periods
  forall(d in DemandCountry, y in Year)
    ctDemand: sum(s in SupplyCountry, t in Technology) quantity[s][t][d][y] >= demand[d][y];


  // Dont exceed supply
  forall(s in SupplyCountry, t in Technology, y in Year)
    ctSupply: sum(d in DemandCountry) quantity[s][t][d][y] <= maxPotSupply[s][t];       

  // Intertemporal infrastrucutre balances
  forall(s in SupplyCountry, t in Technology)
    ctTemp12: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp13: sum(d in DemandCountry) quantity[s][t][d]["2013"] >= sum(d in DemandCountry) quantity[s][t][d]["2012"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp14: sum(d in DemandCountry) quantity[s][t][d]["2014"] >= sum(d in DemandCountry) quantity[s][t][d]["2013"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp15: sum(d in DemandCountry) quantity[s][t][d]["2015"] >= sum(d in DemandCountry) quantity[s][t][d]["2014"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp16: sum(d in DemandCountry) quantity[s][t][d]["2016"] >= sum(d in DemandCountry) quantity[s][t][d]["2015"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp17: sum(d in DemandCountry) quantity[s][t][d]["2017"] >= sum(d in DemandCountry) quantity[s][t][d]["2016"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp18: sum(d in DemandCountry) quantity[s][t][d]["2018"] >= sum(d in DemandCountry) quantity[s][t][d]["2017"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp19: sum(d in DemandCountry) quantity[s][t][d]["2019"] >= sum(d in DemandCountry) quantity[s][t][d]["2018"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp20: sum(d in DemandCountry) quantity[s][t][d]["2020"] >= sum(d in DemandCountry) quantity[s][t][d]["2019"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp21: sum(d in DemandCountry) quantity[s][t][d]["2021"] >= sum(d in DemandCountry) quantity[s][t][d]["2020"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp22: sum(d in DemandCountry) quantity[s][t][d]["2022"] >= sum(d in DemandCountry) quantity[s][t][d]["2021"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp23: sum(d in DemandCountry) quantity[s][t][d]["2023"] >= sum(d in DemandCountry) quantity[s][t][d]["2022"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp24: sum(d in DemandCountry) quantity[s][t][d]["2024"] >= sum(d in DemandCountry) quantity[s][t][d]["2023"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp25: sum(d in DemandCountry) quantity[s][t][d]["2025"] >= sum(d in DemandCountry) quantity[s][t][d]["2024"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp26: sum(d in DemandCountry) quantity[s][t][d]["2026"] >= sum(d in DemandCountry) quantity[s][t][d]["2025"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp27: sum(d in DemandCountry) quantity[s][t][d]["2027"] >= sum(d in DemandCountry) quantity[s][t][d]["2026"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp28: sum(d in DemandCountry) quantity[s][t][d]["2028"] >= sum(d in DemandCountry) quantity[s][t][d]["2027"]; 
  forall(s in SupplyCountry, t in Technology)
    ctTemp29: sum(d in DemandCountry) quantity[s][t][d]["2029"] >= sum(d in DemandCountry) quantity[s][t][d]["2028"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp30: sum(d in DemandCountry) quantity[s][t][d]["2030"] >= sum(d in DemandCountry) quantity[s][t][d]["2029"];
     
  
  //Political constraint on energy sovernity 
  forall(d in DemandCountry, y in Year)
	ctPolSov: (sum(s in SupplyCountry: s == d, t in Technology) quantity[s][t][d][y]) / demand[d][y] >= minPolSov;
 			
  
  //Emission minimum in 2030
  forall(d in DemandCountry)
    ctEmission: (sum(s in SupplyCountry, t in Technology) quantity[s][t][d]["2030"] * CO2Emissions[t]) / (demand[d]["2030"]*CO2Emissions["Coal"]) <= maxEmissions;
 			
           
}




//Post estimation calculations for data export to Excel
float quantityLong[SupplyXTechnologyXDemandXYear];
int m = 1;
execute {
	for (var s in SupplyCountry) {
		for (var t in Technology) {
			for (var d in DemandCountry) {	
				for (var y in Year) {		
					quantityLong[m] = quantity[s][t][d][y];
					m = m + 1; 		
   				}						
			}		
		}
	}
}	


float quantityLongDash[SupplyXTechnologyXDemandXYearDash];
int h = 1;
execute {
	for (var s in SupplyCountry) {
		for (var t in Technology) {		
			if (t != "Oil") {
				for (var d in DemandCountry) {	
					for (var y in Year) {		
						quantityLongDash[h] = quantity[s][t][d][y];
						h = h + 1; 		
   					}						
				}	
 			}				
		}
	}
}	

 
string namePath = "ResultDashPR50!A";

execute concatene {
	namePath += indexPoint;
	namePath += ":UGV";
	namePath += indexPoint;
}

//string namePath = "ResultDash!A2:UGV2";
 