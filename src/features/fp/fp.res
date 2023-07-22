let compose: ('a => 'b, 'b => 'c) => 'a => 'c
    = (fn1, fn2, arg) => arg->fn1->fn2;
