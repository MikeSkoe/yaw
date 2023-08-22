type unvalidated = {
    id: int,
    front: string,
    back: string,
    description: string,
    stackName: string,
    stackId: int,
    level: Level.t,
}

type t;

let empty: unvalidated;

let makeId: unit => int;

let validate: unvalidated => option<t>;
let unvalidate: t => unvalidated;

let getFront: t => string;
let getBack: t => string;
let getDescription: t => string;
let getLevel: t => Level.t;
let getId: t => int;
let getStackName: t => string;
let getStackId: t => int;

