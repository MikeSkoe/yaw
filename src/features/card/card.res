type t = {
    id: int,
    front: string,
    back: string,
    description: string,
    level: Level.t,
};

let empty = { front: "", back: "", level: Level.empty, id: 0, description: "" };
let make = (front, back, description) => { ...empty, front, back, description };

let setFront = (t, front) => { ...t, front }
let setBack = (t, back) => { ...t, back }
let setDescription = (t, description) => { ...t, description }
let setLevel = (t, level) => { ...t, level }

