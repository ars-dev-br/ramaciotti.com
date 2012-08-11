---
title: Classes e Domínios
author: André Ramaciotti
tags: Domain-Driven Design
---

Quando projetando um sistema, é comum pegar os substantivos que aparecem na descrição do problema a ser resolvido e transformá-los em classes. É uma técnica inicial eficiente (afinal, deve-se começar de algum lugar), mas que logo começa a mostrar seus problemas.

Suponha que se esteja desenvolvendo um sistema de gerenciamento empresarial, e que a preocupação atual é saber como um pedido será representado. Um pedido é algo que provavelmente será representado por uma classe, então começa-se daí:

~~~~{.Cs}
class Pedido {
}
~~~~

Passa-se então a incluir informações relevantes do pedido nessa classe. E aqui surgem os problemas. O que é relevante em um pedido? Depende de quem responde essa pergunta. O estoque precisa saber que produtos foram vedidos e quantas unidades; o pessoal responsável pelas entregas precisa saber o local e a quantidade de volumes, entre outras coisas; o financeiro deve saber o valor e a forma de pagamento...

Em um primeiro momento, pode-se ficar tentado a incluir essas informações diretamente na classe que se estava projetando. Porém, note a confusão que começa a se formar:

~~~~{.Cs}
class Pedido {
    int id;

    Itens[] itens;

    decimal valor;
    FormaPagamento formaPagamento;

    Endereço localEntrega;
    int qtdVolumes;
    decimal pesoTotal;
    DateTime prazoEntrega;
}
~~~~

Apenas três departamentos da empresa foram (superficialmente) analisados e já ficou claro que essa classe `Pedido` extrapola o número de responsabilidades recomendado pelos *SOLID Principles:* uma.

Isso acontece porque a classe `Pedido` como foi criada pertence a vários domínios. Apesar de se tratar de um sistema único, existem diferentes problemas sendo resolvidos por ele: controle de estoque, fluxo de caixa, entregas... E cada um desses problemas existe em um domínio diferente. O erro do projeto inicial foi tentar usar a mesma classe para resolver esses diferentes problemas.

Quando isso fica aparente, fica mais fácil repensar a classe `Pedido` de maneira que ela não receba responsabilidades demais. Na verdade, o que se precisa é de diversas classes `Pedido`, uma para cada domínio com o qual se está trabalhando.

~~~~{.Cs}
namespace Estoque {
    class Pedido {
        int id;
        Itens[] itens;
    }
}

namespace Entregas {
    class Pedido {
        int id;

        Endereço localEntrega;
        int qtdVolumes;
        decimal pesoTotal;
        DateTime prazoEntrega;
    }
}

namespace Financeiro {
    class Pedido {
        int id;

        decimal valor;
        FormaPagamento formaPagamento;
    }
}
~~~~

Relacionando cada um dos diferentes objetos a único pedido (de um ponto de vista macro) existe uma `id` que é compartilhada entre objetos que representam o mesmo pedido, ainda que sejam informações de domínios diferentes.
