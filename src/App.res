module Option = Belt.Option;

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
    let make = () =>
        <>
            <h1>{"Cards list"->React.string}</h1>
            <ul>
                {CardRepository.useCards()
                ->Array.map(card => <CardView card  key={card.id->Int.toString} />)
                ->React.array}
            </ul>
        </>
}

@react.component
let make = () =>
    <div>
        {switch RescriptReactRouter.useUrl().path {
            | list{"view", id} => switch Int.fromString(id) {
                | Some(id) => <CardViewPage id />
                | None => <div>{"wrong id"->React.string}</div>
            }
            | _ => <CardsListPage />
        }}
    </div>

