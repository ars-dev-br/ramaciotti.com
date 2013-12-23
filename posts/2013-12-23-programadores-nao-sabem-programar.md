---
title: Programadores não sabem programar
author: André Ramaciotti
tags: Programação
---

Esses dias estive lendo o antigo blog do Steve Yegge e encontrei esse artigo
sobre pré-entrevistas pelo [telefone][TFA].  Não é algo que particularmente me
interesse, mas a conclusão que tiro desse artigo é perturbadora.

Primeiro, veio certa alegria: baseado nos cinco temas que o Steve aborda durante
essa etapa e seus comentários sobre as perguntas, posso dizer que eu passaria
por essa triagem com louvor.  Não sei como são as etapas subsequentes de
contratação na Amazon, mas não me parece absurdo pensar que eu conseguiria
emprego lá com certa facilidade[^n1].  No entanto, essa felicidade durou pouco.

O que me perturba é que pouquíssimos programadores que conheço pessoalmente
podem dizer o mesmo.  O que me perturba mais é que todos esses assuntos são
ensinados nas faculdades (aqui e nos EUA), e nem são tão difíceis assim.  Digo,
um dos itens é **saber programar!** Aparentemente, alguns programadores não
sabem programar!  O que me perturba ainda mais é que eu convivo, trabalho e
estudo, com essas pessoas, e trabalhar com elas não é bom.

Sei que soa como elitismo - e de fato é - mas quando se trabalha em equipe,
lidar com esse nível de disparidade é complicado.  E é difícil de explicar para
pessoas de outras áreas o quão absurda é essa diferença.  Até porque, penso eu,
esse nível de disparidade não existe em outras áreas.  Por exemplo, existem
programadores que só conseguem modificar um programa já existente; se pedidos
para implementar um novo, eles simplesmente travam (os programadores e os
programas também).  É como se alguém só conseguisse modificar textos já
escritos; peça para ela criar um novo texto, e ela não tem a menor ideia de por
onde começar.

Eu participava do processo seletivo da empresa em que eu trabalhava antes e esse
tipo de programador era assustadoramente comum.  O processo envolvia um pequeno
teste de programação, algo como:

Escreva um programa que receba uma lista de intervalos (a, b) do usuário.  Só
aceite os intervalos que não interseccionem com os intervalos já informados.
Quando o usuário informar o intervalo (0, 0), mostre os intervalos informados em
ordem decrescente de tamanho.

Se alguém chegasse a resolver o problema, só deixando de lado a ordenação, mas
de uma maneira bem organizada, eu já me dava por satisfeito.  Boa parte dos
candidatos tinha dificuldade já na obtenção dos dados.  Alguns não sabiam lidar
com coleções dinâmicas, usando um array "grande o bastante" guardar os
intervalos informados.  Outros até resolviam o problema, mas de uma forma
extremamente ineficiente e desorganizada.

Claro, nem todos chegam a esse nível, mas a disparidade continua ali.  E tentar
desenvolver alguma coisa com uma equipe assim é extremamente desgastante e
improdutivo.  É passar horas tentando descobrir porque uma parte do sistema não
funciona quando dois usuários a acessam ao mesmo tempo.  É passar mais horas
consertando esse problema.  É perder dias procurando o porquê e consertando um
programa que não funciona em anos bissextos.  É quebrar a cabeça arrumando algo
que podia ter sido feito corretamente na primeira vez.

Não quero com isso dizer que programadores precisam ser perfeitos, muito menos
que eu o seja, mas os exemplos acima já aconteceram tantas vezes, e em tantas
empresas diferentes, que se tornam evidência de que existe algo de podre na
profissão.  Voltando à analogia do escritor, erros ortográficos e pequenos erros
gramaticais às vezes acontecem, e são fáceis de se corrigirem, mas uma história
completamente inconsistente[^n2], não.

E é por isso que eu me pergunto: por que uma diferença desse tamanho é aceitável
na nossa profissão?  Por que nos parece válido deixar que os mesmos erros se
repitam para só mais tarde encarregar alguém de resolvê-los?  E, principalmente,
como podemos diminuir essa disparidade?

[^n1]: "Por que você não tenta então, bonzão?"  Porque ainda não me formei e não
pretendo me mudar de cidade (quanto mais de país) enquanto isso não acontecer.

[^n2]: A não ser que seja essa a intenção, mas, felizmente, linguagens de
programação não são pósmodernistas, exceto Perl.

[TFA]: https://sites.google.com/site/steveyegge2/five-essential-phone-screen-questions
