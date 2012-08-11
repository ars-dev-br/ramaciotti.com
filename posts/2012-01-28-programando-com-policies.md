---
title: Programando com Policies
author: André Ramaciotti
tags: C++, Design Patterns
---

Por algumas razões históricas[^f1] e por serem um conceito completamente novo no
meio em que surgiram[^f2], *templates* inicialmente eram usados para tarefas
simples, geralmente se limitando apenas à criação de classes *containers.*

[^f1]: *Templates* nem sempre fizeram parte do C++, e, mesmo após sua adição ao
padrão da linguagem, passou-se certo tempo até que os principais compiladores
apresentassem implementações robustas, estáveis e com mensagens de erro
compreensíveis.

[^f2]: Diferentemente de programadores de linguagens dinâmicas (em particular
Lisp), programadores de C e C++ não estavam (e eu diria que ainda não estão)
acostumados a programas que escrevem programas, justamente o papel de
*templates.* Evidência de que este conceito ainda é estranho nesse meio é a
simplificação que *templates* sofreram ao serem incorporados nas linguagens Java
e C# como *generics,* que não são tão capazes.

Andrei Alexandrescu foi um dos primeiros a mostrar que *templates* eram capazes
de muito mais que isso em seu livro [Modern C++ Design][MCD], em que apresenta
um *design pattern* conhecido por *policy.* *Policies* são bastante similares ao
*pattern* chamado de *strategy,* mas acontecem durante a compilação, e não
durante a execução do programa.

[MCD]: https://en.wikipedia.org/wiki/Modern_C%2B%2B_Design

