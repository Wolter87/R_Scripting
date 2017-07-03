#benodigde packages. een keer installeren is voldoende
install.packages("data.table")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("plotly")

#benodigde libraries, elke keer draaien nadat de pc (of eigenlijjk R) opnieuw is opgestart.
library(data.table) # voor de %between% operator
library(dplyr)      # voor tally functie en %>% (pipeline) operator
library(plotly)     # voor plotly functie
library(ggplot2)    # voor ggplot functie

#data, even het pad aanpassen nog, stringsAsFactors staat op false zodat alles als character gezien wordt. Hierdoor werkt het zoeken op datum makkelijker.
dat <- read.csv("C:/Users/Wolter/Documenten/School/HvA HBO ICT/Sample data (opgemaakt, dataveld weg).csv", header=TRUE, stringsAsFactors=FALSE)

#Een 'samenvatting' van de data, zelf gebruik ik dit als count functie.
dat %>% group_by(Datum, Tegel) %>% tally()

#opzetten data voor barplot die met plotly wordt gemaakt.
Tegelcount <- dat %>% group_by(Tegel) %>% tally() #getting the count of Tegel, group by Tegel
colnames(Tegelcount) <- c("Tegel", "Frequency") #kolomnaam van N veranderen naar frequency
Tegelcount[with(Tegelcount, order(Frequency)), ] #sort on Frequency

#tabel voor hoe vaak elke tegel voor komt, maakt gebruik van opgebouwde data hierboven.
library(plotly)
plot_ly(
  Tegelcount,
  y = ~Frequency,
  x = ~Tegel,
  type = "bar"
)

#aanmaken nieuwe kolom van datum en tijd en omzetten naar POSIXct. Deze wordt hierna gebruikt in de ggplot eronder.
dat$DateTime <- with(dat, as.POSIXct(paste(Datum, Tijd), format="%Y-%m-%d %H:%M:%S"))
ggplot(aes(y = DateTime, x = Tegel), data = dat) + geom_point()

#shiny app voorbeeld
library(shiny)
runExample("01_hello")

dat[dat$Vloer == "12FR", ]
subset(dat, Datum %between% c("2016-03-06", "2016-03-08"))