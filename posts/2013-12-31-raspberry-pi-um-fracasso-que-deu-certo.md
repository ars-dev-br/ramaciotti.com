---
title: Raspberry Pi, um fracasso que deu certo
author: André Ramaciotti
tags: Programação
---

Só na última semana, conversei sobre o [Raspberry Pi][RPI] (RPi) umas três
vezes.  Achei que fosse um sinal e resolvi escrever este artigo.  A pergunta que
geralmente me fazem é: "você já pensou no que fazer com um RPi?" e eu respondo
que não.  Não que não existam projetos interessantes feitos com ele, mas quando
ele foi anunciado, eu esperava outra coisa.

Se você procurar listas como "os 10 projetos para RPi mais impressionantes," "os
20 projetos mais incríveis usando o RPi" etc. vai ver que os projetos têm algo
em comum: todos parecem ter saído do [hackaday][HD].

Não há nada de errado nisso.  Acho fantástico que exista um computador pequeno,
barato e que consiga interagir com hardware externo facilmente, mas a maioria
dos projetos que vejo não precisam de toda sua capacidade.  Aliás, boa parte dos
projetos sequer usa a saída de vídeo.  Provavelmente um Arduino, um PIC ou um
AVR dariam conta do recado e seriam mais baratos[^n1].

[^n1]: Um RPi sai em torno de 40 dólares, mas um starter kit completo é mais
caro.  Já um Arduino, dependendo do modelo, pode custar entre 11 e 30 dólares,
sendo que alguns starter kits estão nessa mesma faixa de preço.  Além disso, os
starter kits do Arduino são mais voltados à Eletrônica e já vêm com resistores,
jumpers etc. -- coisas baratas, mas que em quantidade podem dar um valor
considerável.

Porém, independente dessa minha preferência por microcontroladores para esse
tipo de projeto, o RPi está aí e é um sucesso.  Por isso, digo que ele deu
certo, mas não acho que era esse o objetivo que seus criadores tinham em mente
quando o projetaram.  Na [página sobre o projeto][ABT], escreveram:

> The idea behind a tiny and cheap computer for kids came in 2006, when Eben
> Upton, Rob Mullins, Jack Lang and Alan Mycroft, based at the University of
> Cambridge’s Computer Laboratory, became concerned about the year-on-year
> decline in the numbers and skills levels of the A Level students applying to
> read Computer Science. From a situation in the 1990s where most of the kids
> applying were coming to interview as experienced hobbyist programmers, the
> landscape in the 2000s was very different; a typical applicant might only have
> done a little web design.

> Something had changed the way kids were interacting with computers. A number
> of problems were identified: the colonisation of the ICT curriculum with
> lessons on using Word and Excel, or writing webpages; the end of the dot-com
> boom; and the rise of the home PC and games console to replace the Amigas, BBC
> Micros, Spectrum ZX and Commodore 64 machines that people of an earlier
> generation learned to program on.

Ou seja, a intenção era criar um computador barato e que motivasse crianças e
adolescentes a aprenderem a programar.  Nisso eu acho que o RPi falhou.  Eu
realmente duvido que, daqui vários anos, ouvirei muitas pessoas falando que
resolveram aprender a programar porque tinham um RPi em casa.

Existe certo saudosismo com relação a esses computadores que citaram -- e mesmo
com os primeiros PC -- e posso estar sendo vítima dele (apesar de nunca os ter
usado), mas acho que o RPi falhou nesse aspecto justamente porque ele **não** é
esses computadores; seu software é diferente.

Muita coisa mudou de lá para cá.  Num geral, programar ficou muito mais fácil.
Esqueçam gerenciamento manual de memória, nós agora temos garbage collection.
Gravar estruturas binárias em disco?  Toma aqui esse banco de dados.  Melhor
ainda, use este ORM aqui.  Mas essas facilidades todas vieram com um custo: com
tanta abstração sobre abstração, às vezes é difícil interagir diretamente com a
camada de baixo.  E, para quem está aprendendo, às vezes as camadas inferiores
são mais simples, mais fáceis de começar.

