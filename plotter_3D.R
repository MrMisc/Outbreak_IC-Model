
#! /usr/bin/Rscript

f<-file("stdin")
open(f)
record<-c()
while(length(line<-readLines(f,n=1))>0){
  #write(line,stderr())
  record<-c(record,line)  
}

somethingSomethingplotly<-FALSE

numbers<-record[1:length(record)-1]
numbers_<-c()


print(getwd())

# Plot heatmap
library(ggplot2)
library(pandoc)
library(plotly)
library(echarts4r)
library(echarts4r.assets)
library("ggplot2")
library("plotly")
library("breakDown")
library(dplyr)
library(ggdark)
library(pracma)
library(comprehenr)
library(ggridges)
library(tidyverse)
library(ggplot2)
library(plotly)
library(thematic)
library(extrafont)
library(pandoc)
# Extract x, y coordinates
coordinates <- strsplit(record, " ")
print("Beginning read...")
# Extract x, y, and time values
x <- as.numeric(sapply(coordinates, "[[", 1))
y <- as.numeric(sapply(coordinates, "[[", 2))
altitude <- as.numeric(sapply(coordinates, "[[", 3))
interaction <- as.numeric(sapply(coordinates, "[[", 4))
time <- as.numeric(sapply(coordinates, "[[", 5))
zone<- as.numeric(sapply(coordinates, "[[", 6))
print("Zone check")
print(unique(zone))
# print(zone[length(zone)-5:length(zone)])
print("Finished read")
# print(z)
transfer_distance<-0.7 ##Manually place this information


# step_x<-x[length(x)-1]
# step_y<-y[length(y)-1]
# step_z<-altitude[length(altitude)-1]

# x_large<-x[length(x)]
# y_large<-y[length(y)]
# z_large<-altitude[length(altitude)]

scaling_factor<-6

# x<-x[-c(length(x)-1,length(x))]
# y<-y[-c(length(y)-1,length(y))]
# altitude<-altitude[-c(length(altitude)-1,length(altitude))]
# interaction<-interaction[-c(length(interaction)-1,length(interaction))]
# time<-time[-c(length(time)-1,length(time))]
# zone<-zone[-c(length(zone)-1,length(zone))]
# Create a data frame for each unique zone value
zone_unique <- unique(zone)
# data_frames <- list()

# for (z in zone_unique) {
#   data_frames[[as.character(z)]] <- data.frame(x = x[zone == z], y = y[zone == z])
# }


# custom_colors <- c("#FFE7D3", "#FFBEC3", "#FF878E", "#C4515C")

# print(unique(interaction))
# Create the ggplot2 plot with geom_tile and frame aesthetic




print("Zone unique is ..")
print(zone_unique)
N<-length(unique(zone_unique))/2

print("Zone check")
print(unique(zone))
count<-1

step_x<-rep(1,N)
step_y<-rep(1,N)
step_z<-rep(1,N)

x_large<-rep(1,N)
y_large<-rep(1,N)
z_large<-rep(1,N)


for (separate_zone in 1:N){
  step_x[separate_zone]<-x[length(x)-(N-separate_zone)]-100000
  step_y[separate_zone]<-y[length(y) - (N-separate_zone)]-100000
  step_z[separate_zone]<-altitude[length(altitude) - (N-separate_zone)]-100000
  #interaction, time, zone
  x_large[separate_zone]<-interaction[length(interaction) - (N-separate_zone)]-100000
  y_large[separate_zone]<-time[length(time) - (N-separate_zone)]-100000
  z_large[separate_zone]<-zone[length(zone) - (N-separate_zone)]-100000

  print("Step X coord extract is..")
  print(x[length(x)-(N-separate_zone)])
}






print("Step parameters are ...")
print(step_x)
print(step_y)
print(step_z)

print("Max param sizes are...")
print(x_large)
print(y_large)
print(z_large)

print("Number of elements that we are removing is")
print(N)
# print("Before removing elements, zone info is...")
# print(zone)

