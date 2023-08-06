type t = {
    id: option<int>,
    front: string,
    back: string,
    level: Level.t,
};

let empty: t;
let make: (string, string) => t;
let setFront: (t, string) => t;
let setBack: (t, string) => t;
let setLevel: (t, Level.t) => t;

