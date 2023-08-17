module Option = Belt.Option;

module CardViewPage = {
    @react.component
    let make = (~id) => {
        let card = CardRepository.useCard(id);

        <>
            <Link.Replace hash="/">
                <button>
                    {"back to main"->React.string}
                </button>
            </Link.Replace>

            {card
            ->Option.map(card => <CardPut id={card->Card.getId} />)
            ->Option.getWithDefault(React.null)}
        </>
    }
}

module CardsListPage = {
    @react.component
    let make = () =>
        <>
            <CardPut id={-1} />

            <h1>{"Cards list"->React.string}</h1>
            <ul>
                {CardRepository.useCards()
                ->Array.map(card => <CardView card  key={card->Card.getId->Int.toString} />)
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

