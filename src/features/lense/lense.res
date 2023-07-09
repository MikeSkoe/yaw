module type GET_SET = {
  type t;
  type value;

  let get: t => value
  let set: t => value => t
}

module type LENSE = {
  include GET_SET;

  let map: t => (value => value) => t;
  let fold: t => (value => value) => value;
}

module Make = (
  T: GET_SET,
): (LENSE with type t = T.t and type value = T.value) => {
  include T;

  let map = (context, fn) => context->T.set(context->T.get->fn)
  let fold = (context, fn) => context->T.get->fn
}

module Compose = (
  AB: GET_SET,
  BC: GET_SET with type t = AB.value,
): (GET_SET with type t = AB.t and type value = BC.value) => {
  type t = AB.t
  type value = BC.value

  let get = context => context->AB.get->BC.get

  let set = (context, value) =>
    context->AB.set(context->AB.get->BC.set(value))
}
