type attempt = Failed | Neutral | Success;

type t;

let empty: t;

let review: (t, attempt) => t
