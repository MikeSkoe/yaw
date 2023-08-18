module Option = Belt.Option;

@react.component
let make = (~id, ~stackName) => {
    let putCard = CardRepository.usePutCard();
    let card = CardRepository.useCard(id);
    let getValue = event => ReactEvent.Form.target(event)["value"];
    let (unvalidated, setUnvalidated) = React.useState(_ => Card.empty);

    React.useEffect1(() => {
        card
        ->Option.map(Card.unvalidate)
        ->Option.forEach(unvalidated => setUnvalidated(_ => unvalidated));
        None;
    }, [card])

    let changeFront = event => setUnvalidated(unvalidated => { ...unvalidated, front: event->getValue });
    let changeBack = event => setUnvalidated(unvalidated => { ...unvalidated, back: event->getValue });
    let changeDescription = event => setUnvalidated(unvalidated => { ...unvalidated, description: event->getValue });
    let upLevel = _ => setUnvalidated(unvalidated => { ...unvalidated, level: unvalidated.level->Level.up });
    let downLevel = _ => setUnvalidated(unvalidated => { ...unvalidated, level: unvalidated.level->Level.down });
    let stackName = card->Option.map(Card.getStackName)->Option.getWithDefault(stackName);

    let onSubmit = _ => {
        switch (unvalidated->Card.validate(stackName)->Option.map(putCard)) {
            | None => Js.log("Not validated");
            | Some(_) => {
                if (card->Option.isNone) {
                    setUnvalidated(_ => Card.empty);
                }
                Js.log("Saved!");
            };
        }
    }

    <dl>
        <h3>{"Stack: "->React.string}<b>{stackName->React.string}</b></h3>
        <b>{"Front: "->React.string}</b>
        <input onChange=changeFront value=unvalidated.front />

        <br />

        <b>{"Back: "->React.string}</b>
        <input onChange=changeBack value=unvalidated.back />

        <br />

        <b style={ReactDOMStyle.make(~verticalAlign="top", ())}>{"Description: "->React.string}</b>
        <textarea onChange=changeDescription value=unvalidated.description rows=3 />

        <br />

        {card
        ->Option.map(_ => <>
            <b>{"Level: "->React.string}</b>
            <button onClick=downLevel>{"lower"->React.string}</button>
            {unvalidated.level->Level.toString->React.string}
            <button onClick=upLevel>{"higher"->React.string}</button>
        </>)
        ->Option.getWithDefault(React.null)}

        <br />
        <br />

        <button onClick=onSubmit>{"Submit"->React.string}</button>

        <hr />
    </dl>
}

