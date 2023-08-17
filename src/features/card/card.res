type unvalidated = {
    id: option<int>,
    front: string,
    back: string,
    description: string,
}

type t = {
    id: int,
    front: string,
    back: string,
    description: string,
    level: Level.t,
};

let empty: unvalidated = { front: "", back: "", description: "", id: None }

let validate = ({ front, back, description, id }: unvalidated) => switch (front, back) {
    | ("", _) | (_, "") => None;
    | (front, back) => Some({
        back,
        front,
        description,
        level: Level.empty,
        id: id->Option.getWithDefault((Js.Date.now() *. 10000.)->Belt.Float.toInt),
    });
};

let unvalidate = ({ front, back, description, id }: t) => ({ front, back, description, id: Some(id) });

let getFront = ({ front }) => front
let getBack = ({ back }) => back
let getDescription = ({ description }) => description
let getLevel = ({ level }) => level
let getId = ({ id }) => id;

