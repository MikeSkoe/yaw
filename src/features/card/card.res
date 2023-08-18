type unvalidated = {
    id: option<int>,
    front: string,
    back: string,
    description: string,
    level: Level.t,
}

type t = {
    id: int,
    front: string,
    back: string,
    description: string,
    stackName: string,
    level: Level.t,
};

let empty: unvalidated = {
    front: "",
    back: "",
    description: "",
    id: None,
    level: Level.empty,
}

let validate = ({
    front,
    back,
    description,
    id,
    level,
}: unvalidated, stackName: string) => switch (front, back) {
    | ("", _) | (_, "") => None;
    | (front, back) => Some({
        back,
        front,
        description,
        level,
        stackName,
        id: id->Option.getWithDefault(
            (Js.Date.now() *. 10000.)->Belt.Float.toInt,
        ),
    });
};

let unvalidate = (t: t): unvalidated => ({
    id: Some(t.id),
    front: t.front,
    back: t.back,
    description: t.description,
    level: t.level,
});

let getFront = ({ front }) => front
let getBack = ({ back }) => back
let getDescription = ({ description }) => description
let getLevel = ({ level }) => level
let getId = ({ id }) => id;
let getStackName = ({ stackName }) => stackName;

