#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# The code at the top of the file gets run once, on loading/running

# Load libraries
library(dplyr)
library(ggplot2)
library(kableExtra)
library(knitr)
library(readr)
library(rgdal)
library(rgeos)
library(shiny)
library(tidyr)

# Load data
rawdatafile = "../../data/prepared/normalised_data.csv"
mapdatadir = "../../data/prepared"
mapdatastem = "Scot_LAs"
rawdata = read_csv(rawdatafile)
filtered_long = rawdata %>%
  filter(year > 2004) %>%
  filter(year < 2012) %>% 
  filter(variable %in% c("employment", "population", "road-vehicles"))
filtered_wide = spread(filtered_long, variable, value)
names(filtered_wide) = c("Reference.Area", "year", "employment", "population", "rv")
filtered_wide = filtered_wide %>%
  mutate(employment_rate = employment/population) %>%
  mutate(rv_per_head = rv/population)
corr_data = filtered_wide %>%
  group_by(Reference.Area) %>%
  summarise(emp_rv = cor(employment, rv))
corr_data = merge(corr_data, filtered_wide
                  %>% group_by(Reference.Area)
                  %>% summarise(emprate_rv = cor(employment_rate, rv)))
corr_data = merge(corr_data, filtered_wide
                  %>% group_by(Reference.Area)
                  %>% summarise(emp_rvph = cor(employment, rv_per_head)))
corr_data = merge(corr_data, filtered_wide
                  %>% group_by(Reference.Area)
                  %>% summarise(emprate_rvph = cor(employment_rate, rv_per_head)))
shapefile = readOGR(mapdatadir, mapdatastem)
simpleshape = gSimplify(shapefile, tol=500, topologyPreserve=TRUE)
shapefile_df = fortify(simpleshape)
shapefile_df$names = levels(shapefile@data$geo_label)[as.numeric(shapefile_df$id)+1]
shapefile_df = merge(shapefile_df, corr_data, by.x="names", by.y="Reference.Area")


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Scottish Regions Data By Year"),
   
   # Map plot
   fluidRow(
     column(6,
       h3(textOutput("text1")),
       plotOutput("map1")
     ),
     
     column(6,
       h3(textOutput("text2")),
       plotOutput("map2")
     )
   ),
   
   # Spacer
   hr(),
   
   # Inputs
   fluidRow(
     column(3,
            h4("Years for data selection"),
            sliderInput('year1', 'Year (left):', 
                        min=2005, max=2011, value=2005),
            sliderInput('year2', 'Year (right):', 
                        min=2005, max=2011, value=2005)
     ),
     
     column(4, offset=1,
            selectInput('varname', "Variable",
                        c("employment", "population", "rv",
                          "employment_rate", "rv_per_head"))
     )
     
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$map1 = renderPlot({
     # Render Scottish regions with selected data for selected year
     data = filtered_wide %>% filter(year==input$year1)
     filtered_shapes = merge(shapefile_df, data, by.x="names", by.y="Reference.Area")
     map = ggplot(data=filtered_shapes, aes_string("long", "lat", group="group", fill=input$varname)) +
       coord_fixed() +
       geom_polygon(color='white', size=0.1)
     map
   })

   output$map2 = renderPlot({
     # Render Scottish regions with selected data for selected year
     data = filtered_wide %>% filter(year==input$year2)
     filtered_shapes = merge(shapefile_df, data, by.x="names", by.y="Reference.Area")
     map = ggplot(data=filtered_shapes, aes_string("long", "lat", group="group", fill=input$varname)) +
       coord_fixed() +
       geom_polygon(color='white', size=0.1)
     map
   })
   
   output$text1 = renderText({
     paste(input$varname, " for ", input$year1)
   })
   
   output$text2 = renderText({
     paste(input$varname, " for ", input$year2)
   })

}

# Run the application 
shinyApp(ui = ui, server = server)

