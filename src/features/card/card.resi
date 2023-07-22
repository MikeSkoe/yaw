type t
let empty: t
let make: (string, string) => t

module FrontOptic: Lense.Optic with
  type context = t and
  type value = string;

module BackOptic: Lense.Optic with
  type context = t and
  type value = string;

module LevelOptic: Lense.Optic with
  type context = t and
  type value = Level.t;
