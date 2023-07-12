type t<'context, 'value> = {
  get: 'context => 'value,
  set: 'context => 'value => 'context,
}

let make: ('context => 'value) => ('context => 'value => 'context) => t<'context, 'value>
  = (get, set) => { get, set };

module type T = {
  type context
  type value
  let t: t<context, value>;
}

module Utils = (T: T) => {
  let lense = T.t;

  let get = T.t.get;
  let set = T.t.set;
  let map = (context, fn) => context->lense.set(context->lense.get->fn)
  let fold = (context, fn) => context->lense.get->fn
}

module Compose = (
  A: T,
  B: T with type context = A.value,
): (
  T with
  type context = A.context and
  type value = B.value
) => ({
  type context = A.context;
  type value = B.value;

  let t = {
    get: context => context->A.t.get->B.t.get,
    set: (context, value) => context->A.t.set(context->A.t.get->B.t.set(value)),
  }
})
