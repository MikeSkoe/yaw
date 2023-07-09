let { test } = module(Vitest);
let { equal } = module(Vitest.Assert);

test("card", _ => {
    let card = Card.make("front", "back");
    let { map: mapFront, get: getFront, set: setFront, fold: foldFront } = module(Card.FrontLense);
    let { toUpperCase } = module(Js.String2);

    card->getFront->equal("front");
    card->foldFront(toUpperCase)->equal("FRONT");
    card->foldFront(toUpperCase)->equal(
        card->mapFront(toUpperCase)->getFront
    );
    card->setFront("FRONT")->getFront->equal("FRONT");
});
