type t = {
    id: int,
    front: string,
    back: string,
    description: string,
    level: Level.t,
};

let empty: t;
let make: (string, string, string) => t;
let setFront: (t, string) => t;
let setBack: (t, string) => t;
let setDescription: (t, string) => t;
let setLevel: (t, Level.t) => t;

