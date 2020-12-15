Final Project Submission
================
Ale Cuevas, Nolan Flynn, Kyle Bertram
12/14/2020

  - [Question](#question)
  - [Background](#background)
  - [Analyzing Uncertainty](#analyzing-uncertainty)
      - [Case Uncertainty](#case-uncertainty)
      - [Death Uncertainty](#death-uncertainty)
      - [Test Uncertainty](#test-uncertainty)
  - [Data](#data)
      - [Case Data](#case-data)
      - [Death Data](#death-data)
      - [Test Data](#test-data)
  - [Conclusions](#conclusions)
  - [Unanswered Questions](#unanswered-questions)

## Question

Are there racial inequalities in COVID rates in the US?

ANSWER: Despite inconsistencies in the data, there are clear major
racial inequities due to COVID.

## Background

COVID-19 is a global pandemic that has infected 16.5 million people
throughout the US and resulted in the loss of over 40 million jobs
(Wikipedia). The impacts of this pandemic on daily life are undeniable,
and the disease has touched people of every social, economic, racial and
geographic status.

In order to answer our question, we analyzed racially disaggregated data
from COVID Tracking Project. In their statement of their mission, The
COVID Tracking Project is working to provide the public with complete,
accessible data about COVID-19 in the US. They have been collecting race
data through a collaboration with the [Boston University Center for
Antiracist Research](https://www.bu.edu/antiracist-center) and publish
their data twice a week. The data includes counts for reported cases,
deaths, hospitalizations and tests for the total population of the
state, as well as numbers for major racial and ethnic groups.

In order to better answer our question, we combined this with state
level data on racial population make up from the Census Bureau’s 2018
ACS 5-Year data.

The data we used can be found here: [COVID Tracking Project Race
Data](https://covidtracking.com/race/dashboard) Census Bureau’s 2018 ACS
5-Year - Tables B02001, B03002

# Analyzing Uncertainty

One of the most important things to note with the data from the COVID
Tracking Project, is that this data is not a random sampling. People are
only going to get tested when they have a reason such as being
symptomatic. Health care knowledge and capacities have been changing
over time. And there are many confounding variables, especially when
looking at hospitalization/death rates, like age or having another
disease.

Due to having a large number of observations we can ignore some of the
confounding variables. One factor that we cannot ignore is that this
data has been aggregated from state level reports, and each state is
reporting different information in different ways. This can lead to
certain racial groups being over or underrepresented.

To analyze the uncertainty from imperfect reporting methods we computed
the percent of cases, deaths and tests that were reported with racial
data.

## Case Uncertainty

![](Final-Project-Submission_files/figure-gfm/Case%20Data%20by%20Race%20Inconsistencies-1.png)<!-- -->

The country wide percent of cases reporting race is 62.6%.

Only 7 states report race at a lower race than this, however Texas and
New York are two of these states and they both have a high population.

With only a national rate of 62.6% of cases having racial data, we have
a lot of uncertainty here, and while we might be able to notice trends
in cases there is enough uncertainty in our data to prevent making
conclusive claims.

## Death Uncertainty

![](Final-Project-Submission_files/figure-gfm/Death%20Data%20by%20Race%20Uncertainity-1.png)<!-- -->

The country wide percent of deaths reporting race is 93.2%.

All but 3 states are reporting racial information alongside deaths at a
rate of at least 75%, with all but 10 states reporting at a rate of
87.5%.

With a national rate of 93.2% of deaths having racial data, we can make
more confident claims when analyzing deaths.

## Test Uncertainty

![](Final-Project-Submission_files/figure-gfm/Test%20Data%20by%20Race%20Uncertainity-1.png)<!-- -->

Only 7 states reported racial information along with testing data, this
means that there is high uncertainty when analyzing testing data on a
national scale.

# Data

The following graphs are designed to show the ratio of racial testing
rates to racial population. For example, the formula for Black tests
performed would be: (Black tests / total tests) / (Black population /
total population)

## Case Data

![](Final-Project-Submission_files/figure-gfm/Case%20Data%20by%20Race-1.png)<!-- -->

The Hawaiian and Pacific Islander (NHPI) population got COVID far above
their population size for the whole pandemic, but less so in the more
recent months

The Native American (AIAN), Black, and LatinX populations got COVID at a
much higher rate for most of the pandemic, with Black and LatinX dipping
below 1 around October and Native American still disproportionately
high.

The Asian population is getting COVID at noticeably lower rates, despite
being tested above their population percentage

## Death Data

![](Final-Project-Submission_files/figure-gfm/Death%20Data%20by%20Race-1.png)<!-- -->

The Hawaiian and Pacific Islander and Native American populations have
the worst death rates for the vast majority of the year.

Black death rates started out disproportionately high, before
decreasing,and crossing the threshold around late October, before
continuing to decrease to have a lower proportion.

The White population death rates were consistently below average before
increasing and crossing the threshold around the same time as Black
people in late October, before increasing and being slightly above
average.

The Asian population has been consistently significantly below average.

## Test Data

![](Final-Project-Submission_files/figure-gfm/Test%20Data%20by%20Race-1.png)<!-- -->

We can see that the Hawaiian and Pacific Islander population has been
consistently tested far above their population size

The Black population was tested above their population size at the
beginning of the pandemic, but dipped below 1 around October

The White population got to about 1 in July and remained around there
since

The Asian population were being tested at lower rates relative to the
population at the beginning of the pandemic but are now tested at a
higher rate

# Conclusions

From analyzing the testing rates, we know that while our analysis might
uncover potential trends, we need to use caution when making any
conclusions on the data as there are high rates of non-reporting.
Additionally, due to unevenly spread populations of different ethnic
groups across different states, the differing reporting policies per
state could cause certain racial groups to be over or underrepresented.

With this in mind we analyzed our graphs. In the graphs for both
American Indian and Alaska Native (AIAN), and the Native Hawaian and
Pacfic Islander (NHPI) populations, we can see that they have
consistently higher case and death rates. While there is some
uncertainty in the case data due to incomplete reporting, we are fairly
confident in the death data, since these two factors align we are fairly
confident that the racial disparity exists.

# Unanswered Questions

What does the unreported data look like? How would the inclusion of the
unreported data change our current trends? Would they change at all?

What additional trends would analyzing socioeconomic status show? Would
there be any correlation with race?
