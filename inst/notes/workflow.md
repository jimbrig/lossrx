Here is a rough outline of what an actuary would go through in a typical reserving analysis on a periodical base.

Starting from the Claims Data Warehouse, an actuary collects the important data fields that are required for analysis.
Usually needs: loss payments, lae payments, case reserves, transaction date, accident date at a minimum
After verifying the data, we transform the claims level data into loss development triangles.
Here we can produce various triangles such as paid triangle, incurred triangle, reported counts triangle, closed counts triangle, etc
We can further segment the data into various groupings (state, injury type, large vs small), e.g., California triangle vs New York triangle
At the diagnostics step, we examine the triangle data to see if there’s any outliers or anomaly we need to adjust before producing the models
For example, we can look at how the reported frequency and severity change over time
We can also examine if there’s any pattern in the triangles due to changes in claims practices or regulatory environment
After going through diagnostics, the reserving methods should be automatically populated
Paid, Incurred CL, BF, GB, etc
Bayesian Methods (Compartmental Reserving, Clark, etc)
Individual claims using ML such as Tychobra or Loyalty Program
Step 4 and 5 are intertwined to the extent actuaries need to make adjustments to the models
Adjusting for outliers in link ratios
Coming up with a priori LR for BF method
Selecting prior distributions for various Bayesian models
Tuning hyperparameters for ML models
Here we should also keep track of changes we make to the models for documentation
Finally we will select the Ultimate losses for the book of business
We communicate the results within the actuarial team, and we may circle back to step 4/5 for additional adjustments
After finalizing reserves selections, we communicate the results to audience outside of reserving
We present results to relevant stakeholders (Finance, UW, etc)
We also supply any actuarial data required by our colleagues
In the last step, we save our final reserves numbers and any relevant data, documentation into a historical database for future reference
