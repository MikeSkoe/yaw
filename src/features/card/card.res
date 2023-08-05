type t = {
    id: int,
    front: string,
    back: string,
    level: Level.t,
};

let empty = { front: "", back: "", level: Level.empty, id: 0 };
let make = (front, back) => { ...empty, front, back, id: Js.Math.random_int(0, 999999) };

let setFront = (t, front) => { ...t, front }
let setBack = (t, back) => { ...t, back }
let setLevel = (t, level) => { ...t, level }

