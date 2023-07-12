type t<'context, 'value>;

let make: (
  'context => 'value,
  ('context, 'value) => 'context,
) => t<'context, 'value>

module type T = {
  type context
  type value
  let t: t<context, value>
}

module Utils: (T: T) => {
  let lense: t<T.context, T.value>
  let get: T.context => T.value
  let set: (T.context, T.value) => T.context
  let map: (T.context, T.value => T.value) => T.context
  let fold: (T.context, T.value => 'a) => 'a
}

module Compose: (
  A: T,
  B: T with type context = A.value,
) => {
  type context = A.context
  type value = B.value
  let t: t<context, value>
}
