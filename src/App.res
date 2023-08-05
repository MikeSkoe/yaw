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
    @react.component
    let make = () => {
        let (card, setCard) = React.useState(() => Card.make("Front", "BACK"));

        let upLevel = 
            <button key="upLevel" onClick={_ => setCard(Card.setLevel(_, card.level->Level.up))}>
                {"up level"->React.string}
            </button>

        let downLevel =
            <button key="downLevel" onClick={_ => setCard(Card.setLevel(_, card.level->Level.down))}>
                {"down level"->React.string}
            </button>

        <>
            <button onClick={_ => RescriptReactRouter.replace("/")}>{"back to main"->React.string}</button>
            <CardView card=card>
                {switch card.level {
                | Level.New => upLevel
                | Level.Learned => downLevel
                | _ => <>{downLevel}{upLevel}</>
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

        <div className="App">
            <h1>{card.front->React.string}</h1>
            <input type_="text" value=card.front onInput=setFront />
            <input type_="text" value=card.back onInput=setBack />
            <button onClick=addCard>
                {"add"->React.string}
            </button>

            {stack.cards
                ->Belt.List.map(card => <CardView card=card/>)
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