x<-x[-c((length(x) - N+1):length(x))]
y<-y[-c((length(y) - N+1):length(y))]
altitude<-altitude[-c((length(altitude) - N+1):length(altitude))]
interaction<-interaction[-c((length(interaction) - N+1):length(interaction))]
time<-time[-c((length(time) - N+1):length(time))]
zone<-zone[-c((length(zone) - N+1):length(zone))]

# print(zone)


data <- data.frame(x = x, y = y, z = altitude,interaction = factor(interaction), time = time, zone = zone)
zone_unique2 <- unique(zone)
print("ZONES being used...")
print(zone_unique2)
minimum<-min(data$time)
maximum<-max(data$time)
for (separate_zone in zone_unique2){
  # print(typeof(separate_zone))
  data_<-subset(data, zone == separate_zone)
  
  data_ <- data_ %>% 
      mutate(interaction = case_when(
        interaction == 1000 ~ "marker",
          interaction == 0 ~ "Host 0[*]",
          interaction == 1 ~ "Host <-> Host[*]",
          interaction == -2 ~ "Host -> Egg[*]",
          interaction == -3 ~ "Host -> Faeces[*]",
          interaction == 4 ~ "Egg <-> Egg[*]",
          interaction == -6 ~ "Egg -> Faeces[*]",
          interaction == 9 ~ "Faeces <-> Faeces[*]",
          interaction == 2 ~ "Egg -> Host[*]",
          interaction == 3 ~ "Faeces -> Host[*]",
          interaction == 6 ~ "Faeces -> Egg[*]",
          interaction == 10~ "Feed infection",
          interaction == 11~ "Eviscerator -> Host",
          interaction == 12~ "Host -> Eviscerator",
          interaction == 13~ "Eviscerator Mishap/Explosion",
          interaction == 100 ~ "Host 0",
          interaction == 101 ~ "Host <-> Host",
          interaction == -102 ~ "Host -> Egg",
          interaction == -103 ~ "Host -> Faeces",
          interaction == 104 ~ "Egg <-> Egg",
          interaction == -106 ~ "Egg -> Faeces",
          interaction == 109 ~ "Faeces <-> Faeces",
          interaction == 102 ~ "Egg -> Host",
          interaction == 103 ~ "Faeces -> Host",
          interaction == 106 ~ "Faeces -> Egg",          
          TRUE ~ as.character(interaction)
      ))

  custom_marker_symbols <- list(
    "Host <-> Host" = "circle",
    "Host <-> Egg" = "star",
    "Host <-> Faeces" = "hexagram",
    "Egg <-> Egg" =  "x",
    "Egg <-> Faeces" = "star-x",
    "Faeces <-> Faeces" = "asterisk"
    # Add more symbols for other unique 'interaction' values if needed
  )


  # fig <- plot_ly(data, x = ~x, y = ~y, z = ~z, symbol = ~interaction, color = ~time, mode = "markers")
  print("Maximum data time is")
  print(max(data_$time))
  print("Minimum data time is")
  print(min(data_$time))
  if (somethingSomethingplotly){
    fig <- plot_ly(data_, x = ~x, y = ~y, z = ~z, mode = "markers", type = "scatter3d", symbol = ~interaction, text = ~paste(
                            '<br>Time:', time, 'hours ','<br> Infection Event Type:',interaction),
                  marker = list(
                    color = ~time,
                    cmin = min(data_$time),
                    cmax = max(data_$time),                  
                    size = transfer_distance*scaling_factor,
                    opacity = 0.9,
                    colorscale=list(c(0, 1), c("#C34A36", "#2F4858")),                 
                    colorbar = list(
                    title = 'Time',
                    x = 0,
                    y = 0.5,
                    thickness = 5,
                    dtick = 12,
                    tick0 = 0
                  ),
                    showscale = TRUE
                  ))
    print("Using x coord as follows")
    print("Max x")
    print(x_large[count])
    print("Out from ")
    print(x_large)
    print("Step x")
    print(step_x[count])
    print("Out from")
    print(step_x)
    fig <- fig %>% layout(scene = list(xaxis = list(title = 'X-Axis',dtick = step_x[count],range = list(0,x_large[count])),
                                    yaxis = list(title = 'Y-Axis',dtick = step_y[count],range = list(0,y_large[count])),
                                    zaxis = list(title = 'Z-Axis',dtick = step_z[count],range = list(0,z_large[count])),
                                    aspectmode = "manual",aspectratio = list(x = x_large[count]/f,y = y_large[count]/f,z = z_large[count]/f)))

    fig<-fig%>%
    animation_opts(mode = "next",
                  easing = "elastic-in", redraw = FALSE
    )

    htmlwidgets::saveWidget(as_widget(fig), paste("animation",separate_zone,".html",sep = "_"), selfcontained = TRUE)
    rm(fig)

    fig <- plot_ly(data_, x = ~x, y = ~y, z = ~z, mode = "markers", type = "scatter3d", frame = ~time, symbol=~interaction,text = ~paste(
                            '<br>Time:', time, 'hours ','<br> Infection Event Type:',interaction, '<br> Zone: ',zone),
                  marker = list(
                    color = "#15798C",
                    size = transfer_distance*scaling_factor,
                    opacity = 0.9,
                    colorscale = 'Inferno'
                  ))

    # Apply the custom color scale to the plot
    # fig$x$data[[1]]$marker$colorscale <- custom_color_scale
    # fig <- fig %>% add_markers()
    # fig <- fig %>% layout(scene = list(xaxis = list(title = 'X-Axis',dtick = step_x[separate_zone],range = list(0,x_large[separate_zone])),
    #                                 yaxis = list(title = 'Y-Axis',dtick = step_y[separate_zone],range = list(0,y_large[separate_zone])),
    #                                 zaxis = list(title = 'Z-Axis',dtick = step_z[separate_zone],range = list(0,z_large[separate_zone])),
    #                                 aspectmode = "manual",aspectratio = list(x = x_large[separate_zone],y = y_large[separate_zone],z = z_large[separate_zone])))
    fig <- fig %>% layout(scene = list(xaxis = list(title = 'X-Axis',dtick = step_x[count],range = list(0,x_large[count])),
                                    yaxis = list(title = 'Y-Axis',dtick = step_y[count],range = list(0,y_large[count])),
                                    zaxis = list(title = 'Z-Axis',dtick = step_z[count],range = list(0,z_large[count])),
                                    aspectmode = "manual",aspectratio = list(x = x_large[count]/f,y = y_large[count]/f,z = z_large[count]/f)))  

    fig<-fig%>%
    animation_opts(frame = 300,transition = 150,mode = "next",
                  easing = "elastic-in", redraw = TRUE
    )

    htmlwidgets::saveWidget(as_widget(fig), paste("animation",separate_zone,"time_series",".html",sep = "_"), selfcontained = TRUE)  


  }


  # Apply the custom color scale to the plot
  # fig$x$data[[1]]$marker$colorscale <- custom_color_scale
  # fig <- fig %>% add_markers()
  #Factor
  f<-max(x_large[count],y_large[count],z_large[count])/200
  f_<-0.3*f

  df<-data_
  df$label<-df$interaction
  # df$Time<-df$time
  my_scale <- function(x) scales::rescale(x, to = c(minimum, maximum))
  print(paste("Minimum and maxima of data are as",min(df$time),"vs",max(df$time),"while for the entire dataset it is",min(data$time),"and",max(data$time)))
  fig<-df |> group_by(interaction) |> e_charts(x) |> 
    e_scatter_3d(y,z,time,label)|>
    e_tooltip() |>
    e_visual_map(time,type = "continuous",inRange = list(symbol = "diamond",symbolSize = c(45,8), colorLightness = c(0.6,0.35)),scale = my_scale,dimension = 3,height = 100) |>
    e_x_axis_3d(min = 0,max = x_large[count],interval = step_x[count])|>
    e_y_axis_3d(min = 0,max = y_large[count],interval = step_y[count])|>
    e_z_axis_3d(min = 0,max = z_large[count],interval = step_z[count], name = "Z / Altitude")|>
    e_grid_3d(boxWidth = x_large[count]/f_,boxHeight = z_large[count]/f_,boxDepth = y_large[count]/f_)|>
    e_legend(show = TRUE) |>
    e_title(paste("Infection Plot | Zone",separate_zone,sep = " "), "IC Model | by Irshad Ul Ala")|>
    e_theme_custom("MyEChartsTheme2.json")
  htmlwidgets::saveWidget(fig, paste("Eanimation",separate_zone,".html",sep = "_"), selfcontained = TRUE)




  count<-count+1
  rm(fig)
}

