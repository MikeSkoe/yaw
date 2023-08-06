module CardView = {
    @react.component
    let make = (~card: Card.t, ~children: option<React.element>=?) =>
        <div key={card.id->Belt.Option.getWithDefault(0)->Belt.Int.toString}>
            <p>{card.front->React.string}</p>
            <p>{card.back->React.string}</p>
            <p>{`level: ${card.level->Level.toString}`->React.string}</p>
            {children->Belt.Option.getWithDefault(<></>)}
        </div>
}

module CardViewPage = {
    module ChangeLevel = {
        @react.component
        let make = (~setCard, ~mapLevel) =>
            <button onClick={_ => setCard(card => card->Card.setLevel(card.level->mapLevel))}>
                {"up level"->React.string}
            </button>
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

module CardsSchema = {
    type id = int;
    type t = Card.t;
    let tableName = "cards";
    let schema = [("cards", "++id,front,back,level")];
}

module CardsDexie = Dexie.Table.MakeTable(CardsSchema);

let useDexieOption = (): option<Dexie.Database.t> => {
    let (dexieOption, setDexie) = React.useState(_ => None);

    React.useEffect0(() => {
        let dexie = Dexie.Database.make("cards")
        dexie
        ->Dexie.Database.version(1)
        ->Dexie.Version.stores(CardsSchema.schema)
        ->ignore;

        setDexie(_prev => Some(dexie))
        None;
    });

    dexieOption;
}

module AddCard = {
    @react.component
    let make = (~dexie) => {
        let (card, setCard) = React.useState(_ => Card.empty);
        let getValue = (event): string => ReactEvent.Form.target(event)["value"];
        let changeFront = event => setCard(card => card->Card.setFront(event->getValue));
        let changeBack = event => setCard(card => card->Card.setBack(event->getValue));

        <div>
            <p>
                {"Front: "->React.string}
                <input type_="text" onChange=changeFront value=card.front />
            </p>
            <p>
                {"Back: "->React.string}
                <input type_="text" onChange=changeBack value=card.back />
            </p>
            <p>
                {`Level: ${card.level->Level.toString}`->React.string}
            </p>
            <button onClick={_ => {
                dexie->CardsDexie.put(card)->ignore;
                setCard(_ => Card.empty);
            }}>{"submit"->React.string}</button>
        </div>
    }
}

module CardsList = {
    @react.component
    let make = (~dexie) => {
        let card = Dexie.LiveQuery.use0(
            async () => {
                let arr = await dexie->CardsDexie.where("id")->Dexie.Where.notEqual(-1)->Dexie.Collection.toArray;
                Some(arr);
            },
        );
        let onClick = _ => RescriptReactRouter.push("view");

        <div>
            <AddCard dexie />
            {switch card {
            | None => <div>{"no cards"->React.string}</div>
            | Some(cards) => <div>{cards->Belt.Array.map(card => <div onClick><CardView card /></div>)->React.array}</div>
            }}
        </div>
    }
}

module CardsListPage = {
    @react.component
    let make = () => switch useDexieOption() {
        | None => <div>{"((("->React.string}</div>
        | Some(dexie) => <CardsList dexie />
    }
}

@react.component
let make = () => switch RescriptReactRouter.useUrl().path {
    | list{"view"} => <CardViewPage/>
    | _ => <CardsListPage />
}

