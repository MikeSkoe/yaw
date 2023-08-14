@react.component
let make = (~card: Card.t, ~setCard) => {
    let getValue = event => ReactEvent.Form.target(event)["value"];
    let changeFront = event => setCard(card => card->Card.setFront(event->getValue));
    let changeBack = event => setCard(card => card->Card.setBack(event->getValue));
    let putCard = CardRepository.usePutCard();

    <div>
        <p>
            {"Front: "->React.string}
            <input type_="text" onChange=changeFront value=card.front />
        </p>

        <p>
            {"Back: "->React.string}
            <input type_="text" onChange=changeBack value=card.back />
        </p>

        <p>{`Level: ${card.level->Level.toString}`->React.string}</p>
        <button onClick={_ => putCard(card)}>{"submit"->React.string}</button>
    </div>
}

