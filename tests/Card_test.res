let { test } = module(Vitest);
let { equal } = module(Vitest.Assert);

test("card", _ => {
    let card = Card.make("front", "back");
    let { toUpperCase } = module(Js.String2);
    module FrontLense = Lense.Utils(Card.FrontLense);

    card->FrontLense.get->equal("front");
    card->FrontLense.fold(toUpperCase)->equal("FRONT");
    card->FrontLense.fold(toUpperCase)->equal(
        card->FrontLense.map(toUpperCase)->FrontLense.get
    );
    card->FrontLense.set("FRONT")->FrontLense.get->equal("FRONT");
});
