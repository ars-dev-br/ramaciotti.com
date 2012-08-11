---
title: Separando Responsabilidades com Decorators
author: André Ramaciotti
tags: Python, Programação Orientada a Aspectos
---

Todo material sobre organização de código escrito desde a década de 80 bate na
mesma tecla: uma função deve ter um único propósito, e esse propósito deve ser
claro. Os tempos mudaram, uma tal de Programação Orientada a Objetos entrou em
cena também, mas seguiu-se basicamente com o mesmo conselho: cada classe deve
ter uma única responsabilidade. 

Infelizmente, essa ideia é mais facilmente dita que realmente seguida. Para
exemplificar o que geralmente acontece, um exemplo. Assim como no artigo sobre
[Aspect-oriented Programming da Wikipédia][AOP], comecemos com uma função que
faz a transferência de um valor entre duas contas:

[AOP]: https://en.wikipedia.org/wiki/Aspect-oriented_programming

~~~~{.python}
def transfer(from, to, amount):
  if not from.canWithdraw(amount):
    raise Exception("Fundos insuficientes")

  from.withdraw(amount)
  to.deposit(amount)
~~~~

Bastante simples e fácil de ser compreendida. Primeiro se verifica se é
possível retirar tal valor da conta de origem. Se for, retira-se dela e
deposita-se na conta de destino; senão, lança-se uma exceção.

Na prática, porém, dificilmente a função seria realmente assim tão simples.
Para começar, ela envolve dinheiro, e pessoas ficam bastante sensíveis quando
dinheiro está envolvido. Melhor adicionar um log à operação também:

~~~~{.python}
def transfer(from, to, amount):
  logger = logging.getLogger("bank.accounts")
  logger.info("Transferindo %d de %s para %s... ", amount, from, to)

  if not from.canWithdraw(amount):
    logger.info("Quantidade insuficiente na conta %s.", from)
    raise Exception("Fundos insufcientes")

  from.withdraw(amount)
  to.deposit(amount)

  logger.info("Transferência bem sucedida.")
~~~~

Mas isso ainda não seria o suficiente. Não é feita nenhuma verificação de
permissão para fazer essa transferência. Mais uma coisa que nossa tão adorável
função terá de se preocupar também:

~~~~{.python}
def transfer(from, to, amount):
  logger = logging.getLogger("bank.accounts")
  logger.info("Transferindo %d de %s para %s... ", amount, from, to)

  user = sessions.getCurrentSession().user
  if not user.canAccess(from) or not user.canAccess(to):
    logger.info("Usuário não possui permissão")
    raise Exception("Usuário não possui permissão")

  if not from.canWithdraw(amount):
    logger.info("Fundos insuficientes")
    raise Exception("Fundos insufcientes")

  from.withdraw(amount)
  to.deposit(amount)

  logger.info("Transferência bem sucedida.")
~~~~

Provavelmente não terminaria por aí: essa função já passou de ter um único
propósito para três, que mal faria colocar mais um ou outro? Além disso, essa
função revela um problema maior: se ela lida diretamente com código para logs e
permissões, isso significa que boa parte das funções desse sistema também fazem
isso. Qualquer alteração na forma como logs ou permissões virá acompanhada de
uma varredura por todo o código para mudar essas funções.

A linguagem Python fornece uma maneira bastante elegante de se resolver isso:
*decorators*. Eles funcionam de forma parecida ao *pattern Decorator*
apresentado pelo livro Design Patterns, mas é capaz de mais coisas.

Posto de maneira simples, ele é um envólucro sobre uma função ou um método.
Isso significa que um *decorator* pode executar certo código, chamar o método
original e executar mais algum código. Por exemplo, o código abaixo define um
decorator bastante simples, que mostra que função foi chamada, com que
parâmetros e o que ela retornou:

~~~~{.python}
# simpleDecorator.py
from decorator import decorator

@decorator
def simpleLogger(fn, *args, **kw):
  print(fn.__name__, "chamada com ", args, kw)
  ret = fn(*args, **kw)

  print("retornou ", ret)
  return ret
~~~~

Para utilizá-lo, escreva `@simpleLogger` sobre a função que o irá utilizar. Além disso, estou usando o módulo [decorator][DEC]. Ele não é obrigatório, mas facilita bastante. Certifique-se de que ele está instalado antes de continuar.

[DEC]: http://pypi.python.org/pypi/decorator

~~~~{.python}
# main.py
from simpleLogger import simpleLogger

@simpleLogger
def exemplo(a, b, c):
  return a

exemplo(1, 2, 3)
~~~~

Se o arquivo `main.py` acima for executado, ele mostrará algo como:

~~~~
exemplo chamada com (1, 2, 3) {}
retornou  1
~~~~

Agora, é possível separar as três responsabilidades diferentes da função
`transfer`. A função em si volta a possuir a lógica de negócio, como no
princípio, e as outras responsabilidades são adicionadas a ela através de
decoradores específicos:

~~~~{.python}
@log
@permissoes
def transfer(from, to, amount):
  if not from.canWithdraw(amount):
    raise Exception("Fundos insuficientes")

  from.withdraw(amount)
  to.deposit(amount)
~~~~

Esse princípio se chama Programação Orientada a Aspectos e poderia ser feita em
linguagens que apresentam o mesmo nível de introspecção. Se não através de
*decorators*, como em Python, através de metaclasses, como em Common Lisp e
Ruby, ou através de atributos, como em C#.
