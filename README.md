# compute-ZIP-level-ADI
Convert publicly available 2020 and 2015 census block group level ADI to 5-digit zipcode level ADI through a population weighed mean of ADI ranks with census block group level population data from ACS5. The code is in the _zip_blk_grp_overlap folder_ and is organized as follows:

## ADI_2020_prepare.R
This file reads in the raw 2020 ADI data (available[here](https://www.neighborhoodatlas.medicine.wisc.edu)), cleans it, pulls in ACS5 data for 2020 to take a population weighted mean of ADI percentile ranks, and then categorizes the weighted averages into quintiles and categories.
Before running this fle, replace the parent directory in line 8 with the name of the folder which stores the code folder, and add your census key at line 24. Census keys are obtainable [here](http://api.census.gov/data/key_signup.html). 

## ADI_2015_prepare.R
The structure of this file is similar to the previous script. It creates the zip-level crosswalk for 2015 ADI.

## Merge_2020_2015_ADI.R
Combine zip-level 2020 and 2015 population weighted ADI ranks by averaging them.

## Output
The zip-ADI crosswalks are stored in
- 2020 crosswalk: _data/use_data/national_adi/crosswalk_
- 2015 crosswalk: _~/crosswalk/2015_
- aggregated crosswalk: _~/crosswalk/2015_2020_

## Data description

**zip_ADI**: the raw ADI data contained census block group level national ADI percentile ranks, where a higher rank signified greater disadvantage. Since a zipcode can be linked to multiple census block groups, I created the “zip_ADI” by taking a population weighted mean of the national ADI ranks, using block group level populations. The range for the zip_ADI variable is [1, 100]. 
 
**ADI_quintile**: The weighted ADI can fall into one of five quantiles, Q1-Q5. The quantile is created using the quantile function in R (using the type 7 quantile algorithm described in the function [documentation](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/quantile)). I produce quantiles for the zip_ADI distribution corresponding to the probabilities 0.2, 0.4, 0.6, 0.8, and 1.
 
**ADI_category**: The weighted ADI can fall into one of five categories, C1-C5. C1 corresponds to weighted ADI between [0,20), C2: [20,40), and so on till C5: [80,100].
