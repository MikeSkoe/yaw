open Vitest

type nested = { a: string, b: int };
type upper = { nested: nested, b: int };

module NestedGetSet: Lense.GET_SET with type t = nested and type value = string = {
    type t = nested;
    type value = string;

    let get = ({ a }) => a;
    let set = (t, a) => { ...t, a };
}

module UpperGetSet: Lense.GET_SET with type t = upper and type value = nested = {
    type t = upper;
    type value = nested;

    let get = ({ nested }) => nested;
    let set = (t, nested) => { ...t, nested };
}

test("nested lense", _ => {
    module NestedLense = Lense.Make(NestedGetSet);
    let sample = { a: "a", b: 1 };
    let { map, get, set } = module(NestedLense);

    sample
    ->map(Js.String2.toUpperCase)
    ->Assert.deepEqual({ ...sample, a: "A" });

    sample
    ->get
    ->Assert.equal("a")

    sample
    ->set("HI")
    ->Assert.deepEqual({ ...sample, a: "HI" })
});

test("composed lense", _ => {
    module ComposedGetSet = Lense.Compose(UpperGetSet, NestedGetSet);
    module ComposedLense = Lense.Make(ComposedGetSet);

    let sample = { nested: { a: "a", b: 1 }, b: 3 }
    let { map } = module(ComposedLense);
    let { get, set } = module(ComposedGetSet);

    sample
    ->map(Js.String2.toUpperCase)
    ->Assert.deepEqual({ ...sample, nested: { ...sample.nested, a: "A" } });

    sample
    ->get
    ->Assert.equal("a")

    sample
    ->set("HI")
    ->Assert.deepEqual({ ...sample, nested: { ...sample.nested, a: "HI" } });
});
