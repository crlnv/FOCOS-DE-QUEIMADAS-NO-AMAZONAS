#----------- SÉRIES TEMPORAIS: PROJETO - FOCOS DE QUEIMADAS NO AMAZONAS--------------------

#------BIBLIOTECAS-------------------

library(readr)
library(forecast)
library(TSA)


#------ARQUIVO CSV--------------------

# 1999-jan até 2023-dez

dados.st <- read.csv("historico_estado_amazonas - historico_estado_amazonas(2).csv") #stringsAsFactors = F

#---------Transformando os dados em uma série temporal...---------------------
x <- NULL
for(i in 1:nrow(dados.st)) x <- c(x, as.numeric(dados.st[i,]))
ts.plot(x)
z <- ts(x, start = c(1999,1), end = c(2023, 12), frequency = 12)
plot(z, main = "Subséries: focos de queimadas no Amazonas (2002-2023)", ylab = "No. de Queimadas",
     xlab = "Mês", lwd = 3, col = 'tomato')


#----- Transformação log ---------
# Para eliminar a heterocedasticidade, tomemos o log:
w <- window(z, start = c(2002,1))
w <- log(w)
ts.plot(w,  ylab = 'log', xlab = "Mês", lwd = 3, col = 'tomato',
        main = "Número mensal de focos queimadas no Amazonas (2002-2023).")  # aplicar exponencial depois # fonte: Portal Queimadas

#plot(diff(log(AirPassengers)))

#---- Monthplot --------
# monthplot mostrando um forte padrão sazonal
# Este gráfico permite-lhe detectar ambos os padrões entre grupos e dentro do grupo.
monthplot(w,lwd = 2, col =  'seagreen', col.base = 'purple',
          main = "Subséries: focos de queimadas no Amazonas (2002-2023)", ylab = "log") #sazonalidade

# Os gráficos das subséries sazonais podem fornecer respostas às seguintes questões:
# Os dados exibem um padrão sazonal?
# Qual é a natureza da sazonalidade?
# Há um padrão dentro do grupo (p.ex., Janeiro e Julho exibem padrões similares)?
# Existem outros outliers uma vez que a sazonalidade tenha sido considerada?


#---- Periodograma ---------

har <- harmonic(w)
mod.lm <- lm( w ~ har)
mod.lm

param <- coefficients(mod.lm)
# harmônico estimado
curve( param[1]+ param[2]*cos(2*pi*x/12) + param[3]*sin(2*pi*x/12),1,12, 
       ylab = 'Harmônico estimado', lwd = 2, xlab = 't', main = "Curva ")
res <- residuals(mod.lm)
ts.plot(res)
stats::acf(res)
shapiro.test(res)

#periodograma dos residuos
p2 <- periodogram(res) # periodograma apresenta um pico, abaixo mostramos que este pico é de período 6
# encontrando em qual coordenada ocorre o maior valor do periodograma
k <- which(p2$spec == max(p2$spec))
# identificando a frequência correspondente
omega <- p2$freq[k]
# identificando o período da série
1/omega
#padrão sazonal de período 6



#----- ACF E PACF -------

autocorrelacao_w <- acf(w, na.action = na.pass) # sugere um processo estacionário
plot(autocorrelacao_w, main = "ACF: focos de queimadas", col = 2, lwd = 2) 
# ACF tem ciclos correspondendo a meio ano
autocorrelacaop_w <- pacf(w, na.action = na.pass) # sugere um processo de ordem 2
plot(autocorrelacaop_w, main = "PACF: focos de queimadas", ylab = "ACF Parcial", col = 2, lwd = 2)

# o PACF sugere um processo AR(3) e o ACF sugere um processo MA(5)

#------ AUTO.ARIMA --------- 
test <- auto.arima(w, seasonal = TRUE, trace = TRUE) #modelo sugerido: ARIMA(3,0,5)(0,1,1)[12]
test <- arima(w, order = c(3,0,5), seasonal = list(order = c(0,1,1)))
acf.autoarima <- acf(test$residuals)
pacf.autoarima <- pacf(test$residuals)
plot(test$residuals, ylab = "Resíduos", xlab = "Mês", col = "purple", lwd = 3)


#------ SARIMA (3,0,5)(0,2,2) -----
# modelo arima sazonal (3,0,5)(0,2,2) // ARMA (3,5) com componente de sazonalidade
mod <- Arima(w, order = c(3,0,5), seasonal = list(order = c(0,2,2)))
acf.autoarima <- acf(mod$residuals, col = 2)
acf.mod <- plot(acf.autoarima, main = "ACF: FOCOS DE QUEIMADAS", col = 2, lwd = 2)
pacf.autoarima <- pacf(mod$residuals)
pacf.mod <- plot(pacf.autoarima, main = "PACF: FOCOS DE QUEIMADAS", ylab = "ACF PARCIAL", col = 2, lwd = 2)
plot(mod$residuals, main = "Resíduos", xlab = "Mês", lwd = 3, ylab = "", col = "tomato")
abline(h=0, lwd=2, col=2, lty=2)
Box.test(mod$residuals) # passou
shapiro.test((mod$residuals)) # não passou ;-;
hist(mod$residuals) # detectar outl
detectIO(mod)



#---- PREVISÃO ----

autoPred <- forecast(mod, h=24)
autoPred$mean <- exp(autoPred$mean)
autoPred$lower <- exp(autoPred$lower)
autoPred$upper <- exp(autoPred$upper)
autoPred$x <- exp(autoPred$x)
autoPred$fitted <- exp(autoPred$fitted)
autoPred$residuals <- exp(autoPred$residuals)
plot(autoPred, main = "Previsão do Modelo SARIMA (3,0,5)(0,2,2)",
     xlab = "t", col = "black", lwd = 2)
        
        
plot(autoPred$residuals)      









