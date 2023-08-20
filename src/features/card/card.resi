type card = {
    id: int,
    front: string,
    back: string,
    description: string,
    stackName: string,
    stackId: int,
    level: Level.t,
}

type t = Validated(card);

let empty: card;

let makeId: unit => int;

let validate: card => option<t>;
let unvalidate: t => card;

let getFront: t => string;
let getBack: t => string;
let getDescription: t => string;
let getLevel: t => Level.t;
let getId: t => int;
let getStackName: t => string;