print("First section generation complete!")


if (somethingSomethingplotly){
  fig <- plot_ly(data, x = ~x, y = ~y, z = ~z, mode = "markers", type = "scatter3d", frame = ~zone,text = ~paste(
                            '<br>Time:', time, 'hours ','<br> Infection Event Type:',interaction),
                marker = list(
                  color = ~time,
                  size = transfer_distance*scaling_factor,
                  opacity = 0.9,
                  colorscale = 'Inferno',
                  colorbar = list(
                    title = 'Time',
                    x = 0,
                    y = 0.5,
                    thickness = 5,
                    dtick = 12,
                    tick0 = 0
                  )
                ))

  # Apply the custom color scale to the plot
  # fig$x$data[[1]]$marker$colorscale <- custom_color_scale
  # fig <- fig %>% add_markers()
  fig <- fig %>% layout(scene = list(xaxis = list(title = 'X-Axis',dtick = max(step_x),range = list(0,max(x_large))),
                                  yaxis = list(title = 'Y-Axis',dtick = max(step_y),range = list(0,max(y_large))),
                                  zaxis = list(title = 'Z-Axis',dtick = max(step_z),range = list(0,max(z_large))),
                                  aspectmode = 'manual',aspectratio = list(x = x_large,y = y_large,z = z_large)))


  htmlwidgets::saveWidget(as_widget(fig), "animation__byzones.html", selfcontained = TRUE)



}



