---
title: Premature “premature optimization is the root of all evil” is the root of all evil
author: André Ramaciotti
tags: Programação, Otimização
---

Em seu artigo “Structured Programming with Goto Statements,” Donald Knuth
escreveu:

> Programmers waste enormous amounts of time thinking about, or worrying about,
> the speed of noncritical parts of their programs, and these attempts at
> efficiency actually have a strong negative impact when debugging and
> maintenance are considered. We should forget about small efficiencies, say
> about 97% of the time: **premature optimization is the root of all evil**. Yet
> we should not pass up our opportunities in that critical 3%.

Essa citação ganhou fama, começou a circular por aí, foi truncada e perdeu seu
contexto.  Hoje em dia, é raro encontrar um programador que nunca tenha escutado
“otimização prematura é a raiz de todo mal,” mas poucos conhecem a frase inteira
e seu contexto.  Antes mesmo de começar a escrever este texto, eu também os não
conhecia, mas acho importante rever e refletir sobre o senso comum de vez em
quando.

Infelizmente, essa frase se tornou uma espécie de mantra e virou uma desculpa
para programadores não se preocuparem com a performance do sistema que estão
projetando ou desenvolvendo.  Porém, em momento algum Knuth diz que nunca se
deve otimizar um programa.  Em vez disso, ele diz que otimizações *prematuras*
são o problema.

Talvez, uma frase que serviria melhor de mantra seria: *Never give up your
performance accidentally*, de Rico Mariani.  Para que isso seja possível, é
necessário reconhecer que diferentes operações possuem custos diferentes, e que
as operações utilizadas dependerão da arquitetura do projeto e da plataforma na
qual o sistema executará.

Por exemplo, suponha que estamos escrevendo algum tipo de simulador que irá
executar em um PC comum (um x86 de 64 bits), e que, de acordo com o projeto
inicial, o núcleo do simulador será algo como escrito abaixo.  Note que, quando
falo "projeto inicial," refiro-me a algo como um diagrama de classes; não é
necessário desenvolver o sistema para saber que certas arquiteturas darão origem
a código parecido com este.

~~~~{.Cpp}
void funcaoPrincipal(vector<IAtor*>& atores) {
    for_each(begin(atores), end(atores), [](IAtor* ator) {
        ator->agir();
    });
}
~~~~

Neste caso, cada passo da simulação envolverá chamar a função acima e,
eventualmente, chamar algum outro código de book-keeping.  O problema é que,
apenas por `agir` ser um método virtual, o tempo para executar esse loop pode
ser até sete vezes maior do que se tratasse de um método conhecido em tempo de
compilação[^n1].  Além disso, dependendo da quantidade de atores e de seu
tamanho na memória, esse código pode causar um grande número de *cache misses* e
*branch mispredictions,* reduzindo ainda mais a performance desse loop[^n2].

Ou seja -- apesar de eu ter escrito o código para fins ilustrativos --, muitas
vezes é possível determinar como o código será escrito a partir do projeto, e
daí estimar seu custo de execução.  Sendo assim, se estamos desenvolvendo um
sistema que exige grande velocidade, detectamos uma situação como essa e não
fazemos nada, estamos sendo negligentes com a performance do sistema, estamos
dando performance acidentalmente.  Evitar essa arquitetura não seria uma
otimização prematura, seria uma otimização na hora certa -- ainda que sequer se
tenha criado o primeiro arquivo de código do projeto.

Por isso, antes de simplesmente descartar uma otimização e citar essa frase de
Knuth, analise se este não é o melhor momento de aplicá-la.  Uma otimização
prematura traz problemas de manutenibilidade do código, é verdade, mas uma
otimização tardia pode ser difícil demais de ser implementada e afastar clientes
se a performance for crítica.

PS: para quem se interessar, um [artigo][ART] um tanto mais extenso sobre o
 assunto.  (Existe certa dúvida sobre o verdadeiro autor da frase *“premature
 optimization is the root of all evil,”* mas [parece][QUO] que ela é invenção de
 Knuth mesmo).

[^n1]: Conforme pode ser visto [aqui][BEN] mas lembre-se de tomar cuidado com
*benchmarks.*

[^n2]: [Estes slides (PDF)][SLI] são sobre o PS3 e não sobre PCs, mas boa parte
do que está escrito ali se aplica a qualquer arquitetura moderna.

[ART]: http://ubiquity.acm.org/article.cfm?id=1513451
[BEN]: http://eli.thegreenplace.net/2013/12/05/the-cost-of-dynamic-virtual-calls-vs-static-crtp-dispatch-in-c/
[QUO]: http://shreevatsa.wordpress.com/2008/05/16/premature-optimization-is-the-root-of-all-evil/
[SLI]: http://harmful.cat-v.org/software/OO_programming/_pdf/Pitfalls_of_Object_Oriented_Programming_GCAP_09.pdf
