type unvalidated = {
    id: option<int>,
    front: string,
    back: string,
    description: string,
    level: Level.t,
}

type t;

let empty: unvalidated;

let validate: (unvalidated, string) => option<t>;
let unvalidate: t => unvalidated;

let getFront: t => string;
let getBack: t => string;
let getDescription: t => string;
let getLevel: t => Level.t;
let getId: t => int;
let getStackName: t => string;

