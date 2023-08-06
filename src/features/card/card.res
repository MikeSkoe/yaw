type t = {
    id: option<int>,
    front: string,
    back: string,
    level: Level.t,
};

let empty = { front: "", back: "", level: Level.empty, id: None };
let make = (front, back) => { ...empty, front, back };

let setFront = (t, front) => { ...t, front }
let setBack = (t, back) => { ...t, back }
let setLevel = (t, level) => { ...t, level }

