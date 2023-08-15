@react.component
let make = (~card: Card.t, ~setCard) => {
    let getValue = event => ReactEvent.Form.target(event)["value"];
    let changeFront = event => setCard(card => card->Card.setFront(event->getValue));
    let changeBack = event => setCard(card => card->Card.setBack(event->getValue));
    let changeDescription = event => setCard(card => card->Card.setDescription(event->getValue));

    <form>
        {React.cloneElement(
            <label>{"Front: "->React.string}</label>,
            {"for": "front"},
        )}
        <input id="front" type_="text" onChange=changeFront value=card.front />
        <br />

        {React.cloneElement(
            <label>{"Back: "->React.string}</label>,
            {"for": "back"}
        )}
        <input id="back" type_="text" onChange=changeBack value=card.back />
        <br />

        {React.cloneElement(
            <label>{"Description: "->React.string}</label>,
            {"for": "description"}
        )}
        <br />
        <textarea onChange=changeDescription value=card.description id="description" name="description" rows=5 cols=40 />
        <p>{`Level: ${card.level->Level.toString}`->React.string}</p>
    </form>
}

