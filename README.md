channel
=====

Description
-----

Channel library supports synchronized communication between processes.  


Why synchronized ? Why not asynchronized ?
-----

synchronized communication is simple.

Asynchronized communication brings a system a lot of states. It is difficult
to develop a system using asynchronized communication. On the other hand, 
on the system using synchoronized communication, a sender can expect that
a receiver process has recieved a message when sending it is done.
It helps to make your system simple. 

And you can use some theories like CSP to verify your system based on
synchronized communication.

If you'd like to send a asynchronous message, you can use spawn like this.

```
    spawn(fun() -> receiver(Ch) end),
```

Build
-----

    $ rebar3 compile


ToDo
-----

* Gaurd
* Choise
