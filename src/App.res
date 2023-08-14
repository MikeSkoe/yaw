open Belt;

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

            <EditableCard card setCard />

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

module CardsListPage = {
    @react.component
    let make = () => {
        let cards = CardRepository.useCards();
        let (card, setCard) = React.useState(_ => Card.empty);

        <div>
            <EditableCard card setCard />

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
let make = () => switch RescriptReactRouter.useUrl().path {
    | list{"view", id} => switch Int.fromString(id) {
        | None => <div>{"wrong id"->React.string}</div>
        | Some(id) => <CardViewPage id />}
    | _ => <CardsListPage />
}

