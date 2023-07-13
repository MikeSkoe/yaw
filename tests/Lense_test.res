open Vitest

type nested = { a: string, b: int };
type upper = { nested: nested, b: int };

module NestedOptic = {
    type context = nested;
    type value = string;
    let optic = Lense.make(({ a }) => a, (t, a) => { ...t, a });
};

module UpperOptic = {
    type context = upper;
    type value = nested;
    let optic = Lense.make(({ nested }) => nested, (t, nested) => { ...t, nested });
};

module UpperNestedLense = Lense.Compose(UpperOptic, NestedOptic);

test("nested lense", _ => {
    module NestedLense = Lense.Make(NestedOptic);
    open NestedLense;

    let sample = { a: "a", b: 1 };
    let { toUpperCase } = module(Js.String2);

    sample->map(toUpperCase)->Assert.deepEqual({ ...sample, a: "A" });
    sample->get->Assert.equal("a")
    sample->set("HI")->Assert.deepEqual({ ...sample, a: "HI" })
});

test("composed lense", _ => {
    module UpperNestedLense = Lense.Make(UpperNestedLense);
    open UpperNestedLense;

    let sample = { nested: { a: "a", b: 1 }, b: 3 }
    let { toUpperCase } = module(Js.String2);

    sample->map(toUpperCase)->Assert.deepEqual({ ...sample, nested: { ...sample.nested, a: "A" } });
    sample->get->Assert.equal("a")
    sample->set("HI")->Assert.deepEqual({ ...sample, nested: { ...sample.nested, a: "HI" } });
});
