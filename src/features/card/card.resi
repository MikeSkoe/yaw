type t = {front: string, back: string, level: Level.t}
let empty: t

module FrontOptic: Lense.Optic with
  type context = t and
  type value = string;

module FrontLense: Lense.Lense with
  type context = t and
  type value = string;

module BackOptic: Lense.Optic with
  type context = t and
  type value = string;

module BackLense: Lense.Lense with
  type context = t and
  type value = string;
