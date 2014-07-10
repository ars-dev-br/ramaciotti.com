---
title: Postmortem: Melhor Compra
author: André Ramaciotti da Silva
tags: Java, Postmortem
---
Este foi meu projeto final para a matéria de Desenvolvimento para Web.  O nome
engana um pouco; apesar de se chamar *para Web,* o foco na verdade foi Java EE.
Tivemos uma breve introdução ao que compõe o *frontend* -- HTML, CSS e
JavaScript -- e o resto do semestre foi preenchido por peculiaridades do Java EE
-- Servlets, Beans, JPA, JSF, JAAS, JAquilo e JAquiloOutro. Em geral, foi uma
experiência bastante desagradável.

Em parte, a culpa foi minha.  Como eu não queria montar um servidor SQL, fui com
a opção que melhor conheço: SQLite.  Infelizmente, o suporte a ele nas
bibliotecas que implementam o JPA é bastante fraco.  Primeiro, tentei usar o
EclipseLink -- que já veio com o NetBeans -- com o SQLite, mas não obtive êxito.
Depois, tentei usar o Hibernate, mas sem sorte também.  Aparentemente, existe um
[bug][B] no Netbeans que impede o uso de outras bibliotecas de persistência
através de sua interface.

[B]: https://netbeans.org/bugzilla/show_bug.cgi?id=171973

Sem muito tempo para gastar lutando contra bibliotecas e IDEs, cogitei usar o
[Maven][M] para gerenciar o projeto e editar os arquivos com meu bom e velho
[Emacs][E].  Infelizmente, seus comandos são um pouco desanimadores:

[M]: http://maven.apache.org/
[E]: https://www.gnu.org/software/emacs

~~~~{.sh}
mvn archetype:generate \
  -DarchetypeGroupId=org.apache.maven.archetypes \
  -DgroupId=com.mycompany.app \
  -DartifactId=my-app
~~~~

Além disso, ele baixa diversos arquivos só para criar um projeto vazio.  Entendo
que ele precise obter informações dos pacotes disponíveis, mas o [Gradle][G]
cumpre o mesmo papel e consegue diferir boa parte dessa etapa (além de baixar um
número bem menor de arquivos).  Porém, o Gradle também não é perfeito; ele dá a
sensação de ser bem mais pesado que as alternativas existentes para outras
linguagens.

[G]: http://www.gradle.org/

Ainda assim, nada de persistência.  Por fim, acabei optando pelo HSQLDB e o
Hibernate.  Se eu não tivesse optado pelo SQLite no começo, talvez teria sofrido
menos.

No frontend, tive alguns problemas com o JSF.  De acordo com a especificação do
JSF 2.2, deveria ser possível usar atributos do JSF com elementos HTML normais:

~~~~{.html}
<input jsf:value="#{bean.valor}" />
~~~~

Na prática, isso só funcionou na hora de renderizar a página.  Na hora de enviar
o formulário de volta para o servidor, o *binding* era perdido e o JSF disparava
alguns erros.  Substituí o campo por um `h:inputText` e não tive mais problemas.

Aliás, o *stacktrace* gerado nessas horas me assustou um pouco.  Um projeto
simples como o meu estava gerando *traces* com quase 50 funções na pilha.  Onde
trabalho, já contei *traces* com quase 100 linhas.  Não fiz nenhum *profiling,*
mas acredito que isso não ajude em nada a reduzir a fama de lentidão do Java.
No entanto, isso é mais culpa da mentalidade dos desenvolvedores por trás dessas
bibliotecas que da linguagem;  nem C seria rápido com uma estrutura dessas.

Concluindo, eu acredito que o ambiente [Java][MJ] possa sim ser um bom ambiente
para se trabalhar.  A linguagem é simples (talvez até demais), sem muitas
surpresas, a JVM é um ambiente robusto e relativamente [rápido][BG], e existe
uma disponibilidade gigantesca de bibliotecas de código-livre.  Porém, no
futuro, pretendo manter distância de tudo que for *Enterprise.*

[MJ]: http://blog.paralleluniverse.co/2014/05/01/modern-java/
[BG]: http://benchmarksgame.alioth.debian.org/u64/java.php
