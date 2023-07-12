type t = {
  front: string,
  back: string,
}

let make = (front, back) => { front, back };

module FrontLense = {
  type context = t;
  type value = string;
  let t = Lense.make(
    ({ front }) => front,
    (t, front) => { ...t, front },
  );
};

module BackLense = {
  type context = t;
  type value = string;
  let t = Lense.make(
    ({ back }) => back,
    (t, back) => { ...t, back },
  );
};