Quando se está começando a estudar um assunto, espera-se que o foco seja naquele
assunto.  Se você se lembra das suas aulas sobre números racionais, quando a
"tia" mostrou sua primeira multiplicação entre frações, ela provavelmente
escolheu um exemplo simples, como 2/3 * 4/5.  Ela não escolheu 354816/61257 *
998571/47832 porque isso acrescenta uma complexidade aritmética sem trazer
benefício ao exemplo.  Ela também não definiu o que é um anel e simplesmente
disse "Q forma um anel relativamente à adição e à multiplicação," porque isso
seria abstrato demais.

Considero esse ponto bastante importante.  Na minha experiência como instrutor
de C++, uma das maiores dificuldades no começo é não saber no que se focar.
Nunca estudei Pedagogia ou Andragogia e posso estar falando besteira, mas eu
percebia isso também nas minhas aulas de Álgebra Linear.  O professor não era
muito bom em Aritmética[^n2] e, às vezes, quando ia mostrar um novo conceito
para a turma, fazia o equivalente a 2/3 * 4/5 = 2 * 4/ 3 * 5 = 10/15.  A
Aritmética ali não era o ponto principal, era apenas um exemplo, mas boa parte
da turma não conseguia entender o conceito geral e se perdia por estar prestando
atenção nos detalhes errados.

[^n2]: Coisa que eu também não sou.  Acho que ele me entendia e considerava
minhas questões como corretas mesmo quando eu cometia erros feios no cálculo de
determinantes.

Assim, na hora de introduzir alguém a programação, quanto menos detalhes que não
importam naquele momento houver, melhor.  Como um exemplo, compare estas duas
versões do bom e velho `hello world`.

Em C++:

~~~~{.cpp}
#include <iostream>
int main() {
    std::cout << "hello world" << std::endl;
}
~~~~

E em Python:

~~~~{.py}
print "hello world"
~~~~

O que é `include`?  Por que aquele `#` aparece na frente dessa linha, mas não
nas outras?  O que é `int`?  O que é `main`?  O que são aqueles parênteses?
Para que servem as chaves?  Compare com a simplicidade de Python.  O mais
estranho ali é que `print` escreve na tela em vez de imprimir em papel, mas isso
é fácil de justificar historicamente.  Neste contexto, essa simplicidade é uma
grande vantagem.

Isso é particularmente importante neste caso porque a pessoa já está tendo de se
preocupar com outras coisas, como a IDE e o resto do ambiente de
desenvolvimento.  Fazer ela, além de tudo, ter de se preocupar com detalhes da
linguagem que não importam agora é sadismo.

Com isso, vemos como uma linguagem mais simples e que abstrai melhor alguns
conceitos que C++ traz vantagens na hora de introduzir alguém à programação.
Porém, essa relação entre abstração e facilidade de ensinar não é sempre
positiva.  Às vezes, abstrações demais podem tornar a tarefa mais difícil.

Por exemplo, considere o seguinte exemplo: a Microsoft resolveu que, no Windows
9, o sistema de arquivos não será mais acessível pelo usuário[^n3].  Não se
preocupe, para programas antigos foi disponibilizada uma camada de
compatibilidade, mas todo programa para Windows, a partir de agora, terá de
armazenar seus dados usando o Microsoft SQL Server 2015.

[^n3]: Quando digo usuário aqui, refiro-me aos programas do user space, e não só
ao usuário acessando seus arquivos através do Explorer.

Agora, imagine que você quer ensinar um iniciante em C a gravar uma
estrutura num arquivo.  Neste novo modelo imaginário, haveria várias coisas
novas a serem introduzidas: o que é um banco de dados, o que significa ele ser
relacional, como criar uma conexão, como criar uma tabela e, finalmente, como
inserir dados nessa tabela.

