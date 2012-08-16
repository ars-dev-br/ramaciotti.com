---
title: Encapsulamento, Getters e Setters
author: André Ramaciotti
tags: Orientação a Objetos
---

Deparados com o problema de abstrair dados em um novo tipo, muitos programadores
fazem o equivalente ao código abaixo. Apesar deste exemplo ser em C++, o
problema afeta qualquer outra linguagem com orientação a objetos.

~~~~{.Cpp}
class Ponto {
public:
    Ponto() {
        x_ = 0; y_ = 0;
    }

    Ponto(float x, float y) {
        x_ = x; y_ = y;
    }

    float GetX(void) const { return x_; }
    float GetY(void) const { return y_; }

    void SetX(float x) { x_ = x; }
    void SetY(float y) { y_ = y; }

private:
    float x_, y_;
};
~~~~

Que vantagens todo esse *boilerplate* traz sobre a estrutura abaixo, muito mais
simples? Pode-se dizer que assim os dados foram *encapsulados,* mas não houve
encapsulamento de fato; criou-se apenas uma camada de indirecionamento. *Todas*
as informações contidas em um objeto da classe `Ponto` continuam acessíveis,
tanto para leitura como para escrita, mudou-se apenas a forma de como se dá esse
acesso.

~~~~{.Cpp}
struct ponto_t {
    float x, y;
};
~~~~

Além disso, a sobreabundância de *getters* e *setters* pelo código é sinal de
outro problema: os objetos estão sendo utilizados apenas como local de
armazenamento de informação e sua lógia inerente está sendo representada em
outra parte do programa. Considere o trecho a seguir.

~~~~{.Cpp}
class Conta {
public:
    Valor GetSaldo(void) { return saldo_; }
    void SetSaldo(Valor valor) { saldo_ = valor; }

    list<Movimento>& GetMovimentos(void) { return movimentos_; }

private:
    Valor saldo_;
    list<Movimento> movimentos_;
};

void Saque(Valor valor, Conta& conta) {
    if(conta.GetSaldo() > valor) {
        conta.SetSaldo(conta.GetSaldo() - valor);
        conta.GetMovimentos().push_back(Movimento(Data::Hoje(), "Saque", valor));
        cout << "Saque efetuado com sucesso." << endl;
    } else {
        cout << "Saldo insuficiente." << endl;
    }
}
~~~~

Compare com esta implementação, em que a lógica está mais bem distribuída entre
os objetos e em que não há o uso de nenhum método *get* ou *set.* Em seu livro
*Smalltalk by Example,* Alec Sharp escreve:

> Procedural code gets information then makes decisions. Object-oriented code
>  tells objects to do things.

Ou seja, ao se dar acesso ao estado de um objeto para que decisões possam ser
tomadas em outra parte do código, a orientação a objetos fica comprometida, e o
código torna-se procedural. Em um programa orientado a objetos bem organizado, o
processamento é efetuado através da troca de mensagens entre objetos e não com
um objeto alterando o estado de outro diretamente.

~~~~{.Cpp}
class Conta {
public:
    bool EfetuaSaque(Valor valor) {
        if(saldo_ < valor)
            return false;

        saldo -= valor;
        movimentos_.push_back(Movimento(Data::Hoje(), "Saque", valor));
    }

private:
    Valor saldo_;
    list<Movimento> movimentos_;
};

void Saque(Valor valor, Conta& conta) {
    if(conta.EfetuaSaque(valor))
        cout << "Saque efetuado com sucesso." << endl;
    else
        cout << "Saldo insuficiente." << endl;
}
~~~~

Obviamente, não se pode dizer que certa classe foi mal escrita simplesmente por
seu número de *getters* e *setters,* espera-se somente que se *pense* antes de
escrever qualquer método. Não é porque a IDE possui ferramentas para geração
automática desses métodos que eles devem ser criados sem que haja uma reflexão
de se o acesso externo àquela variável é mesmo imprescindível ou não. *Isso* sim
é encapsular.
