cd "/Users/sajidhasnat/Documents/ECONOMETRICS/STATA"
summarize dailymeanpm25concentration dailyaqivalue
by treatment, sort: summarize dailymeanpm25concentration
by POST, sort: summarize Daily Mean PM
by treatment, sort: summarize dailymeanpm25concentration
by POST, sort: summarize dailymeanpm25concentration
by POST, sort: summarize dailyaqivalue
by treatment, sort: summarize dailyaqivalue

gen subset = POST == 0
ttest dailymeanpm25concentration if subset == 1, by(treatment)
ttest dailyaqivalue if subset == 1, by(treatment)
collapse (mean) dailymeanpm25concentration, by(treatment POST)
list
twoway (line "Daily Mean PM2" POST if treatment == 1, sort lcolor(blue)) ///
       (line "Daily Mean PM2" POST if treatment == 0, sort lcolor(red)), ///
       legend(label(1 "California") label(2 "Texas")) ///
       xlabel(0 "2012" 1 "2024") ///
       ylabel(, grid) ///
       title("Average AQI by State and Year")
histogram "Daily Mean PM2", by(treatment) normal ///
    title("AQI Distribution by State") ///
    xlabel(, grid) ylabel(, grid)
graph box "Daily Mean PM2", over(treatment) by(POST) ///
    title("AQI by Treatment and Time Period") ///
    ylabel(, grid)
* Verify the variables
list "Daily Mean PM2" POST treatment "Daily AQI Value" in 1/10
gen did = treatment * POST
reg "Daily Mean PM2" treatment##POST, cluster(treatment)
* Create a unique panel identifier if not present
egen panel_id = group(treatment POST)

* Declare the data as panel data
xtset panel_id POST

xtreg "Daily Mean PM2" POST##treatment, fe cluster(panel_id)
