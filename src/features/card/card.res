type card = {
    id: int,
    front: string,
    back: string,
    description: string,
    stackName: string,
    stackId: int,
    level: Level.t,
};

type t = Validated(card);

let empty = {
    front: "",
    back: "",
    description: "",
    id: 0,
    level: Level.empty,
    stackName: "",
    stackId: 0,
};

let makeId = () => Belt.Float.toInt(Js.Date.now() *. 10000.);

let validate = (card: card): option<t> => switch (card.front, card.back) {
    | ("", _) | (_, "") => None
    | _ => Some(Validated(card));
};

let unvalidate = (Validated(card)) => card;

let getFront = (Validated({ front })) => front
let getBack = (Validated({ back })) => back
let getDescription = (Validated({ description })) => description
let getLevel = (Validated({ level })) => level
let getId = (Validated({ id })) => id;
let getStackName = (Validated({ stackName })) => stackName;

