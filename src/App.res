module Option = Belt.Option;
module Array = Belt.Array;
module Map = Belt.Map;
module List = Belt.List;

module CardViewPage = {
    @react.component
    let make = (~id, ~stackName) => {
        let card = CardRepository.useCard(id);

        <>
            <Link.Replace hash="/">
                <button>
                    {"back to main"->React.string}
                </button>
            </Link.Replace>

            {card
            ->Option.map(card => <CardPut id={card->Card.getId} stackName />)
            ->Option.getWithDefault(React.null)}
        </>
    }
}

module StackPage = {
    @react.component
    let make = (~stackName) => {
        let stack = StackRepository.useStack(stackName);
        let stackNames = StackRepository.useStackNames();

        <>
            <dl>
                <h3>{"Stacks: "->React.string}</h3>
                <ul>
                    {stackNames
                    ->Array.map(name => <li key=name>{name->React.string}</li>)
                    ->React.array}
                </ul>
            </dl>
            <CardPut id={-1} stackName />

            <h1>{`Cards list [${stackName}]`->React.string}</h1>
            <ul>
                {stack.boxes
                ->Map.toArray
                ->Array.map(((key, value)) => <>
                    <h2>{key->Level.toString->React.string}</h2>
                    <div style={ReactDOMStyle.make(~display="flex", ~overflow="auto", ())}>
                        {value
                        ->List.map(card => <CardView card key={card->Card.getId->Int.toString} />)
                        ->List.toArray
                        ->React.array}
                    </div>
                </>)
                ->React.array}
            </ul>
        </>
    }
}

@react.component
let make = () =>
    <div>
        {switch RescriptReactRouter.useUrl().path {
            | list{"view", id} => switch Int.fromString(id) {
                | Some(id) => <CardViewPage id stackName="unnamed" />
                | None => <div>{"wrong id"->React.string}</div>
            }
            | _ => <StackPage stackName="unnamed" />
        }}
    </div>

