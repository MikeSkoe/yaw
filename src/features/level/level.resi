type step;
type t =
    | New
    | Learning(step)
    | Learned;

let empty: t;
let toString: t => string;
let up: t => t;
let down: t => t;

