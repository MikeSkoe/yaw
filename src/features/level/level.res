type step = int;
let lowerStep = 1
let upperStep = 3

type t =
    | New
    | Learning(step)
    | Learned;

let empty = New;

let toString = t => switch t {
    | New => "new"
    | Learning(step) => `learning (${step->Belt.Int.toString})`
    | Learned => "learned"
};

let up = t => switch t {
    | New => Learning(lowerStep)
    | Learning(step) when step == upperStep => Learned
    | Learning(step) => Learning(step + 1)
    | Learned => Learned
}

let down = t => switch t {
    | New => New
    | Learning(step) when step == lowerStep => New
    | Learning(step) => Learning(step - 1)
    | Learned => Learning(upperStep)
}

