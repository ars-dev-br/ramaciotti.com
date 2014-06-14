---
title: Postmortem: reviewr
author: André Ramaciotti
tags: Postmortem, Python
---

Um costume da indústria de jogos que gosto muito é o postmortem.  Ao finalizar
um título, os desenvolvedores fazem uma retrospectiva do que fizeram, o que
funcionou, o que não.  Com isso, experiência é trocada entre diferentes equipes,
até de diferentes empresas, e a indústria como um todo ganha.

Algumas empresas de desenvolvimento fora desse mercado também fazem isso, mas me
parece ser mais raro.  Este vídeo da
[ThoughtWorks sobre o uso de Continuous Delivery][TWCD] é um ótimo exemplo.
Este artigo sobre [como uma cultura de testes foi implantada na Google][MFTC],
também.

[TWCD]: http://vimeo.com/44665427
[MFTC]: http://martinfowler.com/articles/testing-culture.html

O que pretendo fazer neste artigo é algo parecido.  Vou falar um pouco sobre um
trabalho da faculdade e fazer uma retrospectiva técnica.  Já existe outro na
fila e pretendo fazer mais destes artigos conforme a oportunidade aparecer.
Inicialmente, eu pensei em apenas colocar o código no Github, mas desta forma eu
consigo comentar melhor o que gostei, o que não, e o que teria feito diferente.
Assim, também, consigo chamar a atenção aos pontos que acho mais relevantes e
explicar por que.  É mais difícil fazer isso simplesmente largando o código num
repositório.

O projeto em questão, reviewr, era relativamente simples: um Stack Overflow
orientado a revisão de código.  Em vez de se perguntar "como posso fazer isso?"
a ideia era que perguntassem "esta é a melhor forma de se fazer isso?"  No fim,
o projeto ficou bastante parecido com o [Code Review Stack Exchange][CRSE], que
eu não conhecia até o projeto estar iniciado, e a ideia aprovada pelo professor.

[CRSE]: http://codereview.stackexchange.com/

## Docker

Como eu sabia que teria que instalar banco de dados e várias dependências do
python, pensei em usar o [docker][D] para isolar isso do meu sistema principal.
No fim, tive algumas dificuldades em fazer o systemd rodar dentro do container e
gerenciar o Postgres através dele.

[D]: http://www.docker.com/

Como não estava disposto a gastar muito tempo com esse projeto, desisti de
containers e fui com uma tecnologia que já conheço melhor, máquinas virtuais.
Ainda preciso estudar melhor a diferença entre containers e VMs, e como usar o
docker eficientemente.

## Vagrant

Para facilitar meu trabalho com máquinas virtuais, usei o [vagrant][V].  Achei
uma box com uma imagem do Arch Linux e a configurei para o projeto.  Pensei que
isso me pouparia tempo, mas em retrospecto, não foi uma boa escolha.

[V]: http://www.vagrantup.com/

O vagrant foi ótimo e fez tudo que eu esperava, mas a imagem era grande, o que
aumentou o tempo de download.  Depois, precisei atualizar a máquina e instalar
alguns pacotes -- mais algum tempo esperando.  Mais tarde, no meio do projeto,
perdi algum tempo até descobrir que os erros crípticos que estavam acontecendo
eram por causa de uma partição lotada.  A box veio com um disco virtual de 2GB,
e vários pacotes desnecessários -- como llvm e clang -- pré-instalados.  No fim,
imagino que se eu tivesse montado minha própria imagem teria gasto menos tempo.

## Arch Linux

Escolhi o [Arch Linux][AL] por ser a distro que mais estou habituado, mas a
experiência me fez pensar duas vezes se vale a pena colocá-lo em servidores.
Uma atualização do python e foi necessário regerar o virtualenv.  Foi o único
problema que tive, e foi rápido resolvê-lo, mas para não perder mais tempo com
isso, não atualizei mais a máquina virtual depois da primeira vez.

[AL]: http://archlinux.org/

## PostgreSQL

Sobre o [Postgres][P], não tenho muito o que falar.  Ele se comportou bem, até
mesmo na situação de pouco espaço em disco que relatei.  Uma dica apenas que
posso dar é: [mantenha o schema do banco de dados sob versionamento][SUV].
Assim, é possível saber como o banco estava a cada commit do código.

[P]: http://www.postgresql.org/
[SUV]: http://blog.codinghorror.com/get-your-database-under-version-control/

Eu não cheguei a automatizar o processo de atualização do banco, mas creio que
teria sido simples.

## Python

Eu já conhecia [python][PY], mas nunca havia trabalhado num projeto
relativamente grande.  Esta parte é a mais subjetiva do texto, mas minha
sensação é que python é uma linguagem "mole" demais, sem muita estrutura.
Apesar do scaffolding do pyramid, fiquei com a impressão de que não existe um
jeito "certo" de organizar as classes e os arquivos.  Isso é, em parte, culpa de
a línguagem ser dinâmica, mas não senti isso mesmo quando trabalhei com PHP e
composer[^fn1].

[PY]: https://www.python.org/
[PHP]: http://php.net/
[C]: https://getcomposer.org/

[^fn1]: Essa minha sensação é meio curiosa e irônica.  Eu não gosto, por exemplo, do framework de desenvolvimento do Android ou de usar WebForms, justamente porque os acho muito engessados.  Por outro lado, python com pyramid me pareceu muito flexível e é difícil saber se as coisas estão sendo feitas da melhor forma possível.

O REPL talvez seja a melhor parte da linguagem, mas minha impressão é que eu
mais o utilizava para testar problemas que uma linguagem estática pegaria
durante a compilação.  Eu provavelmente deveria ter utilizado um lint ou outro
tipo de verificador estático.

