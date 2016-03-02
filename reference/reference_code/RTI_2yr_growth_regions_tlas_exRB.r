###############################################################
## Project:       tianz_roadshows
## Script:        RTI_2yr_growth_regions_tlas.r
## Date:          15/06/2015
## Author:        Rebecca Burson
## Purpose:       this script will produce 2 png files that will show 2-yr growth in international and domestic card spending by RC and TLA
##                the code is fully automated and will use the most recent ye available in the production database.
## Inputs:        RTI data from TRED, shape files from {mbiemaps}
## Outputs:       2x .PNG files.
## Peer Review:   
###############################################################

library(mbiemaps)
library(RColorBrewer)
library(extrafont)
library(Cairo)
library(grid)

#----------- Regional maps---------------------------------
       
      SQL <- "Select a.RecordType,
                        a.Year,
                        a.MonthNumber as Month,
                        concat('01/', a.MonthNumber,'/', a.Year)        as Period,
                        d.L2Description       					            as Region,
                        sum(SpendAmount) as SPEND 
                  from  Production.vw_RTISurveyMainHeader a
                  left join
                        Production.vw_RTISpend b
                     on a.SurveyResponseID = b.SurveyResponseID
 
                  left join
                  (Select distinct L1Description, L2Description, L3Description
                        from Classifications.vw_ClassificationLevels cl
                        where cl.L3ClassificationName = 'MBIEInt_TAMOD_1_Geography'  
                        and cl.L2ClassificationName = 'MBIEPub_RegCouncil_1_Geography'
                        and cl.L1ClassificationName = 'MBIEPub_Islands_1_Geography') as d
	 
				         on d.L3Description = b.Merchant

                  where a.RecordType in ('Domestic', 'International')
                  group by a.Year, a.MonthNumber, a.RecordType, d.L2Description 
                  order by a.RecordType, a.Year, a.MonthNumber"

         Dom_Int <- sqlQuery(TRED_Prod, SQL)

 # calculate a current year end      
      curMon <- (Dom_Int[nrow(Dom_Int), ])$Month
      Dom_Int$YECurrent <- with(Dom_Int, ifelse(Month > curMon, Year + 1, Year))
      Dom_Int$YEMonth <- format(as.Date(paste0("01/", curMon, "/9999"), "%d/%m/%Y"), "%B")
       
      
# get rid of unneeded extra columns      
      Dom_Int               <- Dom_Int[ , -which(names(Dom_Int) %in% c("Month", "Year"))]             
        
        
# aggregate up to current year
      
      RTIyr <- Dom_Int %>%
                  group_by(RecordType, Region, YECurrent, YEMonth) %>%
                  summarise(Spend = sum(SPEND)) %>%
                  ungroup() %>%
                  filter(YECurrent %in% c(max(YECurrent), max(YECurrent)-2)) %>%
                  group_by(RecordType, Region) %>%
                  mutate(growth = CAGR(Spend/lag(Spend), 2)) %>%
                  filter(YECurrent %in% max(YECurrent))
        

CurYr <- unique(RTIyr$YECurrent)
CurMonth <-         unique(RTIyr$YEMonth)
        
data(region_simpl_gg)
region_simpl_gg$SHORTNAME <- gsub(" Region", "", region_simpl_gg$NAME)

tmp <- merge(region_simpl_gg, RTIyr, all.x = TRUE, by.x = "SHORTNAME", by.y = "Region")
tmp2 <- unique(tmp[, c("long.centre", "lat.centre", "Spend", "RecordType")])

# We want fill to be a symmetrical scale, so:
L <- 1.05 * max(abs(tmp$growth))/100

png("Output/RTI_2yr_growth_dom_int_RC.png", 3200, 2400, res = 400)
print(ggplot(tmp) +
        geom_polygon(aes(x=long, y=lat, group=group, fill=growth/100)) +
        theme_nothing(base_family="Calibri", base_size = 12) +
        coord_map() +
        facet_wrap(~RecordType, ncol = 2) +
        labs(title = " ", fill = "Average growth\n(Per cent per year)\n") +
        scale_fill_gradientn(colours=c(mbie.cols(5), "grey90", mbie.cols(1)), limits=c(-L, L), label=percent)
      )
 grid.text(paste("Growth in domestic and international tourism card spend\n for two years ending", CurMonth, CurYr,"\n"), x = .5, y = .92, gp = gpar(fontsize = 14, fontfamily = "Calibri", col = "black"))
