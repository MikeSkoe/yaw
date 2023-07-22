type attempt = Failed | Neutral | Success;

type t = int;

let empty: t;
let minLevel: t;
let maxLevel: t;

let review: (t, attempt) => t
