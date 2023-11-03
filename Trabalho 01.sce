//Trabalho 01
//autores: Vinicius Teixeira Costa (475758) e Tailson Alves

clear;
clc;

// FUNÇÕES PARA A PRESSÃO DO PEDAL

function baixaPressao = pressaoPedalBaixa(x)
    if x < 50 then
        baixaPressao = (50 - x) / 50;
    else baixaPressao = 0;
    end
endfunction

function mediaPressao = pressaoPedalMedia(x)
    if (30>= x) | (x>=70) then
        mediaPressao = 0;
    elseif (30<x) & (x<=50) then
        mediaPressao = (x - 30)/20;
    elseif (50<=x) & (x<70) then
        mediaPressao = (70-x)/20;
    end
endfunction

function altaPressao = pressaoPedalAlta(x)
    if x > 50 then
        altaPressao = (x - 50)/50
    else altaPressao = 0;
    end
endfunction

// FUNÇÕES PARA A VELOCIDADE DA RODA

function baixaVelocidadeRoda = velocidadeRodaBaixa(x)
    if x >= 60 then
        baixaVelocidadeRoda = 0;
    elseif x < 60 then
        baixaVelocidadeRoda = (60-x)/60;
    end
endfunction

function mediaVelocidadeRoda = velocidadeRodaMedia(x)
    if (20 >= x) | (x >= 80) then
        mediaVelocidadeRoda = 0;
    elseif (20 < x) & (x <= 50) then
        mediaVelocidadeRoda = (x - 20)/30;
    elseif (50 < x) & (x < 80) then
        mediaVelocidadeRoda = (80 - x)/30;
    end
endfunction

function rapidaVelocidadeRoda = velocidadeRodaRapida(x)
    if x <= 40 then
        rapidaVelocidadeRoda = 0;
    elseif x > 40 then
        rapidaVelocidadeRoda = abs((x - 40)/60);
    end
endfunction

// FUNÇÕES PARA A VELOCIDADE DO CARRO

function baixaVelocidadeCarro = velocidadeCarroBaixa(x)
    if x >= 60 then
        baixaVelocidadeCarro = 0;
    elseif x < 60 then
        baixaVelocidadeCarro = (60 - x)/60;
    end
endfunction

function mediaVelocidadeCarro = velocidadeCarroMedia(x)
    if (20 >= x) | (x >= 80) then
        mediaVelocidadeCarro = 0;
    elseif (20 < x) & (x < 50) then
        mediaVelocidadeCarro = (x - 20)/30;
    elseif (50 <= x) & (x < 80) then 
        mediaVelocidadeCarro = (80 - x)/30;
    end
endfunction

function rapidaVelocidadeCarro = velocidadeCarroRapida(x)
    if x <= 40 then
        rapidaVelocidadeCarro = 0;
    elseif x > 40 then
        rapidaVelocidadeCarro = abs((x - 40)/60);
    end
endfunction


// REGRAS

function regra1 = regra1(pressaoPedal)
    regra1 = pressaoPedalMedia(pressaoPedal);
endfunction

function regra2 = regra2(pressaoPedal, velocidadeCarro, velocidadeRoda)
    a = pressaoPedalAlta(pressaoPedal);
    b = velocidadeCarroRapida(velocidadeCarro);
    c = velocidadeRodaRapida(velocidadeRoda);
    regra2 = min(a, b, c);
endfunction

function regra3 = regra3(pressaoPedal, velocidadeCarro, velocidadeRoda)
    a = pressaoPedalAlta(pressaoPedal);
    b = velocidadeCarroRapida(velocidadeCarro);
    c = velocidadeRodaBaixa(velocidadeRoda);
    regra3 = min(a, b, c);   
endfunction

function regra4 = regra4(pressaoPedal)
    regra4 = pressaoPedalBaixa(pressaoPedal);
endfunction

// DESNEBULIZAÇÃO