## Pyramid

O [pyramid][PYP] é um meio termo entre um microframework, como o [flask][PYF], e
um framework mais pesado, como o [django][PYD].  Uma coisa que gostei bastante
nele é como a separação entre lógica e apresentação é feita.  As funções
utilizadas para fazer o processamento por trás das views podem ser chamadas como
funções normais e executarão sem problemas.  Isso facilita bastante a
implementação de testes se comparado ao django.

[PYP]: http://docs.pylonsproject.org/en/latest/docs/pyramid.html
[PYF]: http://flask.pocoo.org/
[PYD]: https://www.djangoproject.com/

Por outro lado, como comentei no tópico anterior, fiquei com a sensação de que o
framework é muito aberto a escolhas pelo desenvolvedor sem indicar qual a forma
padrão ou qual a melhor forma de fazer o que se planeja.  A possibilidade de
escolha é ótima, mas sem ter onde me fundamentar, fiquei preocupado se estava
fazendo as coisas do melhor jeito.

## SQLAlchemy

Dentro do domínio do Python, esta foi a parte que mais me impressionou.
Representar as tabelas do banco de dados como modelos do python foi bastante
simples, e o mapeamento do [SQLAlchemy][SA] é capaz de algumas coisas que eu não
considerava possíveis num ORM.  Por exemplo, eu tinha três tabelas:

[SA]: http://www.sqlalchemy.org/

~~~~{.sql}
create table reviewer (
  id serial primary key,
  username varchar(30) not null unique,
  email text not null unique,
  password varchar(80) not null,
  created_on timestamp not null,
  fullname text
);

create table code (
  id bigserial primary key,
  title text not null,
  reviewer integer not null references reviewer(id),
  comment text,
  code text not null,
  created_on timestamp not null
);

create table code_vote (
    id bigserial primary key,
    reviewer integer not null references reviewer(id),
    code bigint not null references code(id),
    karma integer not null check (karma = 1 or karma = -1),
    created_on timestamp not null
);

~~~~

Usando column_properties, é possível criar uma propriedade no modelo do Reviewer
com a pontuação total do usuário.  O melhor de tudo é que isso gera uma query
que calcula o valor direto no banco, reduzindo a quantidade de dados que o banco
de dados precisa enviar para a aplicação.

~~~~{.python}
class Reviewer(ReviewrBase):
    __tablename__ = 'reviewer'

    id = Column(Integer, primary_key=True)
    username = Column(String)
    email = Column(String)
    password = Column(String)
    created_on = Column(DateTime)
    fullname = Column(String)


class Code(ReviewrBase):
    __tablename__ = 'code'

    id = Column(BigInteger, primary_key=True)
    title = Column(String)
    comment = Column(String)
    code = Column(String)
    created_on = Column(DateTime)
    edited_on = Column(DateTime)


class CodeVote(ReviewrBase):
    __tablename__ = 'code_vote'

    id = Column(BigInteger, primary_key=True)
    karma = Column(Integer)
    created_on = Column(DateTime)

    reviewer_id = Column('reviewer', Integer, ForeignKey('reviewer.id'))
    reviewer = relationship('Reviewer',
                            backref=backref('code_votes',
                                            order_by=id.desc()))

    code_id = Column('code', BigInteger, ForeignKey('code.id'))
    code = relationship('Code', backref=backref('votes',
                                                order_by=id.desc()))


Code.karma = column_property(
    select([case([(func.sum(CodeVote.karma) != None,
                   func.sum(CodeVote.karma))],
                 else_ = 0)]).\
    where(CodeVote.code_id == Code.id), deferred=True)


Reviewer.karma = column_property(
    select([case([(func.sum(Code.karma) != None,
                   func.sum(Code.karma))],
                 else_ = 0)]).\
    where(Code.reviewer_id == Reviewer.id), deferred=True)

~~~~

A sintaxe fica um pouco feia por causa do `case`.  Eu queria que um usuário sem
códigos enviados ainda tivesse karma `0`, e não `NULL`.  Tirando esse defeito, o
poder das column properties fica aparente quando executo algo como o código
abaixo.  Apesar de, no banco, não haver relação direta entre o karma de um
reviewer e a tabela code_vote, o SQLAlchemy permite acessar esse valor como se
fosse uma propriedade da classe Reviewer.

~~~~{.python}
session = Session()
reviewer = session.query(Reviewer).first()
print(reviewer.karma)
~~~~

## Concluindo

Apesar dos problemas que tive com a imagem que baixei para o vagrant, não
consigo mais cogitar fazer um trabalho sem uma máquina virtual.  O isolamento
entre minha máquina principal e o ambiente de desenvolvimento me permite uma
maior tranquilidade sabendo que não terei pacotes e serviços desnecessários
rodando no meu computador principal.

Duas coisas que talvez valham a pena melhorar nesse ponto é estudar mais a fundo
o docker, e verificar se containers não seriam uma alternativa mais leve para
esse ambiente de desenvolvimento; e estudar provisionadores, como o
[puppet][PUP], para agilizar o processo de criação desses ambientes.

[PUP]: http://puppetlabs.com/

Com relação a python e seu ecossistema, não senti tanta certeza.  A experiência
com o SQLAlchemy foi boa o suficiente para melhorar minha impressão de ORM em
geral, mas não me senti muito confortável com a linguagem e com o pyramid.
Tenham em mente, porém, que essa é a opinião de alguém cada vez mais apaixonado
por checagem estática com inferência de tipos.
