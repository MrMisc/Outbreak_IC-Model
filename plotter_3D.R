
#! /usr/bin/Rscript

f<-file("stdin")
open(f)
record<-c()
while(length(line<-readLines(f,n=1))>0){
  #write(line,stderr())
  record<-c(record,line)  
}


numbers<-record[1:length(record)-1]
numbers_<-c()


print(getwd())

# Plot heatmap
library(ggplot2)
library(pandoc)
library(plotly)

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

for (separate_zone in zone_unique2){
  # print(typeof(separate_zone))
  data_<-subset(data, zone == separate_zone)
  
  data_ <- data_ %>% 
      mutate(interaction = case_when(
        interaction == 1000 ~ "marker",
          interaction == 0 ~ "Host 0",
          interaction == 1 ~ "Host <-> Host",
          interaction == -2 ~ "Host -> Egg",
          interaction == -3 ~ "Host -> Faeces",
          interaction == 4 ~ "Egg <-> Egg",
          interaction == -6 ~ "Egg -> Faeces",
          interaction == 9 ~ "Faeces <-> Faeces",
          interaction == 2 ~ "Egg -> Host",
          interaction == 3 ~ "Faeces -> Host",
          interaction == 6 ~ "Faeces -> Egg",
          interaction == 10~ "Feed infection",
          interaction == 11~ "Eviscerator -> Host",
          interaction == 12~ "Host -> Eviscerator",
          TRUE ~ as.character(interaction)
      ),
      shapes = case_when(
        interaction == "Host 0" ~ "square",  
        interaction == "Host <-> Host" ~ "circle",
        interaction == "Host -> Egg" ~ "star",
        interaction == "Host -> Faeces" ~ "hexagram",
        interaction == "Egg <-> Egg" ~ "x",
        interaction == "Egg -> Faeces" ~ "star-x",
        interaction == "Faeces <-> Faeces" ~ "asterisk",
        interaction == "Feed infection" ~ "asterisk",
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

  # Apply the custom color scale to the plot
  # fig$x$data[[1]]$marker$colorscale <- custom_color_scale
  # fig <- fig %>% add_markers()
  #Factor
  f<-max(x_large[count],y_large[count],z_large[count])/200
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




  #Time series plot animation
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




  count<-count+1
  rm(fig)
}

print("First section generation complete!")



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

















#HEATMAP

# summary_data <- data %>%
#   group_by(x, y, zone, time) %>%
#   summarise(count = n())



# # Create the ggplot2 plot with geom_tile and fill based on count
# heatmap_plot <- ggplot() +
#   geom_tile(data = summary_data, aes(x = x, y = y, fill = count, frame = zone), width = 1, height = 1) +
#   scale_fill_gradient(low = "beige", high = "red") +  # You can choose other color scales
#   labs(title = "Heatmap of Event Counts")+
#   coord_cartesian(ylim = c(min(data$y), max(data$y)), xlim = c(min(data$x), max(data$x)))

# # Convert ggplot to plotly
# heatmap_interactive <- ggplotly(heatmap_plot, dynamicTicks = TRUE)

# # Save as HTML using pandoc
# htmlwidgets::saveWidget(heatmap_interactive, "heatmap_output.html", selfcontained = TRUE)
# print("Heatmap generated successfully!")





# print("Data interaction column is")
# print(data$interaction)
# print("When summarised we get the following")



# summary_data <- data %>%
#   group_by(interaction, time) %>%
#   summarise(count = n()) %>%
thematic::thematic_on(bg = "#fff6eb", fg = "#005B4B", accent = "#005B4B", font = "Yu Gothic")
data <- data %>% 
    mutate(interaction = case_when(
        interaction == 1000 ~ "marker",
          interaction == 0 ~ "Host 0",
          interaction == 1 ~ "Host <-> Host",
          interaction == -2 ~ "Host -> Egg",
          interaction == -3 ~ "Host -> Faeces",
          interaction == 4 ~ "Egg <-> Egg",
          interaction == -6 ~ "Egg -> Faeces",
          interaction == 9 ~ "Faeces <-> Faeces",
          interaction == 2 ~ "Egg -> Host",
          interaction == 3 ~ "Faeces -> Host",
          interaction == 6 ~ "Faeces -> Egg",
          interaction == 10~ "Feed infection",
          interaction == 11~ "Eviscerator -> Host",
          interaction == 12~ "Host -> Eviscerator",
        TRUE ~ as.character(interaction)
    ))



fig <- ggplot(data, aes(x = time, fill = as.factor(interaction))) +
  geom_bar(position = "dodge") + facet_wrap(.~zone)+
  labs(title = "Bar Plot of Interaction Counts Over Time", x = "Time", y = "Count")

fig <- ggplotly(fig, dynamicTicks = TRUE)

htmlwidgets::saveWidget(fig, "Histogram.html", selfcontained = TRUE)

  S <- data %>%
    group_by(interaction,zone,time) %>%
    summarise(count = n()) %>%
    ungroup()


fig <- ggplot(S, aes(y = count,x = time, color = as.factor(interaction))) +
  geom_line() + facet_wrap(.~zone) +
  labs(title = "Interaction Counts Over Time", x = "Time", y = "Count")

fig <- ggplotly(fig, dynamicTicks = TRUE)

htmlwidgets::saveWidget(fig, "Line.html", selfcontained = TRUE)




# # Create the ggplot2 plot with geom_tile and the custom color scale
# heatmap_plot <- ggplot() +
#   geom_tile(data = summary_data, aes(x = x, y = y, fill = count, frame = time), width = 1, height = 1) +
#   scale_fill_gradient(low = "beige", high = "red") +  # Use the custom color scale
#   labs(title = "Heatmap of Event Counts") +
#   coord_cartesian(ylim = c(min(data$y), max(data$y)), xlim = c(min(data$x), max(data$x)))

# # Convert ggplot to plotly
# heatmap_interactive <- ggplotly(heatmap_plot, dynamicTicks = TRUE)

# htmlwidgets::saveWidget(heatmap_interactive, "heatmap_output_time.html", selfcontained = TRUE)
# print("Heatmap timeseries generated successfully!")



# zone_unique <- unique(zone)
# zone_plots <- list()


# for (z in zone_unique) {
#   data_zone <- data.frame(x = x[zone == z], y = y[zone == z], time = time[zone == z], zone = zone[zone == z])
  
#   # Create the ggplot2 plot with geom_tile and custom color scale
#   summary_data <- data_zone %>%
#     group_by(x, y, zone, time) %>%
#     summarise(count = n())
  
#   custom_color_scale <- scale_fill_gradient(low = "beige", high = "red")
  
#   heatmap_plot <- ggplot() +
#     geom_tile(data = summary_data, aes(x = x, y = y, fill = count, frame = time), width = 1, height = 1) +
#     custom_color_scale +
#     labs(title = paste("Zone", z, ": Heatmap of Event Counts")) +
#     coord_cartesian(ylim = c(min(data$y), max(data$y)), xlim = c(min(data$x), max(data$x)))
  
#   # Convert ggplot to plotly
#   heatmap_interactive <- ggplotly(heatmap_plot, dynamicTicks = TRUE)
  
#   # Save the plot as an HTML file with a unique name based on the zone
#   html_filename <- paste("heatmap_timeseries_zone_", z, ".html", sep = "")
#   htmlwidgets::saveWidget(heatmap_interactive, html_filename, selfcontained = TRUE)
# }


# print("Heatmap timeseries generated successfully!")


#Another try at 2d hist using geom_tile


# # Create a data frame for the entire data
# data_all <- data.frame(x = x, y = y, zone = zone)

# # Create the animated heatmap
# heatmap_plot <- ggplot(data_all, aes(x, y, frame = factor(zone))) +
#   geom_tile(aes(fill = ..density..), bins = 5) +
#   scale_fill_gradient(low = "#34FCEC", high = "#B102E9") +
#   labs(title = "2D Histogram of Occurrences")

# # Convert ggplot to ggplotly
# heatmap_interactive <- ggplotly(heatmap_plot)

# # Save as HTML using pandoc
# htmlwidgets::saveWidget(heatmap_interactive, "animated_2dhistogram.html", selfcontained = TRUE)



# ##Heatmap (2d histogram)
# custom_colorscale <- c("#34FCEC", "#00D3FF", "#0099FF", "#B102E9")
# hist2d <- plot_ly(data = data, x = ~x, y = ~y, type = "histogram2d",xbins = list(start = min(data$x), end = max(data$x), size = 10, colors = custom_colorscale),
#                   ybins = list(start = min(data$y), end = max(data$y), size = 10),
#                   marker = list(colorscale = custom_colorscale)) %>%
#   layout(title = "2D Histogram of Occurrences",
#          xaxis = list(title = "X"),
#          yaxis = list(title = "Y"),
#          plot_bgcolor = '#FFF8EE',
#          xaxis = list(
#            zerolinecolor = '#ffff',
#            zerolinewidth = 0.5,
#            gridcolor = '#F4F2F0'),
#          yaxis = list(
#            zerolinecolor = '#ffff',
#            zerolinewidth = 0.5,
#            gridcolor = '#F4F2F0'))
# # Save interactive plot as HTML using pandoc
# htmlwidgets::saveWidget(hist2d, "Heatmap_2dHistogram.html", selfcontained = TRUE)









#Hexbin heatmap plot?

# hexbin_plot <- plot_ly(x = x, y = y, type = "scatter", mode = "markers",
#                        marker = list(symbol = "hexagon", size = 10,
#                                      opacity = 0.7, line = list(width = 0)),
#                        colors = "rgba(255,255,255,0.0)", fill =~zone) %>%
#   layout(title = "Hexbin Plot Example",
#          xaxis = list(title = "X"),
#          yaxis = list(title = "Y"))

# # Save interactive plot as HTML using pandoc
# htmlwidgets::saveWidget(hexbin_plot, "hexbin_plot.html", selfcontained = TRUE)




# data <- data.frame(x = x, y = y, time = time)

# surface_plot <- plot_ly(data, x = ~x, y = ~y, z = ~time,
#                         type = "surface", colorscale = "Viridis",
#                         colorbar = list(title = "Time"),
#                         showscale = TRUE) %>%
#   layout(title = "Surface Plot Example",
#          scene = list(
#            xaxis = list(title = "X"),
#            yaxis = list(title = "Y"),
#            zaxis = list(title = "Time"))
#   )

# # Save interactive plot as HTML using pandoc
# htmlwidgets::saveWidget(surface_plot, "surface_plot.html", selfcontained = TRUE)






#library(pandoc)
#Get dem custom fonts
# font_import()
# loadfonts(device = "win")
# actual_pars<-as.data.frame(actual_pars)

data<-read.csv("output.csv",header = FALSE)
colnames(data) <- c(
  "HitPct1", "TotalSamples1", "HitSamples1",
  "HitPct2", "TotalSamples2", "HitSamples2","Zone"
)

#Round up values
data$HitSamples1<-ceiling(data$HitSamples1)
data$HitSamples2<-ceiling(data$HitSamples2)
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
  ) %>%
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



# #Collection

# fig_dots<-data%>%plot_ly(type="scatter",
#           mode = "markers+lines",line = list(width=0.35))%>%
#   add_trace(x = time,
#           y = ~HitPct3,
#           color ="Host",
#           colors=c("#2A6074","#00C9B1"),
#           size = ~TotalSamples3,
#           customdata = ~paste(HitSamples3, "out of ", TotalSamples3," hosts"),
#           hovertemplate="%{y} % of motile hosts <br> are infected  <br> ie %{customdata}")


# fig_dots<-fig_dots %>%
#   add_trace(
#     x = ~time,
#     y = ~HitPct4,
#     color = "Deposits",
#     colors = c("#FFF184", "#FFDD80"),  # Reversed color order
#     size = ~TotalSamples4,
#     customdata = ~paste(HitSamples4, "out of ", TotalSamples4," deposits"),
#     hovertemplate = "%{y} % of sessile deposits <br> are infected  <br> ie %{customdata}",
#     line = list(width = 0.35)
#   ) %>%
#   layout(title = "Infection Trend within collection",
#          plot_bgcolor = '#FFF8EE',
#          xaxis = list(
#           title = "Time (Hours)",
#            zerolinecolor = '#ffff',
#            zerolinewidth = 0.5,
#            gridcolor = '#F4F2F0'),
#          yaxis = list(
#           title = "Percentage of Infected",
#            zerolinecolor = '#ffff',
#            zerolinewidth = 0.5,
#            gridcolor = '#F4F2F0'))


# htmlwidgets::saveWidget(fig_dots, "scatter_plot_2.html", selfcontained = TRUE)




# #Overall

# # print(data$HitSamples1)
# # print(data$HitSamples3)
# # print(data$HitSamples1+data$HitSamples3)

# data$totalhits_motile<-data$HitSamples1+data$HitSamples3
# data$totalhits_sessile<-data$HitSamples2+data$HitSamples4

# data$Total_motile<-data$TotalSamples1+data$TotalSamples3
# data$Total_sessile<-data$TotalSamples2+data$TotalSamples4

# data$totalperc_motile<-data$totalhits_motile/data$Total_motile*100
# data$totalperc_sessile<-data$totalhits_sessile/data$Total_sessile*100

# fig_dots<-data%>%plot_ly(type="scatter",
#           mode = "markers+lines",line = list(width=0.35))%>%
#   add_trace(x = time,
#           y = ~totalperc_motile,
#           color ="Host",
#           colors=c("#2A6074","#00C9B1"),
#           size = ~Total_motile,
#           customdata = ~paste(totalhits_motile, "out of ", Total_motile," hosts"),
#           hovertemplate="%{y} % of motile hosts <br> are infected  <br> ie %{customdata}")


# fig_dots<-fig_dots %>%
#   add_trace(
#     x = ~time,
#     y = ~totalperc_sessile,
#     color = "Deposits",
#     colors = c("#FFF184", "#FFDD80"),  # Reversed color order
#     size = ~Total_sessile,
#     customdata = ~paste(totalhits_sessile, "out of ", Total_sessile," deposits"),
#     hovertemplate = "%{y} % of sessile deposits <br> are infected  <br> ie %{customdata}",
#     line = list(width = 0.35)
#   ) %>%
#   layout(title = "Infection Trend across population",
#          plot_bgcolor = '#FFF8EE',
#          xaxis = list(
#           title = "Time (Hours)",
#            zerolinecolor = '#ffff',
#            zerolinewidth = 0.5,
#            gridcolor = '#F4F2F0'),
#          yaxis = list(
#           title = "Percentage of Infected",
#            zerolinecolor = '#ffff',
#            zerolinewidth = 0.5,
#            gridcolor = '#F4F2F0'))


# htmlwidgets::saveWidget(fig_dots, "scatter_plot_final.html", selfcontained = TRUE)
