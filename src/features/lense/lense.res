type t<'context, 'value> = {
  get: 'context => 'value,
  set: 'context => 'value => 'context,
}

let make: ('context => 'value) => ('context => 'value => 'context) => t<'context, 'value>
  = (get, set) => { get, set };

let compose: t<'a, 'b> => t<'b, 'c> => t<'a, 'c>
  = (tab, tbc) => {
    get: context => context->tab.get->tbc.get,
    set: (context, value) => context->tab.set(context->tab.get->tbc.set(value))
  }

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
