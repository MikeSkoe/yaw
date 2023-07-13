type t = { front: string, back: string, level: Level.t };

let empty = { front: "", back: "", level: Level.empty };

module FrontOptic = {
  type context = t;
  type value = string;
  let optic = Lense.make(
    ({ front }) => front,
    (t, front) => { ...t, front },
  );
};

module FrontLense = Lense.Make(FrontOptic);

module BackOptic = {
  type context = t;
  type value = string;
  let optic = Lense.make(
    ({ back }) => back,
    (t, back) => { ...t, back },
  );
};

module BackLense = Lense.Make(BackOptic);