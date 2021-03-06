/**
@author initkfs
*/

подходит(варка(картофель), горчица).
подходит(варка(картофель), томат).
подходит(варка(картофель), огурец).
подходит(варка(картофель), 'лавровый лист').

подходит(жарка(картофель), укроп).

сочетание(X, Y):- подходит(X, Y); подходит(Y, X).
сочетаниеВарка(X, Y):- подходит(варка(X), Y); подходит(Y, варка(X)).
сочетаниеЖарка(X, Y):- подходит(жарка(X), Y); подходит(Y, жарка(X)).

всеСочетания(X, L):- findall(Y, сочетание(X, Y), L).

всеСочетанияВарка(X, L):- findall(Y, сочетаниеВарка(X, Y), L).
всеСочетанияЖарка(X, L):- findall(Y, сочетаниеЖарка(X, Y), L).