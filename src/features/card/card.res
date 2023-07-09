type t = {
  front: string,
  back: string,
}

let make = (front, back) => { front, back };

module FrontGetSet: Lense.GET_SET with type t = t and type value = string = {
  type t = t;
  type value = string;

  let get = ({ front }) => front;
  let set = (t, front) => { ...t, front };
}

module BackGetSet: Lense.GET_SET with type t = t and type value = string = {
  type t = t;
  type value = string;

  let get = ({ back }) => back;
  let set = (t, back) => { ...t, back };
}

module FrontLense = Lense.Make(FrontGetSet);
module BackLense = Lense.Make(BackGetSet);
