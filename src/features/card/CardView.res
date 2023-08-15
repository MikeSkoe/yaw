module Option = Belt.Option;
module Int = Belt.Int;

@react.component
let make = (~card: Card.t) => {
    let deleteCard = CardRepository.useDeleteCard();

    <dl>
        <Link.Push hash=`view/${card.id->Int.toString}`>
            <h2>
                <span>{`${card.front} `->React.string}</span>
                <small>{card.level->Level.toString->React.string}</small>
            </h2>
            <p>{card.back->React.string}</p>
        </Link.Push>

        <button onClick={_ => card.id->deleteCard->ignore}>
            {"delete"->React.string}
        </button>
    </dl>
}