# summary_data <- data %>%
#   group_by(interaction, time) %>%
#   summarise(count = n()) %>%
thematic::thematic_on(bg = "#fff6eb", fg = "#005B4B", accent = "#005B4B", font = "Yu Gothic")
print(unique(data$interaction))
data <- data%>% 
    mutate(interaction = case_when(
      interaction == 1000 ~ "marker",
        interaction == 0 ~ "Host 0[*]",
        interaction == 1 ~ "Host <-> Host[*]",
        interaction == -2 ~ "Host -> Egg[*]",
        interaction == -3 ~ "Host -> Faeces[*]",
        interaction == 4 ~ "Egg <-> Egg[*]",
        interaction == -6 ~ "Egg -> Faeces[*]",
        interaction == 9 ~ "Faeces <-> Faeces[*]",
        interaction == 2 ~ "Egg -> Host[*]",
        interaction == 3 ~ "Faeces -> Host[*]",
        interaction == 6 ~ "Faeces -> Egg[*]",
        interaction == 10~ "Feed infection",
        interaction == 11~ "Eviscerator -> Host",
        interaction == 12~ "Host -> Eviscerator",
        interaction == 13~ "Eviscerator Mishap/Explosion",
        interaction == 100 ~ "Host 0",
        interaction == 101 ~ "Host <-> Host",
        interaction == -102 ~ "Host -> Egg",
        interaction == -103 ~ "Host -> Faeces",
        interaction == 104 ~ "Egg <-> Egg",
        interaction == -106 ~ "Egg -> Faeces",
        interaction == 109 ~ "Faeces <-> Faeces",
        interaction == 102 ~ "Egg -> Host",
        interaction == 103 ~ "Faeces -> Host",
        interaction == 106 ~ "Faeces -> Egg",          
        TRUE ~ as.character(interaction)
    ))

print("Names in data are")
print(unique(data$interaction))

fig <- ggplot(data, aes(x = time, fill = as.factor(interaction))) +
  geom_bar(position = "dodge") + facet_wrap(.~zone)+
  labs(title = "Bar Plot of Interaction Counts Over Time", x = "Time", y = "Count")

fig <- ggplotly(fig, dynamicTicks = TRUE)

