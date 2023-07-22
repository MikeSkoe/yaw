let { test } = module(Vitest);
let { equal } = module(Vitest.Assert);

module FrontLense = Lense.Make(Card.FrontOptic);
module LevelLense = Lense.Make(Card.LevelOptic);

test("card", _ => {
    let { make } = module(Card);
    let { get, set, fold, map } = module(FrontLense);
    let { toUpperCase } = module(Js.String2);
    let card = make("front", "back");

    equal(
        "front",
        card->get,
    );
    equal(
        card->fold(toUpperCase),
        card->map(toUpperCase)->get,
    );
    equal(
        "FRONT",
        card->set("FRONT")->get,
    );
});

test("card level", _ => {

    let { make } = module(Card);
    let { get, map } = module(LevelLense);
    let card = make("front", "back");

    Level.minLevel->equal(
        card->get
    );

    Level.minLevel->equal(
        card->map(Level.review(_, Level.Neutral))->get,
    );

    Level.minLevel->equal(
        card->map(Level.review(_, Level.Failed))->get,
    );

    1->equal(
        card->map(Level.review(_, Level.Success))->get,
    );

    2->equal(
        card
        ->map(Fp.compose(
            Level.review(_, Level.Success),
            Level.review(_, Level.Success),
        ))
        ->get
    );

    5->equal(
        card
        ->map(
            List.make(20, Level.review(_, Level.Success))
            ->List.reduce(Level.review(_, Level.Success), Fp.compose)
        )
        ->get
    );
});