Por outro lado, no modelo atual, supondo que ele já tenha trabalhado com
estruturas e funções, é relativamente simples.  Caso o material sendo seguindo
ou o instrutor tenha tido o cuidado de eninar ponteiros antes também, fica ainda
mais fácil, basta introduzir o tipo `FILE*` e as funções `fopen`, `fwrite` e
`fclose`.

~~~~{.c}
#include <stdlib.h>
#include <stdio.h>

struct dados_t {
    int i;
    float f;
};

int main() {
    struct dados_t dados = { 5, 4.0f };
    FILE* file = fopen("arquivo.dat", "wb");
    fwrite(file, &dados, sizeof dados);
    fclose(file);

    return 0;
}
~~~~

O oposto desse exemplo seria uma situação em que se está trabalhando num sistema
operacional extremamente simplista e que não implementa um sistema de arquivos.
Para ler e gravar arquivos, seu programa que é responsável por controlar
cilindros, setores, blocos etc.

Qual das três opções é a melhor para um principante?  É a intermediária, um
sistema de arquivos como existe atualmente.  Obrigar o uso de um banco de dados
relacional é prejudicial, fazendo com que se tenha que aprender sobre tabelas,
relações, SQL, `select` e `insert`.  Não fornecer uma forma mais abstrata de
interagir com o disco também o é, fazendo com que o iniciante tenha que se
preocupar com como o hardware de um disco funciona.

Resumindo, abstração de menos é ruim, porque obriga quem está aprendendo a se
preocupar com detalhes de baixo nível que não são relevantes agora.  Por outro
lado, abstração demais também pode ser ruim, porque obriga quem está aprendendo
a conhecer novos conceitos antes do tempo,
[além de geralmente não conseguirem abstrair completamente a camada de baixo][LA].
Ou seja, para este fim, existe um nível ótimo de abstração.

Minha impressão é que esses computadores lendários atingiram esse nível, pelo
menos em alguns aspectos.  Instalar as primeiras placas de som num PC DOS era
horrível, e eu provavelmente não iria querer colocar um C64 numa rede TCP/IP,
mas essas coisas eram raras na época, não importavam tanto.  Por outro lado,
desenhar alguma coisa na tela com QBasic era questão de escolher uma cor e rodar
`LOCATE x, y: PRINT CHR$(219)`.  Hoje em dia, temos computadores capazes de
gráficos muito melhores, mas precisamos aprender GDI+ ou GDK ou OpenGL ou Direct
X, *shaders,* texturas...

De forma similar, além de permitirem a criação de gráficos simples facilmente,
computadores Amiga ou Commodore também permitiam a sintetização de som com
alguma facilidade.  Ou seja, com algum pouco tempo de prática, já era possível
se atrever a escrever programas mais interativos, com animações e sons -- coisas
que hoje em dia não são tão simples assim.

Não quero dizer que antigamente era melhor (não era), mas nós perdemos algumas
capacidades nessa evolução.  Geralmente, essa perda não fez falta; substituímos
sistemas antigos por sistemas melhores, mas isso não quer dizer que esses
sistemas melhores sejam mais fáceis de serem aprendidos.

Se realmente quisermos promover a programação entre os mais jovens, precisamos
de uma plataforma em que seja fácil criar seu primeiro `hello world`, e que
permita criar programas que possam ser facilmente sentidos (visto, ouvidos).  E
isso é um problema de software, não de hardware.

Para algumas ideias de como isso pode ser feito, dê uma olhada em
[Learnable Programming][LP].

[ABT]: http://www.raspberrypi.org/about
[HD]: http://hackaday.com/
[LA]: http://www.joelonsoftware.com/articles/LeakyAbstractions.html
[LP]: http://worrydream.com/#!/LearnableProgramming
[RPI]: http://www.raspberrypi.org/
