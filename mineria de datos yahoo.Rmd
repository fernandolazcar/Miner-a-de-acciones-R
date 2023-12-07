---
title: "minería de datos yahoo"
author: "Fernando Lazcano Cardenas"
date: "2023-12-05"
output: html_document
---
## carga de librerias 
## charger the librarys 

```{r}
library(scales)
library(ggplot2)
library(tidyverse)
library(rvest)
library(dplyr)

```


cargamos la pagina de acciones ganadoras y creamos nuestras variables donde se guardara nuestra informacion en este caso 

pr = crecimiento / growth 
sectors = sectores 


we charger the siteweb for  winners stocks and create ours varibales where we safe our information


```{r}
w = "https://finance.yahoo.com/gainers?offset=0&count=100"

symbols <- w %>%
  read_html() %>%
  html_nodes(".simpTblRow a") %>%
  html_text()

pr <- w %>%
  read_html() %>%
  html_nodes("#scr-res-table td:nth-child(5) span") %>%
  html_text()

sectors <- vector("character", length(symbols))


```

primera iteracion 
First  iteration


```{r}
for (i in seq_along(symbols)) {
  symbol_url <- paste0("https://finance.yahoo.com/quote/", symbols[i], "/profile?p=", symbols[i])
  
  sector <- symbol_url %>%
    read_html() %>%
    html_element("#Col1-0-Profile-Proxy > section > div.asset-profile-container > div > div > p.D\\(ib\\).Va\\(t\\) > span:nth-child(2)") %>%
    html_text()
  
  sectors[i] <- sector
}

```


creamos otra variable llamada industria en la cual podamos ver precisamente las industrias que estan en crecimiento, y hacemos otra iteración para que haga la extracción de información


we create another variable call it industries in there we can look the industries that are growth and we make another iteration for  extract the information 

```{r}
industria <- vector("character", length(symbols))

for (i in seq_along(symbols)) {
  symbol_url <- paste0("https://finance.yahoo.com/quote/", symbols[i], "/profile?p=", symbols[i])
  
  Industriax <- symbol_url %>%
    read_html() %>%
    html_element("#Col1-0-Profile-Proxy > section > div.asset-profile-container > div > div > p.D\\(ib\\).Va\\(t\\) > span:nth-child(5)") %>%
    html_text()
  
  industria[i] <- Industriax
}


```


Ahora hacemos la matriz de vetores que nos ayudaran a graficar nuestros sectores e industrias ganadoras y poder ver nuestro dataframe.


Now we do the matrix of vectors that we help us to graph our sectors and industries and we can see our dataframe
```{r}
c <- cbind(symbols, pr, sectors, industria)
c <- as.data.frame(c)
c
```
comprobamos las caracteristicas de nuestro dataframe usando la función str (), la cual nos da valores en caracter.

we check it the characteristics of dataframe use the function str(), the when give us the values in character 

```{r}
str(c)
```

```{r}
fcs<- table(c$sectors)
pie(fcs)
```

Ahora podemos ver nuestro grafico de pastel donde apreciamos cuales son las industrias que mas han crecido el dia de hoy, pero esto aun no muestra, el crecimiento real de las industrias ya que no estamos considerando la variable "pr" que es el rendimiento, sino que es la suma de los sectores con crecimiento.

y en el dataframe de  industrias contemplamos lo que son el crecimiento de cada una de ellas contabilizadas 

Now we can see the pie graph  where we can appreciate which are the industries with more growth day by day but this don't show us, the real growth of the industries because we don't consider variable 'pr' that is the returns of the factors with the growth, but there are the sum  of the factors growth

```{r}
fci<- table(c$industria)
fci <- as.data.frame(fci)
#lo cambiamos a valor numerico 
str(fci)
fci$Freq <- as.numeric(fci$Freq)  
fci$Var1 <- as.character(fci$Var1)


fci
```


```{r}

ggplot(fci, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Histograma de Frecuencias", x = "Categoría", y = "Frecuencia") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  theme(axis.text.x = element_text(size = 8))  # Puedes ajustar el tamaño de la tipografía según tus preferencias

```
Asi Podemos ver el gráfico de las frecuencias de las industrias con crecimiento y podemos  realizar el mismo proceso para las industrias predadores 

Overwhile we can see the graph of the frequency of the industries and create the same process with the industry's losers


#industrias perdedoras


```{r}


l <- "https://finance.yahoo.com/losers?offset=0&count=100"


symbols_p <- l %>%
  read_html() %>%
  html_nodes(".simpTblRow a") %>%
  html_text()


pr_p <- l %>%
  read_html() %>%
  html_nodes("#scr-res-table td:nth-child(5) span") %>%
  html_text()

sectors_p <- vector("character", length(symbols_p))


for (i in seq_along(symbols_p)) {
  symbol_url <- paste0("https://finance.yahoo.com/quote/", symbols_p[i], "/profile?p=", symbols_p[i])
  
  sector_p <- symbol_url %>%
    read_html() %>%
    html_element("#Col1-0-Profile-Proxy > section > div.asset-profile-container > div > div > p.D\\(ib\\).Va\\(t\\) > span:nth-child(2)") %>%
    html_text()
  
  sectors_p[i] <- sector_p
}


industria_p <- vector("character", length(symbols))


for (i in seq_along(symbols_p)) {
  symbol_url <- paste0("https://finance.yahoo.com/quote/", symbols_p[i], "/profile?p=", symbols_p[i])
  
  Industriax_p <- symbol_url %>%
    read_html() %>%
    html_element("#Col1-0-Profile-Proxy > section > div.asset-profile-container > div > div > p.D\\(ib\\).Va\\(t\\) > span:nth-child(5)") %>%
    html_text()
  
  industria_p[i] <- Industriax_p
}


p <- cbind(symbols_p, pr_p, sectors_p, industria_p)


p <- as.data.frame(p)

fps <- table(p$sectors_p)
pie(fps)



```



