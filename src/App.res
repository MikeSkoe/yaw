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

module StackPut = {
    @react.component
    let make = () => {
        let (value, setValue) = React.useState(_ => "");
        let putStack = StackRepository.usePutStack();
        let onValue = (fn, event) => fn(ReactEvent.Form.target(event)["value"]);
        let onClick = _ => {
            // TODO: implement validated stack type
            if value != "" {
                putStack(Stack.make(Stack.makeId(), value, list{}));
                Js.log("Saved!");
            }
            Js.log("Type longer name");
        }

        <div>
            <input value onChange=onValue(setValue) />
            <button onClick>{"Submit"->React.string}</button>
        </div>
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
                    ->Array.map(name => <Link.Replace hash=`/stack/${name}` key=name>
                        <li>
                            {name->React.string}
                        </li>
                    </Link.Replace>)
                    ->React.array}
                </ul>
                <StackPut />
            </dl>
            <CardPut id={-1} stackName />

            <h1>{`Cards list [${stackName}]`->React.string}</h1>
            <ul>
                {stack.boxes
                ->Map.toArray
                ->Array.map(((key, value)) => <div key={key->Level.toString}>
                    <h2>{key->Level.toString->React.string}</h2>
                    <div style={ReactDOMStyle.make(~display="flex", ~overflow="auto", ())}>
                        {value
                        ->List.map(card => <CardView card key={card->Card.getId->Int.toString} />)
                        ->List.toArray
                        ->React.array}
                    </div>
                </div>)
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
                | Some(id) => <CardViewPage id stackName=Stack.empty.name />
                | None => <div>{"wrong id"->React.string}</div>
            }
            | list{"stack", stackName} => <StackPage stackName />
            | _ => <StackPage stackName=Stack.empty.name />
        }}
    </div>

