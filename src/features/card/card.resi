type t;

let make: string => string => t;

module FrontLense: Lense.LENSE with type t = t and type value = string;
module BackLense: Lense.LENSE with type t = t and type value = string;