function libera = liberar(p)
    libera = (100 - p)/100;
endfunction

function aperta = apertar(p)
    aperta = p/100;
endfunction

function resp = desnebulizacao(apertaFreio, liberaFreio)
    soma1 = 0;
    soma2 = 0;
    
    for x = 0:1:100
        a = apertar(x);
        l = liberar(x);
        
        if (liberaFreio <= l) & (liberaFreio >= a) then
            soma1 = soma1 + (liberaFreio*x);
            soma2 = soma2 + liberaFreio;
        elseif (liberaFreio >= l) & (l>=a) then
            soma1 = soma1 + (l*x);
            soma2 = soma2 + l;
        elseif (liberaFreio <= l) & (liberaFreio >= apertaFreio) then
            soma1 = soma1 + (liberaFreio*x);
            soma2 = soma2 + liberaFreio;
        elseif (liberaFreio>=l) & (l >= apertaFreio) then
            soma1 = soma1 + (l*x);
            soma2 = soma2 + l;
        elseif (liberaFreio >= l) & (apertaFreio <= l) then
            soma1 = soma1 + (l*x);
            soma2 = soma2 + l;
        elseif a >= apertaFreio then
            soma1 = soma1 + (apertaFreio*x);
            soma2 = soma2 + apertaFreio;
        elseif (a <= apertaFreio) & (a >= liberaFreio) then
            soma1 = soma1 + (a*x);
            soma2 = soma2 + a;
        end
    end
    resp = soma1/soma2;
endfunction

//_______________________MAIN____________________________

// ENTRADA DOS VALORES

pressaoPedal = input("Valor da pressão do pedal: ");
velocidadeRoda = input("Valor da pressão da velocidade da roda: ");
velocidadeCarro = input("Valor da pressão da velocidade do carro: ");



r1 = regra1(pressaoPedal);
r2 = regra2(pressaoPedal, velocidadeCarro, velocidadeRoda);
r3 = regra3(pressaoPedal, velocidadeCarro, velocidadeRoda);
r4 = regra4(pressaoPedal);

aplicarFreio = r1 + r2;
liberarFreio = r3 + r4;

pressaoFreio = desnebulizacao(aplicarFreio, liberarFreio);


printf("\nPressão do Pedal\n");
printf("Baixa Pressão(%f)= %f\n", pressaoPedal, pressaoPedalBaixa(pressaoPedal));
printf("Média Pressão(%f)= %f\n", pressaoPedal, pressaoPedalMedia(pressaoPedal));
printf("Alta Pressão(%f)= %f\n", pressaoPedal, pressaoPedalAlta(pressaoPedal));

printf("\nVelocidade da Roda\n");
printf("Velocidade da Roda Baixa(%f)= %f\n", velocidadeRoda, velocidadeRodaBaixa(velocidadeRoda));
printf("Velocidade da Roda Média(%f)= %f\n", velocidadeRoda, velocidadeRodaMedia(velocidadeRoda));
printf("Velocidade da Roda Alta(%f)= %f\n", velocidadeRoda, velocidadeRodaRapida(velocidadeRoda));

printf("\nVelocidade do Carro\n");
printf("Velocidade do Carro Baixa(%f)= %f\n", velocidadeCarro, velocidadeCarroBaixa(velocidadeCarro));
printf("Velocidade do Carro Média(%f)= %f\n", velocidadeCarro, velocidadeCarroMedia(velocidadeCarro));
printf("Velocidade do Carro Rápida(%f)= %f\n", velocidadeCarro, velocidadeCarroRapida(velocidadeCarro));

printf("\nRegra 1: %f\nRegra 2: %f\nRegra 3: %f\nRegra 4: %f\n", r1, r2, r3, r4);

printf("\nAperte o Freio: %f\nLibere o Freio: %f\n", aplicarFreio, liberarFreio);

printf("\nPressão do Freio: %f", pressaoFreio);
