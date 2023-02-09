##  A scrollytelling primer on hypoxia

This hyopxia primer educates readers on the California Current Excosystem and it's changing oxygen levels over the past 71 years. This project was created to inform community members about a climate related issues in a compelling and interactive way. To achieve this, we utilized the [parallaxr](https://github.com/martinctc/parallaxr) package in R to generate a scrolly-telling document that utilzies both images and text. We used parallaxr as it was a very user friendly way to create a scrolling document, and one that did not require html background knowledge. One challenge of the parallaxr package is that it requires one side of each page to be an image, and the other to be text. We found ourselves wanting to implement text on both sides on some pages, but were unable to do this. Another challenge of this package is that it does not adjust image sizes based on screen sizes. Therefore, some of our images were cut off on certain computers. 

# Execution Instructions
The html output is rendered by running the parallax R file. This script parses through the different markdowns files that are in the markdown folder in your working directory. After looping through each markdown file, a row binding tibble is returned. The generate_scroll_doc function then takes the tibble, knits the markdown files together in alphabetical/numerical order, and creates an html file in your working directory. 

# Project file description

•bottle.Rdata : CalCOFI dataset used to create interactive graphs

•Parallax > Markdown: Individual markdown files 

•Parallax> Images: Png files of each image that is sourced in the markdown file

•Parallax_draft_script.R : Script to generate parallax document

•parallax-draft-output.html: Html file outputted my parallax script

•interactive_graphs.R : scripts for creating time series interactive plot and interative heatmap

•Widgets: html widgets to include interactive graphs in parallax document 

# References 
Breitburg, Denise, et al. “The Ocean Is Losing Its Breath: Declining Oxygen in the World's Ocean and Coastal Waters; Summary for Policy Makers.” 2018, https://unesdoc.unesco.org/ark:/48223/pf0000265196.

“California Current Region.” California Current Region | National Marine Ecosystem Status, https://ecowatch.noaa.gov/regions/california-current.

Gallo, Natalya D., et al. “Bridging from Monitoring to Solutions-Based Thinking: Lessons from Calcofi for Understanding and Adapting to Marine Climate Change Impacts.” Frontiers in Marine Science, vol. 6, 2019, https://doi.org/10.3389/fmars.2019.00695.

Limburg, Karin E., et al. “Ocean Deoxygenation: A Primer.” One Earth, vol. 2, no. 1, 2020, pp. 24-29., https://doi.org/10.1016/j.oneear.2020.01.001.

“Midwestern Regional Climate Center.” MRCC, https://mrcc.purdue.edu/mw_climate/elNino/climatology.jsp#:~:text=the%20definition%20of%20a%20strong,%2D83%20and%201997%2D98.

Nam, SungHyun, et al. “Amplification of Hypoxic and Acidic Events by La Niña Conditions on the Continental Shelf off California.” AGU Publications - Wiley Online Library , https://agupubs.onlinelibrary.wiley.com/.

Quan, Jenna. “What Is Coastal Upwelling and Why Is It Important?” Coastal and Marine Sciences Institute, 23 Mar. 2021, https://marinescience.ucdavis.edu/blog/upwelling.

Ren, Alice S., et al. “A Sixteen-Year Decline in Dissolved Oxygen in the Central California Current.” Nature News, Nature Publishing Group, 8 May 2018, https://www.nature.com/articles/s41598-018-25341-8.

University of California Television. “Research for Resilience on a Changing Planet - The California Cooperative Oceanic Fisheries Investigations.” UCTV, University of California Television, https://www.uctv.tv/shows/Research-for-Resilience-on-a-Changing-Planet-The-California-Cooperative-Oceanic-Fisheries-Investigations-37033.


# Credits
This project was created by data storytelling interns with CalCOFI and California Sea Grant, Mallika Gupta and Annie Adams

