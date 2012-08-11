---
title: Tipos Fantasmas
author: André Ramaciotti
tags: C++
---

A linguagem C++ permite que sejam criadas classes ou estruturas vazias. Em um primeiro momento, isso pode parecer mais uma daquelas curiosidades inúteis, mas pergunte a um programador que usa linguagens funcionais e ele te mostrará que tipos fantasmas são muito mais que isso.

~~~~{.Cpp}
struct Fantasma_t {};
const Fantasma_t Fantasma = {};
~~~~

O uso mais simples para esses tipos é a criação de novas palavras-chaves. Por exemplo, considere o código abaixo. Ele usa uma classe chamada de `Nullable<T>`, análoga à classe de mesmo nome em C# e similar à mônade `Maybe a` do Haskell.

~~~~{.Cpp}
Nullable<int> BuscaIdUsuario(const std::string& usuario) {
    Nullable<int> id = Nothing;

    // código que efetivamente busca a ID do usuário

    return id;
}
~~~~

A função `buscaIdUsuario` pertence a um grupo de funções que podem falhar. O usuário buscado pode não existir no sistema, e o tipo `Nullable<T>` permite representar essa falha com a palavra-chave `Nothing`.

No entanto, a palavra-chave `Nothing` não faz parte da linguagem. Como se pode escrever a classe `Nullable` de maneira que o código a cima funcione? A resposta está no título deste artigo: com um tipo fantasma.

~~~~{.Cpp}
struct Nothing_t {};
const Nothing_t Nothing = {};
~~~~

Isso fará com que o compilador reconheça a pseudo-palavra-chave `Nothing`, mas ainda existe um problema: os tipos `Nothing_t` e `Nullable<T>` são incompatíveis entre si. Esse problema também é simples de se resolver: basta escrever um novo construtor para a classe `Nullable<T>`:

~~~~{.Cpp}
template<typename T>
class Nullable {
    T valor_;
    bool temValor_;

public:
    Nullable(Nothing_t) {
        temValor_ = false;
    }

    // ...
};
~~~~

Outra utilidade é a possibilidade de se atribuirem *tags* que promovam a verificação do código pelo próprio compilador. Ao se escrever bibliotecas ou ao se trabalhar em grandes projetos, é difícil garantir que todos os métodos necessários estejam sendo chamados e na ordem correta.

Por exemplo, considere o cadastro de um cliente. Pode-se dividir o processo em três partes: pegar os dados da tela e agrupá-los em uma estrutura, validar e gravá-los. Para evitar que os dados sejam gravados antes de serem validados, é possível acrescentar uma *tag* ao tipo `DadosCliente`, indicando se aqueles dados já foram verificados ou não.

~~~~{.Cpp}
struct Validados {};
struct NaoValidados {};

template<typename Estado>
struct DadosCliente {
    std::string nome;
    // ...
};

DadosCliente<NaoValidados> DadosTela(void);
DadosCliente<Validados> Valida(const DadosCliente<NaoValidados>&);
void Grava(const DadosCliente<Validados>&);
~~~~

Como o compilador trata `DadosCliente<Validados>` como um tipo diferente de `DadosCliente<NaoValidados>`, chamar a função `Grava` com o resultado de `DadosTela` é um erro de compilação. Quem for utilizar essas funções é obrigado a chamar a função `Valida` para mudar a *tag* associada aos dados do cliente.

Claro, essa é uma verificação que poderia ser feita durante a execução do programa, acrescentando-se uma variável booleana a `DadosCliente` e fazendo com que `Grava` a verificasse. No entanto, o compilador é capaz de encontrar erros no código mesmo que ele não seja utilizado, diferente do que acontece com testes feitos após a compilação do programa, manuais ou automatizados.
