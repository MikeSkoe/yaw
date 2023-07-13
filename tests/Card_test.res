let { test } = module(Vitest);
let { equal } = module(Vitest.Assert);

test("card", _ => {
    open Card;

    let { toUpperCase } = module(Js.String2);

    let card = empty
        ->FrontLense.set("front")
        ->BackLense.set("back");

    card->FrontLense.get->equal("front");
    card->FrontLense.fold(toUpperCase)->equal("FRONT");
    card->FrontLense.fold(toUpperCase)->equal(
        card->FrontLense.map(toUpperCase)->FrontLense.get
    );
    card->FrontLense.set("FRONT")->FrontLense.get->equal("FRONT");
});
