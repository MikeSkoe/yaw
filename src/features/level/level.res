type attempt = Failed | Neutral | Success;

type t = int;

let maxLevel = 5;
let minLevel = 0;
let empty = 0;

let review: (t, attempt) => t
    = (level, attempt) => {
        let level = level + switch attempt {
            | Failed => -1
            | Neutral => 0
            | Success => 1
        };

        level < minLevel
            ? minLevel
        : level > maxLevel
            ? maxLevel
            : level;
    }
