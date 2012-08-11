---
title: Bot para Pidgin usando Python e DBus
author: André Ramaciotti
tags: Python
---

Eu e meu amigo Augusto temos uma brincadeira: sempre que um fala “cara”, o outro responde com “coroa”. Isso começou quando ele estava com uma mania chata de começar metade de suas histórias com “cara”. Espero que um dia ela acabe.

O problema dessa brincadeira é que nunca sabíamos quem ganhou. Eu cheguei a criar um pequeno *script* em Python que resolvia esta questão, mas não era sempre que me animava para executá-lo e ver o resultado.

~~~~{.Python}
import random
print random.choice(["cara", "coroa"])
~~~~

Resolvi então escrever um *script* mais avançado que se comunicasse diretamente com o Pidgin e detectasse quando era hora de lançar uma moeda e reportar seu resultado. Ele começa como a grande maioria dos programas escritos em Python, importando os módulos necessários.

Em seguida, há a definição da função `throw_coin` que é a função de *callback* chamada quando o programa receber o sinal *DisplayedImMsg.* Basicamente, ela verifica se já existe uma entrada no dicionário contendo as últimas mensagens para a conversa atual. Se existir, ela verifica se há a sequência de mensagens “cara” e “coroa”. Caso haja, envia uma mensagem dizendo qual foi o resultado.

O restante do código é a inicialização necessária para que o programa funcione corretamente. A sessão DBus é acessada, junto com o objeto e a interface usados para acessar a biblioteca Purple, sobre a qual o Pidgin é implementado. Há também a associação entre o sinal *DisplayedImMsg* e o início do *loop* principal do programa, no qual ele fica à espera de um sinal.

~~~~{.Python}
!/usr/bin/env python2
# -*- encoding: utf-8 -*-

import dbus
import gobject
import random
from dbus.mainloop.glib import DBusGMainLoop

def throw_coin(account, sender, message, conversation, flags):
    global purple
    global ultimas_msgs

    ultima_msg = ""
    if conversation in ultimas_msgs.keys():
        ultima_msg = ultimas_msgs[conversation]

    if ultima_msg == "cara" and message == "coroa":
        resultado = "[Mensagem automática] " + random.choice(["cara", "coroa"])
        purple.PurpleConvImSend(purple.PurpleConvIm(conversation), resultado)
        ultimas_msgs[conversation] = ""
    else:
        ultimas_msgs[conversation] = message

dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
bus = dbus.SessionBus()
obj = bus.get_object("im.pidgin.purple.PurpleService",
                     "/im/pidgin/purple/PurpleObject")
purple = dbus.Interface(obj, "im.pidgin.purple.PurpleInterface")
ultimas_msgs = {}

bus.add_signal_receiver(throw_coin,
                        dbus_interface="im.pidgin.purple.PurpleInterface",
                        signal_name="DisplayedImMsg")

loop = gobject.MainLoop()
loop.run()
~~~~
