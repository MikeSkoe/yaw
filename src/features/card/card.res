type t = { front: string, back: string, level: Level.t };

let empty = { front: "", back: "", level: Level.empty };
let make = (front, back) => { ...empty, front, back };

module FrontOptic = {
  type context = t;
  type value = string;
  let optic = Lense.make(
    ({ front }) => front,
    (t, front) => { ...t, front },
  );
};

module BackOptic = {
  type context = t;
  type value = string;
  let optic = Lense.make(
    ({ back }) => back,
    (t, back) => { ...t, back },
  );
};

module LevelOptic = {
  type context = t;
  type value = Level.t;
  let optic = Lense.make(
    ({ level }) => level,
    (t, level) => { ...t, level },
  );
}
