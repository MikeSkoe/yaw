open Belt;

module CardsSchema = {
    type id = int;
    type t = Card.t;

    let tableName = "cards";
    let schema = [("cards", "++id,front,back,level")];
}

module CardsDexie = Dexie.Table.MakeTable(CardsSchema);

module DexieContext = {
    let context = React.createContext(None)

    module Provider = {
        let make = React.Context.provider(context)
    }

    module WithDexie = {
        @react.component
        let make = (~children) => {
            let (dexieOption, setDexie) = React.useState(_ => None);

            React.useEffect0(() => {
                let dexie = Dexie.Database.make("cards");

                dexie
                ->Dexie.Database.version(1)
                ->Dexie.Version.stores(CardsSchema.schema)
                ->ignore;

                setDexie(_ => Some(dexie))
                None;
            });

            <Provider value=dexieOption>
                {children}
            </Provider>
        }
    }
}

module CardRepository = {
    let useCards = () => {
        let dexieOption = React.useContext(DexieContext.context);

        let cards = Dexie.LiveQuery.use1(
            async () => switch dexieOption {
                | None => None
                | Some(dexie) => Some(
                    await dexie
                        ->CardsDexie.where("id")
                        ->Dexie.Where.notEqual(-1)
                        ->Dexie.Collection.toArray
                )
            },
            [dexieOption],
        );

        cards->Option.getWithDefault([]);
    }

    let useCard = (id) => {
        let dexieOption = React.useContext(DexieContext.context);

        let card = Dexie.LiveQuery.use1(async () => switch dexieOption {
            | None => None
            | Some(dexie) => await dexie->CardsDexie.getById(id);
        }, [dexieOption]);

        let setCard: (Card.t => Card.t) => unit
            = fn => switch (card, dexieOption) {
                | (Some(card), Some(dexie)) => dexie->CardsDexie.put(fn(card))->ignore;
                | _ => None->ignore;
            };

        (card->Option.getWithDefault(Card.empty), setCard);
    }

    let usePutCard = () => {
        let dexieOption = React.useContext(DexieContext.context);
        let putCard = dexieOption
            ->Option.map(dexie => (card, _) => dexie->CardsDexie.put(card)->ignore)
            ->Option.getWithDefault((_, _) => 0->ignore);

        putCard;
    }
}

module Link = {
    module Push = {
        @react.component
        let make = (~hash, ~id, ~children) =>
            <div onClick={_ => RescriptReactRouter.push(`${hash}/${id}`)}>
                {children}
            </div>
    }

    module Replace = {
        @react.component
        let make = (~hash, ~children) =>
            <div onClick={_ => RescriptReactRouter.replace(hash)}>
                {children}
            </div>
    }
}

module CardView = {
    @react.component
    let make = (~card: Card.t, ~children: option<React.element>=?) =>
        <div key={card.id->Option.getWithDefault(0)->Int.toString}>
            <p>{card.front->React.string}</p>
            <p>{card.back->React.string}</p>
            <p>{`level: ${card.level->Level.toString}`->React.string}</p>
            {children->Option.getWithDefault(<></>)}
        </div>
}

module AddCard = {
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
            <button onClick={putCard(card)}>{"submit"->React.string}</button>
        </div>
    }
}

module CardViewPage = {
    module ChangeLevel = {
        @react.component
        let make = (~setCard, ~mapLevel, ~label) =>
            <button onClick={_ => setCard(card => card->Card.setLevel(card.level->mapLevel))}>
                {label->React.string}
            </button>
    }

    @react.component
    let make = (~id) => {
        let (card, setCard) = CardRepository.useCard(id);

        <>
            <Link.Replace hash="/">
                <button>
                    {"back to main"->React.string}
                </button>
            </Link.Replace>

            <AddCard card setCard />

            {switch card.level {
            | Level.New => <ChangeLevel label="up level" key="up" key="up" setCard mapLevel=Level.up/>
            | Level.Learned => <ChangeLevel label="down level" key="up" key="down" setCard mapLevel=Level.down/>
            | _ => <>
                <ChangeLevel label="down level" key="down" setCard mapLevel=Level.down/>
                <ChangeLevel label="up level" key="up" setCard mapLevel=Level.up/>
            </>
            }}
        </>
    }
}

module CardsList = {
    @react.component
    let make = () => {
        let cards = CardRepository.useCards();
        let (card, setCard) = React.useState(_ => Card.empty);

        <div>
            <AddCard card setCard />

            {cards
            ->Array.map(card => {
                let id = card.id->Option.mapWithDefault("", Int.toString);

                <Link.Push hash="view" id key={id}>
                    <CardView card/>
                </Link.Push>;
            })
            ->React.array}
        </div>
    }
}

@react.component
let make = () =>
    <DexieContext.WithDexie>
        {switch RescriptReactRouter.useUrl().path {
        | list{"view", id} => switch Int.fromString(id) {
            | None => <div>{"wrong id"->React.string}</div>
            | Some(id) => <CardViewPage id />}
        | _ => <CardsList />
        }}
    </DexieContext.WithDexie>;

