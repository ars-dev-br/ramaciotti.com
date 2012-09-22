---
title: Depuração como Método Científico
author: Andre Ramaciotti
tags: Programação
---

Hoje me deparei com uma [entrevista de Rob Pike][ERP], em que ele revela qual o
conselho mais importante que teve durante sua carreira como programador. Ele
conta sua experiência de programação em par com Ken Thompson e mostra a
diferença entre como os dois programadores lidavam quando acontecia algum
problema no código.

Essa história me lembrou de uma distinção que eu já havia notado entre alguns
programadores que eu conheço. O grupo com quem me identifico -- e ao qual Ken
Thompson pertence --  executa o programa normalmente (*i.e.* sem a utilização
de qualquer ferramenta de depuração) e a partir daí começa a analisar o que o
programa deveria fazer e o que ele está fazendo. Com isso, começa-se a gerar
hipóteses de por que o programa não está fazendo o que deveria. É só depois
disso que se dispara o depurador, para que então se possam verificar essas
hipóteses e ver qual delas realmente explica a diferença entre o que a
aplicação faz e o que ela deveria estar fazendo.

O outro grupo -- como Rob Pike fazia -- começa a depurar antes mesmo de ter uma
boa ideia de qual pode ser o problema que está acontecendo, na esperança de que
algo de errado salte aos seus olhos e o ilumine com o que pode estar errado. Em
vez de elaborar hipóteses e testá-las, este grupo faz uma investigação pelo
código, procurando por indícios de algo que possa estar errado.

Rob Pike conta que geralmente Ken Thompson descobria qual era o problema mais
rápido e com menos erros. Talvez isso explique a [diferença de
produtividade][DP] entre programadores mais e menos experientes na depuração de
bugs em um programa. Os mais experientes criam um modelo mental da execução
durante o programa. Eles não utilizam o depurador para ver o que o programa
está fazendo, mas sim para testar seu modelo, para descobrir porque a execução
real do programa não condiz com sua execução mental. Por isso, não importa
muito se um programador está depurando através de `printfs` ou através de um
*debugger* cheio de recursos avançados como *breakpoints* e a possibilidade de
inspecionar valores durante a execução do programa. Contanto que ele consiga
obter *feedbacks* para avaliar e melhorar seu modelo mental, as ferramentas que
ele tem disponíveis não afetarão muito sua produtividade.

De maneira inversa, de pouco adianta entregar o melhor depurador nas mãos de um
programador inexperiente e esperar que sua produtividade aumente. Depurar não é
ficar verificando os valores de todas as variáveis até que se ache algo que não
parece certo, é descobrir por que o programa não funciona como nosso modelo
mental espera.

[DP]: http://swreflections.blogspot.com.br/2012/08/fixing-bugs-theres-no-substitute-for.html
[ERP]: http://www.informit.com/articles/article.aspx?p=1941206

