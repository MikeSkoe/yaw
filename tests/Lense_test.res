open Vitest

type nested = { a: string, b: int };
type upper = { nested: nested, b: int };

module NestedLense = {
    type context = nested;
    type value = string;
    let t = Lense.make(({ a }) => a, (t, a) => { ...t, a });
};

module UpperLense = {
    type context = upper;
    type value = nested;
    let t = Lense.make(({ nested }) => nested, (t, nested) => { ...t, nested });
};

module UpperNestedLense = Lense.Compose(UpperLense, NestedLense);

test("nested lense", _ => {
    module NestedUtils = Lense.Utils(NestedLense);
    open NestedUtils;

    let sample = { a: "a", b: 1 };
    let { toUpperCase } = module(Js.String2);

    sample->map(toUpperCase)->Assert.deepEqual({ ...sample, a: "A" });
    sample->get->Assert.equal("a")
    sample->set("HI")->Assert.deepEqual({ ...sample, a: "HI" })
});

test("composed lense", _ => {
    module UpperNestedUtils = Lense.Utils(UpperNestedLense);
    open UpperNestedUtils;

    let sample = { nested: { a: "a", b: 1 }, b: 3 }
    let { toUpperCase } = module(Js.String2);

    sample->map(toUpperCase)->Assert.deepEqual({ ...sample, nested: { ...sample.nested, a: "A" } });
    sample->get->Assert.equal("a")
    sample->set("HI")->Assert.deepEqual({ ...sample, nested: { ...sample.nested, a: "HI" } });
});
