let { test } = module(Vitest);
let { equal } = module(Vitest.Assert);

test("card", _ => {
    let card = Card.make("front", "back");
    let { toUpperCase } = module(Js.String2);
    open Card.FrontLense;

    card->get->equal("front");
    card->fold(toUpperCase)->equal("FRONT");
    card->fold(toUpperCase)->equal(
        card->map(toUpperCase)->get
    );
    card->set("FRONT")->get->equal("FRONT");
});
