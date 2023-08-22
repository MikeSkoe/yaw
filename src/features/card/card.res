type unvalidated = {
    id: int,
    front: string,
    back: string,
    description: string,
    stackName: string,
    stackId: int,
    level: Level.t,
};

type t = unvalidated;

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

let validate = card => switch (card.front, card.back) {
    | ("", _) | (_, "") => None
    | _ => Some(card);
};

let unvalidate = (card) => card;

let getFront = ({ front }) => front
let getBack = ({ back }) => back
let getDescription = ({ description }) => description
let getLevel = ({ level }) => level
let getId = ({ id }) => id;
let getStackName = ({ stackName }) => stackName;
let getStackId = ({ stackId }) => stackId;