htmlwidgets::saveWidget(fig, "Histogram.html", selfcontained = TRUE)

S <- data %>%
  group_by(interaction,zone,time) %>%
  summarise(count = n()) %>%
  ungroup()

S_ <- data %>%
  group_by(interaction,time) %>%
  summarise(count = n()) %>%
  ungroup()

fig <- ggplot(S, aes(y = count,x = time, color = as.factor(interaction))) +
  geom_line() + facet_wrap(.~zone) +
  labs(title = "Interaction Counts Over Time", x = "Time", y = "Count")

fig <- ggplotly(fig, dynamicTicks = TRUE)

htmlwidgets::saveWidget(fig, "Line.html", selfcontained = TRUE)
rm(fig)
# write.csv(S_,"infections_sample.csv", row.names = FALSE)
# write.csv(S,"extra.csv", row.names = FALSE)
# write.csv(data,"full.csv", row.names = FALSE)
data <- S_ %>%
  mutate(dates = time) %>%
  select( -time) %>%
  rename(groups = interaction, values = count)

# Convert 'dates' column to numeric (if it's not already numeric)
data$dates <- as.numeric(data$dates)

# Create a template dataframe with all unique combinations of groups and dates
all_combinations <- expand.grid(
  groups = unique(data$groups),
  dates = unique(data$dates)
)

# Merge the template with the existing data
filled_data <- merge(all_combinations, data, by = c("groups", "dates"), all = TRUE)

# Replace missing values with 0
filled_data[is.na(filled_data$values), "values"] <- 0

# e_theme(
#   e,
#   name = c("auritus", "azul", "bee-inspired", "blue", "caravan", "carp", "chalk", "cool",
#            "dark-blue", "dark-bold", "dark-digerati", "dark-fresh-cut", "dark-mushroom", "dark",
#            "eduardo", "essos", "forest", "fresh-cut", "fruit", "gray", "green", "halloween",
#            "helianthus", "infographic", "inspired", "jazz", "london", "macarons", "macarons2",
#            "mint", "purple-passion", "red-velvet", "red", "roma", "royal", "sakura", "shine",
#            "tech-blue", "vintage", "walden", "wef", "weforum", "westeros", "wonderland")
# )



# Sort the combined data by 'groups' and 'dates'
filled_data <- filled_data[order(filled_data$groups, filled_data$dates), ]
fig<-filled_data|>group_by(groups)|>
  e_charts(dates) |>
  e_area(values,
         emphasis = list(
           focus = "self"
         )) |> 
  e_y_axis(min = 0)|>
  e_tooltip()  |>
  e_theme("westeros")|>
  e_datazoom(
    type = "slider",
    toolbox = TRUE,
    bottom = 10
  )|>
  e_legend(right = 5,top = 80,selector = "inverse",show=TRUE,icon = 'circle',emphasis = list(selectorLabel = list(offset = list(10,0))), align = 'right',type = "scroll",width = 10,orient = "vertical")|>
  e_legend_unselect("marker")|>
  e_legend_unselect("Host 0[*]")|>
  e_title(paste("Infection Occurrences over Time by Type"), "IC Model | by Irshad Ul Ala")
htmlwidgets::saveWidget(fig, "EAreaHistogram.html", selfcontained = TRUE)

rm(fig)
fig<-S_ |> group_by(interaction) |> e_charts(time) |>
  e_datazoom(
    type = "slider",
    toolbox = FALSE,
    bottom = -5
  )|>
  e_tooltip()|>
  e_x_axis(time, axisPointer = list(show = TRUE))|>
  e_area(count, stack = "grp")

htmlwidgets::saveWidget(fig, "EArea.html", selfcontained = TRUE)


#library(pandoc)
#Get dem custom fonts
# font_import()
# loadfonts(device = "win")
# actual_pars<-as.data.frame(actual_pars)

data<-read.csv("output.csv",header = FALSE)
colnames(data) <- c(
  "HitPct1", "TotalSamples1", "HitSamples1",
  "HitPct2", "TotalSamples2", "HitSamples2","HitPct3","HitSamples3","HitPct4", "TotalSamples4", "HitSamples4","Zone"
)

