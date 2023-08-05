module CardView = {
    @react.component
    let make = (~card: Card.t, ~children: option<React.element>=?) =>
        <div key={card.id->Belt.Int.toString}>
            <p>{card.front->React.string}</p>
            <p>{card.back->React.string}</p>
            <p>{`level: ${card.level->Level.toString}`->React.string}</p>
            {children->Belt.Option.getWithDefault(<></>)}
        </div>
}

module CardViewPage = {
    module ChangeLevel = {
        @react.component
        let make = (~setCard, ~mapLevel) => {
            let changeLevel = _ => setCard(card => card->Card.setLevel(card.level->mapLevel));

            <button onClick=changeLevel>
                {"up level"->React.string}
            </button>
        }
    }

    @react.component
    let make = () => {
        let (card, setCard) = React.useState(() => Card.make("Front", "BACK"));

        <>
            <button onClick={_ => RescriptReactRouter.replace("/")}>{"back to main"->React.string}</button>
            <CardView card=card>
                {switch card.level {
                | Level.New => <ChangeLevel key="up" setCard mapLevel=Level.up/>
                | Level.Learned => <ChangeLevel key="down" setCard mapLevel=Level.down/>
                | _ => <>
                    <ChangeLevel key="down" setCard mapLevel=Level.down/>
                    <ChangeLevel key="up" setCard mapLevel=Level.up/>
                </>
                }}
            </CardView>
        </>
    }
}

module CardsListPage = {
    @react.component
    let make = () => {
        let (card, setCard) = React.useState(() => Card.make("Front", "BACK"));
        let (stack, setStack) = React.useState(() => Stack.make("default"));

        let setFront = event => setCard(Card.setFront(_, ReactEvent.Form.target(event)["value"]));
        let setBack = event => setCard(Card.setBack(_, ReactEvent.Form.target(event)["value"]));
        let addCard = _ => setStack(stack => stack->Stack.addCard(card));
        let toView = _ => RescriptReactRouter.push("view");

        <div className="App">
            <h1>{card.front->React.string}</h1>
            <input type_="text" value=card.front onInput=setFront />
            <input type_="text" value=card.back onInput=setBack />
            <button onClick=addCard>
                {"add"->React.string}
            </button>

            {stack.cards
                ->Belt.List.map(card =>
                    <div key={card.front} onClick=toView>
                        <CardView card=card/>
                    </div>
                )
                ->Belt.List.toArray
                ->React.array
            }
        </div>
    }
}

@react.component
let make = () => switch RescriptReactRouter.useUrl().path {
    | list{"view"} => <CardViewPage/>
    | _ => <CardsListPage/>
}