dev.off()


#----------- TLA maps---------------------------------
       
      SQL <- "Select a.RecordType,
                        a.Year,
                        a.MonthNumber as Month,
                        concat('01/', a.MonthNumber,'/', a.Year)        as Period,
                        d.L2Description       					            as TLA,
                        sum(SpendAmount) as SPEND 
                  from  Production.vw_RTISurveyMainHeader a
                  left join
                        Production.vw_RTISpend b
                     on a.SurveyResponseID = b.SurveyResponseID
 
                 left join
                        (Select distinct L1Description, L2Description, L3Description
                        from Classifications.vw_ClassificationLevels cl
                        where cl.L3ClassificationName = 'MBIEInt_TAMOD_1_Geography'  
                        and cl.L2ClassificationName = 'SNZ_TA11_1_Geography'
                        and cl.L1ClassificationName = 'MBIEPub_Islands_1_Geography') as d
                   
                   on d.L3Description = b.Merchant
                   
                  where a.RecordType in ('Domestic', 'International')
                  group by a.Year, a.MonthNumber, a.RecordType, d.L2Description 
                  order by a.RecordType, a.Year, a.MonthNumber"

         Dom_Int <- sqlQuery(TRED_Prod, SQL)

 # calculate a current year end      
      curMon <- (Dom_Int[nrow(Dom_Int), ])$Month
      Dom_Int$YECurrent <- with(Dom_Int, ifelse(Month > curMon, Year + 1, Year))
      Dom_Int$YEMonth <- format(as.Date(paste0("01/", curMon, "/9999"), "%d/%m/%Y"), "%B")
       
      
# get rid of unneeded extra columns      
      Dom_Int               <- Dom_Int[ , -which(names(Dom_Int) %in% c("Month", "Year"))]             
        
        
# aggregate up to current year
      
      RTIyr <- Dom_Int %>%
                  group_by(RecordType, TLA, YECurrent, YEMonth) %>%
                  summarise(Spend = sum(SPEND)) %>%
                  ungroup() %>%
                  filter(YECurrent %in% c(max(YECurrent), max(YECurrent)-2)) %>%
                  group_by(RecordType, TLA) %>%
                  mutate(growth = CAGR(Spend/lag(Spend), 2))%>%
                  filter(YECurrent %in% max(YECurrent))
        

CurYr <- unique(RTIyr$YECurrent)
CurMonth <-         unique(RTIyr$YEMonth)
        
data(ta_simpl_gg)
#region_simpl_gg$SHORTNAME <- gsub(" Region", "", region_simpl_gg$NAME)

tmp <- merge(ta_simpl_gg, RTIyr, all.x = TRUE, by.x = "FULLNAME", by.y = "TLA")
tmp2 <- unique(tmp[, c("long.centre", "lat.centre", "Spend", "RecordType")])

# We want fill to be a symmetrical scale, so:
L <- 1.05 * max(abs(tmp$growth))/100

png("Output/RTI_2yr_growth_dom_int_TLA.png", 3200, 2400, res = 400)
print(ggplot(tmp) +
        geom_polygon(aes(x=long, y=lat, group=group, fill=growth/100)) +
        theme_nothing(base_family="Calibri", base_size = 12) +
        coord_map() +
        facet_wrap(~RecordType, ncol = 2) +
        labs(title = " ", fill = "Average growth\n(Per cent per year)\n") +
        scale_fill_gradientn(colours=c(mbie.cols(5), "grey90", mbie.cols(1)), limits=c(-L, L), label=percent)
      )
 grid.text(paste("Growth in domestic and international tourism card spend\n for two years ending", CurMonth, CurYr, "\n"), x = .5, y = .92, gp = gpar(fontsize = 14, fontfamily = "Calibri", col = "black"))
dev.off()
