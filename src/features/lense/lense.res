type optic<'context, 'value> = {
  get: 'context => 'value,
  set: 'context => 'value => 'context,
}

let make = (get, set) => { get, set };

module type Optic = {
  type context
  type value
  let optic: optic<context, value>;
}

module type Lense = {
  include Optic;

  let get: context => value;
  let set: (context, value) => context;
  let map: (context, (value => value)) => context;
  let fold: (context, (value => value)) => value;
}

module Make = (T: Optic): (
  Lense with
  type context = T.context and
  type value = T.value
) => {
  include T;
  let optic = T.optic;

  let get = T.optic.get;
  let set = T.optic.set;
  let map = (context, fn) => context->optic.set(context->optic.get->fn)
  let fold = (context, fn) => context->optic.get->fn
}

module Compose = (A: Optic, B: Optic with type context = A.value): (
  Optic with
  type context = A.context and
  type value = B.value
) => ({
  type context = A.context;
  type value = B.value;

  let optic = {
    get: context => context->A.optic.get->B.optic.get,
    set: (context, value) => context->A.optic.set(context->A.optic.get->B.optic.set(value)),
  }
});
