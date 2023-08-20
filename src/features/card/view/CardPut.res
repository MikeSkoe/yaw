module Option = Belt.Option;
module Promise = Js.Promise2;

@react.component
let make = (~id, ~stackName) => {
    let putCard = CardRepository.usePutCard(stackName);
    let card = CardRepository.useCard(id);
    let onValue = (fn, event) => fn(ReactEvent.Form.target(event)["value"]);
    let (unvalidated, setUnvalidated) = React.useState(_ => Card.empty);

    React.useLayoutEffect1(() => {
        card
        ->Option.map(Card.unvalidate)
        ->Option.forEach(unvalidated => setUnvalidated(_ => unvalidated));
        None;
    }, [card]);

    let changeFront = front => setUnvalidated(unvalidated => { ...unvalidated, front });
    let changeBack = back => setUnvalidated(unvalidated => { ...unvalidated, back });
    let changeDescription = description => setUnvalidated(unvalidated => { ...unvalidated, description });
    let upLevel = _ => setUnvalidated(unvalidated => { ...unvalidated, level: unvalidated.level->Level.up });
    let downLevel = _ => setUnvalidated(unvalidated => { ...unvalidated, level: unvalidated.level->Level.down });
    let stackName = card->Option.map(Card.getStackName)->Option.getWithDefault(stackName);

    let onSubmit = _ => {
        {
            ...unvalidated,
            id: card->Option.map((Validated({id})) => id)->Option.getWithDefault(Card.makeId())
        }
        ->putCard
        ->Promise.then(result => switch result {
            | Error(msg) => Js.log(msg);
            | Ok(_) => {
                setUnvalidated(_ => Card.empty);
                Js.log("Saved!");
            }
        }->Promise.resolve)
        ->ignore;
    }

    <dl>
        <h3>
            {"Stack: "->React.string}
            <b>{stackName->React.string}</b>
        </h3>
        <b>{"Front: "->React.string}</b>
        <input onChange=onValue(changeFront) value=unvalidated.front />

        <br />

        <b>{"Back: "->React.string}</b>
        <input onChange=onValue(changeBack) value=unvalidated.back />

        <br />

        <b style={ReactDOMStyle.make(~verticalAlign="top", ())}>
            {"Description: "->React.string}
        </b>
        <textarea onChange=onValue(changeDescription) value=unvalidated.description rows=3 />

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

