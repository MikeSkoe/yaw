module Option = Belt.Option;

@react.component
let make = (~id) => {
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

    let onSubmit = _ => {
        switch (unvalidated->Card.validate->Option.map(putCard)) {
            | None => Js.log("Not validated");
            | Some(_) => Js.log("Saved!");
        }
    }

    <dl>
        <h2>{"Front: "->React.string}</h2>
        <input onChange=changeFront value=unvalidated.front style={ReactDOMStyle.make(~width="100%", ())} />

        <br />

        <h3>{"Back: "->React.string}</h3>
        <input onChange=changeBack value=unvalidated.back style={ReactDOMStyle.make(~width="100%", ())} />

        <br />

        <p>{"Description: "->React.string}</p>
        <textarea onChange=changeDescription value=unvalidated.description style={ReactDOMStyle.make(~width="100%", ())} rows=5 />

        <br />

        <button onClick=onSubmit>{"Submit"->React.string}</button>
        <hr />
    </dl>
}