Sua utilidade fica evidente quando o comportamento de uma classe pode ser divido
em pequenas partes ortogonais. Isso é, partes que não interagem diretamente
entre si, como no exemplo abaixo – uma versão modificada do exemplo usado por
Stefan Reinalter no seu artigo em [#AltDevBlogADay][ADBD]:

[ADBD]: http://altdevblogaday.com/2011/11/28/policy-based-design-in-c/

~~~~{.Cpp}
class Log {
public:
    virtual ~Log(void) { }

    virtual Escreve(Origem, Verbosidade, const InfoCodigo&,
              const std::string& mensagem) {
        if(/* 1. Critério de filtro */) {
            // 2. Formatação da mensagem de acordo com certos critérios
            // 3. Escrita do log
        }
    }
};
~~~~

Esta é uma implementação bastante simples, incompleta e provavelmente incorreta
de uma classe responsável por escrever *logs.* Ela se resume a um único método,
`Escreve`, que aceita quatro parâmetros: um `enum` representando de onde surgiu
aquela entrada no *log* (por exemplo, se foi na camada que lida com o banco de
dados, se foi um problema de rede, etc); outro `enum` com o tipo de verbosidade
daquela entrada (se é apenas informativa, um aviso ou um erro); uma estrutura
chamada de `InfoCodigo` que contém informações que permitam localizar que parte
do programa gerou aquela entrada (nome do arquivo, número da linha, nome da
função etc); e a mensagem que deverá ser gravada.

Através dos comentários, percebe-se que o método `Escreve` exerce três ações
independentes entre si: o filtro, a formatação e a escrita. O papel do filtro é
impedir que informações indesejadas sejam gravadas no *log,* acumulando-o com
informações inúteis para certo propósito. Já a formatação serve para que o *log*
possa seguir diferentes formatos: texto puro, JSON, XML… Por último, a escrita
do *log* permite que diferente ações sejam tomadas com a mensagem já formatada:
ela pode ser escrita no console, em um arquivo, pode ser enviada por email ou
qualquer outra coisa do gênero.

Inicialmente, pode-se tentar implementar este método separando-se as três ações
em três métodos virtuais. Assim, para implementar um *log* que grave todas as
mensagens em texto puro em um arquivo no disco rígido, bastaria implementar uma
classe similar a esta:

~~~~{.Cpp}
class LogTudoTextoArquivo : public Log {
public:
    virtual Escreve(Origem origem, Verbosidade verb, const InfoCodigo& info,
              const std::string& mensagem) {
        if(Filtra(origem, verb)) {
            std::string mensagemFormatada = Formata(origem, verb, info, mensagem);
            Grava(mensagemFormatada);
        }
    }

private:
    bool Filtra(Origem, Verbosidade);
    std::stringFormata(Origem, Verbosidade, const InfoCodigo&,
        const std::string&);
    void Grava(const std::string&);
};
~~~~

No entanto, considere o trabalho que se teria para criar todas as combinações
possíveis. Se houver três opções de filtro (tudo, apenas avisos e erros, apenas
erros), três de formatação (texto puro, JSON e XML) e três de escrita (console,
arquivo e email), existirão 27 combinações possíveis de *logs* para serem
implementadas. Assim, fica evidente que a utilização de métodos virtuais não
serve, já que não preserva a ortogonalidade entre as três tarefas e torna-se
necessário implementar todas as combinações possíveis.

### Policies

Uma maneira de se resolver este problema é com o uso de *policies.* Com elas,
implementam-se classes menores, responsáveis por apenas uma dessas ações
ortogonais. A classe `Log`, por sua vez, acessa essas classes/*policies* através
da herança e do uso de *templates.*

~~~~{.Cpp}
template <class PolicyFiltro, class PolicyFormatacao, class PolicyGravacao>
class LogImpl : public Log,
    public PolicyFiltro,
    public PolicyFormatacao,
    public PolicyGravacao {
public:
    virtual Escreve(Origem origem, Verbosidade verb, const InfoCodigo& info,
              const std::string& mensagem) {
        if(Filtra(origem, verb)) {
            std::string msgFormatada = Formata(origem, verb, info, mensagem);
            Grava(msgFormatada);
        }
    }
};
~~~~

Essas *policies* seguem um contrato informal: uma *policy* de filtro deve
implementar um método `Filtra` e assim por diante. Esse contrato informal exerce
basicamente o mesmo papel que uma interface ou uma classe abstrata, mas
infelizmente ele não é explícito.

~~~~{.Cpp}
class SemFiltro {
public
    bool Filtra(Origem, Verbosidade) {
        return true;
    }
};

class FormatacaoSimples {
public:
    std::string Formata(Origem, Verbosidade, const InfoCodigo&,
                            const std::string& mensagem) {
        return mensagem;
    }
};

class GravacaoConsole {
public:
    void Grava(const std::string& mensagem) {
        std::cerr << mensagem;
    }
};
~~~~

Implementadas as *policies* necessárias, pode-se agora começar a misturá-las,
dando origem a um grande número de combinações. Com a utilização de `typedefs`,
pode-se inclusive determinar qual o tipo de *log* padrão por toda uma
aplicação. Se por algumo motivo for necessário mudar o *log* usado pela maior
parte da aplicação, basta trocar um `typedef`.

~~~~{.Cpp}
typedef LogImpl<SemFiltro, FormatacaoSimples, GravacaoConsole> LogTudoTextoConsole;
typedef LogImpl<SemFiltro, FormatacaoJson, GravacaoArquivo> LogTudoJsonArquivo;
// ...
typedef LogImpl<FiltroApenasErros, FormatacaoXml, GravacaoArquivo> LogPadrao;
~~~~

### Policies com Atributos

Algumas *policies* dependem de atributos. Por exemplo, a *policy*
`GravacaoArquivo` precisa do nome do arquivo onde o *log* deverá ser escrito. Já
a *policy* `GravacaoEmail` é ainda mais complexa e precisa de informações como o
servidor SMTP, o remetente, o destinatário etc.

Num primeiro impulso, pode-se tentar resolver esse problema mantendo o nome do
arquivo ou as informações do email diretamente no código da *policy* em
questão. No entanto, o que fazer quando as informações mudarem? Na melhor das
hipóteses, a *policy* já existente terá de ser modificada, senão uma nova terá
de ser criada. Outro problema é que nem sempre essas informações serão
conhecidas na hora da compilação; é bem provável que cada cliente possua seu
servidor SMTP com seu usuário e com sua senha específicos. Essas informações
devem ser mantidas em um arquivo de configuração e lidas durante a *execução* do
programa, e não durante sua compilação.

Felizmente, resolver esse problema é relativamente simples, dada a forma como
`LogImpl` foi implementada. Ela acessa suas *policies* através do uso de herança
múltipla. Assim, já se tem acesso direto às propriedades das *policies*
empregadas, basta que sua visibilidade esteja correta. Como exemplo, veja a
implementação da *policy* `GravacaoArquivo` e a utilização prática do
`LogTudoTextoArquivo`.

~~~~{.Cpp}
class GravacaoArquivo {
public:
    void Grava(const std::string& mensagem) {
        std::ofstream ofs(nomeArquivo);
        ofs << mensagem;
    }

    std::string nomeArquivo;
}
~~~~

~~~~{.Cpp}
void fn(void) {
    LogTudoTextoArquivo log;
    log.nomeArquivo = "/tmp/log.txt";

    log.Escreve(TESTE, INFO, InfoCodigo(__FILE__, __LINE__), "Teste");
}
~~~~