#Round up values
data$HitSamples1<-ceiling(data$HitSamples1)
data$HitSamples2<-ceiling(data$HitSamples2)
data$HitSamples4<-ceiling(data$HitSamples4)
# Scatter plot for the first 2 sets of data
# Define custom theme colors
thematic_on(bg = "#FCE9D7", fg = "orange", accent = "purple",font = "Yu Gothic")
# 



# Create a unique identifier for each time unit
no_of_zones<-length(unique(data$Zone))
data$TimeUnit <- rep(seq_len(nrow(data) / no_of_zones), each = no_of_zones)

# Farm

fig_dots <- data %>%
  plot_ly(type = "scatter",
          mode = "markers+lines", line = list(width = 0.35)) %>%
  add_trace(x = ~TimeUnit,
            y = ~HitPct1,
            frame = ~Zone,  # Use TimeUnit for animation frames
            color = "Host",
            colors = c("#2A6074", "#00C9B1"),
            size = ~TotalSamples1,
            customdata = ~{
              zone_data <- data[data$TimeUnit == TimeUnit, ]
              paste(zone_data$HitSamples1, "out of ", zone_data$TotalSamples1, " hosts @ ",zone_data$TimeUnit," hours")
            },
            hovertemplate = "%{y} % of motile hosts <br> are infected  <br> ie %{customdata}") %>%
  add_trace(x = ~TimeUnit,
            y = ~HitPct3,
            frame = ~Zone,  # Use TimeUnit for animation frames
            color = "Colonized Hosts",
            colors = c("#2A6074", "#00C9B1"),
            size = ~TotalSamples1,
            customdata = ~{
              zone_data <- data[data$TimeUnit == TimeUnit, ]
              paste(zone_data$HitSamples3, "out of ", zone_data$TotalSamples1, " colonized hosts @ ",zone_data$TimeUnit," hours")
            },
            hovertemplate = "%{y} % of motile hosts <br> are colonized  <br> ie %{customdata}") %>%            
  add_trace(
    x = ~TimeUnit,
    y = ~HitPct2,
    frame = ~Zone,  # Use TimeUnit for animation frames
    color = "Deposits",
    colors = c("#FFF184", "#FFDD80"),
    size = ~TotalSamples2,
    customdata = ~{
              zone_data <- data[data$TimeUnit == TimeUnit, ]
              paste(zone_data$HitSamples2, "out of ", zone_data$TotalSamples2, " deposits @ ",zone_data$TimeUnit," hours")
            },
    hovertemplate = "%{y} % of sessile deposits <br> are infected  <br> ie %{customdata}",
    line = list(width = 0.35)
  )%>%
  add_trace(x = ~TimeUnit,
            y = ~HitPct4,
            frame = ~Zone,  # Use TimeUnit for animation frames
            color = "Faeces",
            colors = c("#2A6074", "#00C9B1"),
            size = ~TotalSamples4,
            customdata = ~{
              zone_data <- data[data$TimeUnit == TimeUnit, ]
              paste(zone_data$HitSamples4, "out of ", zone_data$TotalSamples4, " hosts @ ",zone_data$TimeUnit," hours")
            },
            hovertemplate = "%{y} % of motile hosts <br> are infected  <br> ie %{customdata}") %>%
  layout(title = "Infection Trend within cultivation",
         plot_bgcolor = '#FFF8EE',
         xaxis = list(
           title = "Time (Hours)",
           zerolinecolor = '#ffff',
           zerolinewidth = 0.5,
           gridcolor = '#F4F2F0'),
         yaxis = list(
           title = "Percentage of Infected",
           zerolinecolor = '#ffff',
           zerolinewidth = 0.5,
           gridcolor = '#F4F2F0')) %>%
  animation_slider(
    currentvalue = list(font = list(color = "darkgreen"))
  ) %>%
  animation_opts(mode = "next",
                 easing = "exp-in", redraw = FALSE
  )

# Save the animation
htmlwidgets::saveWidget(fig_dots, "scatter.html", selfcontained = TRUE)
