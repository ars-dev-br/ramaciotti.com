---
title: Programar em C++
author: André Ramaciotti
tags: C++
---

Num primeiro momento, programar em C++ pode não parecer muito complicado.
Afinal, é apenas C com classes, certo?

Errado.  E, apesar de sua similaridade sintática com C, escrever um programa
corretamente em C++ é muito mais complicado.  Isso acontece não por causa da
orientação a objetos em si, mas pelo contexto em que ela foi inserido: se
utilizar herança corretamente muitas vezes já é um desafio, imagine misturá-la a
gerenciamento manual de memória.

Some à herança e ao gerenciamento manual de memória sobrecarga de operadores,
referências, referências constantes, *templates,* ponteiros, ponteiros
constantes, ponteiros para constantes, ponteiros constantes para constantes... e
o caos surge.

Felizmente, há onde procurar ajuda.  Separei alguns livros que me foram úteis
durante projetos escritos em C++.  A maioria deles foi escrita em formato de
referência, então não se preocupe em decorar todas as regras, apenas dê uma
folheada para saber o que eles contêm e os mantenha por perto para quando forem
necessários.


Para quem está começando
------------------------

[Thinking in C++][TIC], de Bruce Eckel.  Um livro excelente para quem já sabe
programar, mas quer aprender C++ e quer descobrir o que ele tem a oferecer.
Esse livro pode, legalmente, ser baixado diretamente da página do autor.

[TIC]: http://mindview.net/Books/TICPP/ThinkingInCPP2e.html


Para quem quer melhorar
-----------------------

[Effective C++][EffC], de Scott Meyers.  Dividido por assuntos e por itens, só
seu índice já é uma ótima lista de sugestões de o que deve ou não ser feito num
programa escrito em C++.  Caso se esteja compilando o projeto com o `g++`,
pode-se usar a opção `-Weffc++` (que **não** é ativada pela opção `-Wall`) para
que o compilador gere avisos referentes a alguns dos itens deste livro.

[More Effective C++][MEffC], de Scott Meyers.  Uma “continuação” do livro
anterior.  Criticam-no um pouco por ter saído logo após o primeiro; por que não
ter lançado um livro só?  Tirando isso, é um bom livro, e consiste de tópicos
que não foram apresentados no primeiro livro da série.

[Effective STL][ES], de Scott Meyers.  Um livro feito no mesmo formato dos dois
anteriores, mas voltado exclusivamente ao uso da STL.

[Exceptional C++][ExcptC], de Herb Sutter.  Apesar de discutir outros assuntos
também, o ponto central deste livro é como usar exceções corretamente em C++, um
ponto importante e que não é tão simples de se fazer corretamente.

[More Exceptional C++][MExcptC], de Herb Sutter.  Este eu não li, mas
considerando que ele é uma “continuação” do anterior e que seu autor é uma das
peças chave no desenvolvimento da linguagem (e do compilador de C++ da
Microsoft), estou disposto a arriscar sugeri-lo.

[Modern C++ Design][MCD], de Andrei Alexandrescu.  Este livro é voltado para o
uso de *templates.*  Ainda que você não pretenda usá-los extensivamente,
provavelmente alguma das bibliotecas de seu projeto os usará (muito do que a
Boost faz só é possível devido ao uso e abuso de *templates)*.  Sendo assim,
vale a pena pelo menos dar uma lida.

[EffC]: http://www.aristeia.com/books.html
[MEffC]: http://www.aristeia.com/books.html
[ES]: http://www.aristeia.com/books.html
[ExcptC]: http://www.gotw.ca/publications/xc++.htm
[MExcptC]: http://www.gotw.ca/publications/mxc++.htm
[MCD]: http://www.moderncppdesign.com/book/main.html


Para quem quer entender o porquê
--------------------------------

[The Design and Evolution of C++][TDEC], de Bjarne Stroustrup.  Tecnicamente,
este livro não acrescenta muito aos outros.  Porém, ele conta a história da
linguagem e por que algumas funcionalidades da linguagem são como são e não
diferentes.  Para quem gosta de entender o porquê das coisas, é um livro
interessante.

[TDEC]: http://www.amazon.com/Design-Evolution-C-Bjarne-Stroustrup/dp/0201543303/
