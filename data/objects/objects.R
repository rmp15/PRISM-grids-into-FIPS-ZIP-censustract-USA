# climate metrics currently
metrics <- c("mean","meanc","meanc2","days_below_10","days_above_30","sd","days_changing_by_5","days_increasing_by_5" ,"days_decreasing_by_5","number_of_min_3_day_above_99_upwaves","number_of_min_3_day_below_99_downwaves")

# declare metrics of interest for correlations
metrics.matrix = c('meanc3','sd','10percc3','90percc3',
                'number_of_days_above_nonnormal_90_2', 'number_of_days_below_nonnormal_90_2',
                'number_of_min_3_day_above_nonnormal_90_upwaves_2','number_of_min_3_day_below_nonnormal_90_downwaves_2')

metrics.matrix.short = c('Mean','SD','10%','90%',
                'DA90', 'DB10',
                'UW90','DW10')

# create dictionary for variables
dat.dict = data.frame(  metric=metrics.matrix,
                        name=metrics.matrix.short,
order=c(8,1,7,6,5,4,3,2))

# to correct colours
f <- function(pal) brewer.pal(brewer.pal.info[pal, "maxcolors"], pal)
mycols <- c(f("Dark2"), f("Set1")[1:8], f("Set2"), f("Set3"),"#89C5DA", "#DA5724", "#74D944", "#CE50CA", "#3F4921", "#C0717C", "#CBD588", "#5F7FC7", "#673770", "#D3D93E", "#38333E", "#508578", "#D7C1B1", "#689030", "#AD6F3B", "#CD9BCD", "#D14285", "#6DDE88", "#652926", "#7FDCC0", "#C84248", "#8569D5", "#5E738F", "#D1A33D", "#8A7C64", "#599861" )
#to make picking the number of the colour you want easier:
#plot(1:length(mycols),col=mycols[1:length(mycols)],cex=4,pch=20); abline(v=c(10,20,30,40,50,60))

# colors for broad regression
colors.reg = c(mycols[c(          10,       # 0
                                25)],       # 0.25
                                'white',    # 0.5
             c(mycols[c(        4,          # 0.75
                                9)]))       # 1

colors.rsq = c('white',                     # 0
                mycols[c(       4,          # 0.5
                                9)])        # 1