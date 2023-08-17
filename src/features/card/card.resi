type unvalidated = {
    id: option<int>,
    front: string,
    back: string,
    description: string,
}

type t;

let empty: unvalidated;

let validate: unvalidated => option<t>;
let unvalidate: t => unvalidated;

let getFront: t => string;
let getBack: t => string;
let getDescription: t => string;
let getLevel: t => Level.t;
let getId: t => int;

