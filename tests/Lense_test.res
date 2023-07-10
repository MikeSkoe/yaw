open Vitest

type nested = { a: string, b: int };
type upper = { nested: nested, b: int };

module NestedLense = Lense.Utils({
    type context = nested;
    type value = string;
    let t = Lense.make(
        ({ a }) => a,
        (t, a) => { ...t, a },
    );
});

module UpperLense = Lense.Utils({
    type context = upper;
    type value = nested;
    let t = Lense.make(
        ({ nested }) => nested,
        (t, nested) => { ...t, nested },
    );
});

module UpperNestedLense = Lense.Utils({
    type context = upper;
    type value = string;
    let t = Lense.compose(
        UpperLense.lense,
        NestedLense.lense,
    )
})

test("nested lense", _ => {
    let sample = { a: "a", b: 1 };
    open NestedLense;
    let { toUpperCase } = module(Js.String2);

    sample->map(toUpperCase)->Assert.deepEqual({ ...sample, a: "A" });
    sample->get->Assert.equal("a")
    sample->set("HI")->Assert.deepEqual({ ...sample, a: "HI" })
});

test("composed lense", _ => {
    let sample = { nested: { a: "a", b: 1 }, b: 3 }
    open UpperNestedLense;
    let { toUpperCase } = module(Js.String2);

    sample->map(toUpperCase)->Assert.deepEqual({ ...sample, nested: { ...sample.nested, a: "A" } });
    sample->get->Assert.equal("a")
    sample->set("HI")->Assert.deepEqual({ ...sample, nested: { ...sample.nested, a: "HI" } });
});
