/*********************************************
 * OPL 12.6.3.0 Model
 * Author: Philipp Trotter, University of Bath
 * Creation Date: 14 Jul 2016 at 11:58:19
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

float maxPotential2030 = ...;
float fossilRestriction = ...;
float minPolSov = ...;
float maxEmissions = ...;


//Define parameters to be populated through Excel data
float supplyInput[SupplyXTechnology] = ...;
float demandInput[DemandXYear] = ...;
float gencostInput[SupplyXTechnologyXYear] = ...;
float transcostInput[SupplyXTechnologyXDemand] = ...;
float demandTotal[YearRange] = ...;
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
  sum (s in SupplyCountry, t in Technology, d in DemandCountry, y in Year) (gencost[s][t][y] * quantity[s][t][d][y]) ;
  
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


  // Dont exceed supply, assuming 25% more of maximal Potential can be brought online within 5 years
  forall(s in SupplyCountry, t in Technology, y in Year)
    ctSupply: sum(d in DemandCountry) quantity[s][t][d][y] <= maxPotSupply[s][t];       

  // Intertemporal infrastrucutre balances
  forall(s in SupplyCountry, t in Technology)
    ctTemp12: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp13: sum(d in DemandCountry) quantity[s][t][d]["2013"] >= sum(d in DemandCountry) quantity[s][t][d]["2012"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"]; 
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];
  forall(s in SupplyCountry, t in Technology)
    ctTemp11: sum(d in DemandCountry) quantity[s][t][d]["2012"] >= sum(d in DemandCountry) quantity[s][t][d]["2011"];         
    
          
  
  //Political constraint on energy sovernity
  forall(d in DemandCountry)
	ctPolSov: (sum(s in SupplyCountry: s == d, t in Technology) quantity[s][t][d]) / demand[d] >= minPolSov;
 			
  
  //Emission minimum
    ctEmission: (sum(s in SupplyCountry, t in Technology, d in DemandCountry) quantity[s][t][d] * CO2Emissions[t]) / (demandTotal*CO2Emissions["Coal"]) <= maxEmissions;
 			
           
}




//Post estimation calculations for data export to Excel
float quantityLong[SupplyXTechnologyXDemand];
int m = 1;
execute {
	for (var s in SupplyCountry) {
		for (var t in Technology) {
			for (var d in DemandCountry) {		
				quantityLong[m] = quantity[s][t][d];
				m = m + 1; 			
			}		
		}
	}
}	

